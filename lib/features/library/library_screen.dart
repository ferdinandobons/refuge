import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/settings.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import 'document_screen.dart';
import 'documents.dart';
import 'zim/catalog_screen.dart';
import 'zim/downloads.dart';
import 'zim/kiwix_catalog.dart';
import 'zim/reader_screen.dart';
import 'zim/zim_library.dart';

/// Biblioteca: enciclopedie offline (file ZIM) e documenti ufficiali originali.
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
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.library),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: ZimLibrary.instance.refresh)],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([ZimLibrary.instance, ZimDownloads.instance]),
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionTitle(t.encyclopedias),
            if (ZimLibrary.instance.books.isEmpty && ZimLibrary.instance.loaded)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(t.noEncyclopedias, style: const TextStyle(color: Colors.white60)),
              ),
            for (final b in ZimLibrary.instance.books) _BookTile(b),
            for (final s in ZimDownloads.instance.active) _DownloadTile(s),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              icon: const Icon(Icons.download),
              label: Text(t.downloadEncyclopedias),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CatalogScreen())),
            ),
            if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(t.iosImportHint, style: const TextStyle(color: Colors.white38, fontSize: 13)),
              ),
            const SizedBox(height: 24),
            _SectionTitle(t.documents),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(t.documentsBody, style: const TextStyle(color: Colors.white60)),
            ),
            const _Documents(),
          ],
        ),
      ),
    );
  }
}

class _BookTile extends StatelessWidget {
  const _BookTile(this.book);

  final ZimBook book;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 6, 4, 6),
        leading: book.icon == null
            ? const Icon(Icons.public, color: kAccent, size: 32)
            : Image.memory(book.icon!, width: 32, height: 32),
        title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${languageName(book.language)} · ${formatBytes(book.size)}\n${book.description}', maxLines: 3),
        trailing: PopupMenuButton<String>(
          onSelected: (_) => _delete(context, t),
          itemBuilder: (_) => [PopupMenuItem(value: 'delete', child: Text(t.deleteFromDevice))],
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReaderScreen(book: book))),
      ),
    );
  }

  Future<void> _delete(BuildContext context, AppLocalizations t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(t.deleteQ(book.title)),
        content: Text(t.deleteBody(formatBytes(book.size))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(t.cancel)),
          TextButton(onPressed: () => Navigator.pop(c, true), child: Text(t.delete)),
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
    final t = AppLocalizations.of(context);
    final paused = s.status == TaskStatus.paused;
    final pct = (s.progress.clamp(0, 1) * 100).toStringAsFixed(1);
    final detail = switch (s.status) {
      TaskStatus.enqueued => t.dlWaiting,
      TaskStatus.waitingToRetry => t.dlRetrying,
      TaskStatus.paused => t.dlPaused(pct),
      _ => '$pct%${s.expectedSize > 0 ? ' · ${formatBytes(s.expectedSize)}' : ''}'
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
            tooltip: paused ? t.resume : t.pause,
            onPressed: () => paused ? ZimDownloads.instance.resume(s) : ZimDownloads.instance.pause(s),
          ),
          IconButton(icon: const Icon(Icons.close), tooltip: t.cancel, onPressed: () => ZimDownloads.instance.cancel(s)),
        ]),
      ),
    );
  }
}

class _Documents extends StatefulWidget {
  const _Documents();

  @override
  State<_Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<_Documents> {
  late final Future<List<OfficialDocument>> _docs = loadDocuments(AppSettings.instance.language).then((d) async {
    await DocumentFiles.instance.refresh(d);
    return d;
  });

  Future<void> _download(OfficialDocument d) async {
    final messenger = ScaffoldMessenger.of(context);
    final t = AppLocalizations.of(context);
    if (!await DocumentFiles.instance.download(d)) messenger.showSnackBar(SnackBar(content: Text(t.docDownloadFailed)));
  }

  Future<void> _delete(OfficialDocument d) async {
    final t = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(t.deleteQ(d.title)),
        content: Text(t.deleteBody(formatBytes(d.size))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(t.cancel)),
          TextButton(onPressed: () => Navigator.pop(c, true), child: Text(t.delete)),
        ],
      ),
    );
    if (ok == true) await DocumentFiles.instance.delete(d);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final files = DocumentFiles.instance;
    return FutureBuilder<List<OfficialDocument>>(
      future: _docs,
      builder: (context, snap) => ListenableBuilder(
        listenable: files,
        builder: (context, _) => Column(children: [
          if (!snap.hasData) const Center(child: CircularProgressIndicator()),
          for (final d in snap.data ?? const <OfficialDocument>[])
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
                leading: Icon(Icons.picture_as_pdf, color: files.isAvailable(d) ? kAccent : Colors.white38, size: 32),
                title: Text(d.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text([
                  '${d.author.split(RegExp(r' \(| – |, |;')).first} · ${d.year} · ${d.language.toUpperCase()}',
                  if (files.progress[d.file] case final p?)
                    t.docDownloading((p * 100).toStringAsFixed(0))
                  else if (!files.isAvailable(d))
                    t.docToDownload(formatBytes(d.size))
                  else
                    t.pagesN(d.pages),
                ].join('\n')),
                trailing: files.progress.containsKey(d.file)
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3)),
                      )
                    : PopupMenuButton<String>(
                        onSelected: (v) => switch (v) {
                          'info' => showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => DocumentInfo(doc: d),
                            ),
                          'download' => _download(d),
                          _ => _delete(d),
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(value: 'info', child: Text(t.sources)),
                          if (!files.isAvailable(d)) PopupMenuItem(value: 'download', child: Text(t.download)),
                          if (!d.bundled && files.isAvailable(d))
                            PopupMenuItem(value: 'delete', child: Text(t.deleteFromDevice)),
                        ],
                      ),
                onTap: () => files.isAvailable(d)
                    ? Navigator.push(context, MaterialPageRoute(builder: (_) => DocumentScreen(doc: d)))
                    : _download(d),
              ),
            ),
        ]),
      ),
    );
  }
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
