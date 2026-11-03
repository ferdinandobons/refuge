import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'document_screen.dart';
import 'documents.dart';
import 'zim/catalog_screen.dart';
import 'zim/downloads.dart';
import 'zim/kiwix_catalog.dart';
import 'zim/reader_screen.dart';
import 'zim/zim_library.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    ZimLibrary.instance.refresh();
    ZimDownloads.instance.init();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Biblioteca'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Aggiorna elenco file',
              onPressed: ZimLibrary.instance.refresh,
            ),
          ],
        ),
        body: ListenableBuilder(
          listenable: Listenable.merge([ZimLibrary.instance, ZimDownloads.instance]),
          builder: (context, _) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _SectionTitle('Enciclopedie offline'),
              if (ZimLibrary.instance.books.isEmpty && ZimLibrary.instance.loaded)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Nessuna enciclopedia sul dispositivo. Scarica Wikipedia o WikiMed finché hai internet: '
                    'poi funzioneranno anche senza rete.',
                    style: TextStyle(color: Colors.white60),
                  ),
                ),
              for (final b in ZimLibrary.instance.books) _BookTile(b),
              for (final s in ZimDownloads.instance.active) _DownloadTile(s),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                icon: const Icon(Icons.download),
                label: const Text('Scarica Wikipedia, WikiMed e altre'),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CatalogScreen())),
              ),
              if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'File molto grandi: scaricali sul computer da download.kiwix.org e copiali con il Finder '
                    'o l\'app File nella cartella Rifugio › zim, poi tocca ↻.',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 24),
              const _SectionTitle('Documenti ufficiali (inclusi)'),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('Manuali originali riprodotti integralmente. Funzionano senza internet.',
                    style: TextStyle(color: Colors.white60)),
              ),
              const _Documents(),
            ],
          ),
        ),
      );
}

class _BookTile extends StatelessWidget {
  const _BookTile(this.book);

  final ZimBook book;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          contentPadding: const EdgeInsets.fromLTRB(16, 6, 4, 6),
          leading: book.icon == null
              ? const Icon(Icons.public, color: kAccent, size: 32)
              : Image.memory(book.icon!, width: 32, height: 32),
          title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text('${formatBytes(book.size)} · ${book.language}\n${book.description}', maxLines: 3),
          trailing: PopupMenuButton<String>(
            onSelected: (_) => _delete(context),
            itemBuilder: (_) => const [PopupMenuItem(value: 'delete', child: Text('Elimina dal dispositivo'))],
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReaderScreen(book: book))),
        ),
      );

  Future<void> _delete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Eliminare "${book.title}"?'),
        content: Text('Libererai ${formatBytes(book.size)}. Per riaverlo dovrai scaricarlo di nuovo.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Annulla')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Elimina')),
        ],
      ),
    );
    if (ok == true) await ZimLibrary.instance.delete(book);
  }
}

class _DownloadTile extends StatelessWidget {
  const _DownloadTile(this.s);

  final DownloadState s;

  @override
  Widget build(BuildContext context) {
    final paused = s.status == TaskStatus.paused;
    final pct = (s.progress.clamp(0, 1) * 100).toStringAsFixed(1);
    final detail = switch (s.status) {
      TaskStatus.enqueued => 'In attesa (serve Wi-Fi se richiesto)…',
      TaskStatus.waitingToRetry => 'Connessione persa, riprovo…',
      TaskStatus.paused => 'In pausa · $pct%',
      _ => '$pct%${s.expectedSize > 0 ? ' di ${formatBytes(s.expectedSize)}' : ''}'
          '${s.speedMBs > 0 ? ' · ${s.speedMBs.toStringAsFixed(1)} MB/s' : ''}'
          '${s.remaining.inMinutes > 0 ? ' · ~${s.remaining.inMinutes} min' : ''}',
    };
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 4, 10),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              LinearProgressIndicator(value: s.progress > 0 ? s.progress : null),
              const SizedBox(height: 4),
              Text(detail, style: const TextStyle(color: Colors.white60, fontSize: 13)),
            ]),
          ),
          IconButton(
            icon: Icon(paused ? Icons.play_arrow : Icons.pause),
            tooltip: paused ? 'Riprendi' : 'Pausa',
            onPressed: () => paused ? ZimDownloads.instance.resume(s) : ZimDownloads.instance.pause(s),
          ),
          IconButton(icon: const Icon(Icons.close), tooltip: 'Annulla', onPressed: () => ZimDownloads.instance.cancel(s)),
        ]),
      ),
    );
  }
}

class _Documents extends StatelessWidget {
  const _Documents();

  @override
  Widget build(BuildContext context) => FutureBuilder<List<OfficialDocument>>(
        future: loadDocuments(),
        builder: (context, snap) => Column(children: [
          if (!snap.hasData) const Center(child: CircularProgressIndicator()),
          for (final d in snap.data ?? const <OfficialDocument>[])
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                leading: const Icon(Icons.picture_as_pdf, color: kAccent, size: 32),
                title: Text(d.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('${d.author.split(' – ').first} · ${d.year} · ${d.pages} pag. · '
                    '${d.language == 'en' ? 'inglese' : d.language}'),
                trailing: IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: 'Fonte e licenza',
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => DocumentInfo(doc: d),
                  ),
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DocumentScreen(doc: d))),
              ),
            ),
        ]),
      );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 6),
        child: Text(text.toUpperCase(),
            style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
      );
}
