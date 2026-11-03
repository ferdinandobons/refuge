import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import 'downloads.dart';
import 'kiwix_catalog.dart';
import 'zim_library.dart';

/// Catalogo Kiwix: raccolte consigliate e ricerca libera.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late Future<List<(String, List<CatalogEntry>)>> _results = _recommended();
  final _query = TextEditingController();

  Future<List<(String, List<CatalogEntry>)>> _recommended() => Future.wait([
    for (final (name, note) in kRecommended)
      KiwixCatalog.byName(name).then((l) => (note, l)),
  ]);

  void _search(String q) => setState(() {
    _results = q.trim().isEmpty
        ? _recommended()
        : KiwixCatalog.search(q.trim())
              .then((l) => [('Risultati per "${q.trim()}"', l)]);
  });

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Scarica enciclopedie')),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(
            controller: _query,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Cerca nel catalogo Kiwix (es. medicine, ifixit)',
              border: OutlineInputBorder(),
            ),
            onSubmitted: _search,
          ),
        ),
        Expanded(
          child: FutureBuilder<List<(String, List<CatalogEntry>)>>(
            future: _results,
            builder: (context, snap) {
              if (snap.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Catalogo non raggiungibile. Serve una connessione a internet.\n\n${snap.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListenableBuilder(
                listenable: Listenable.merge([
                  ZimDownloads.instance,
                  ZimLibrary.instance,
                ]),
                builder: (context, _) => ListView(
                  padding: const EdgeInsets.only(bottom: 32),
                  children: [
                    for (final (heading, entries) in snap.data!)
                      if (entries.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
                          child: Text(
                            heading,
                            style: const TextStyle(
                              color: kAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        for (final e in entries) _EntryTile(e),
                      ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

class _EntryTile extends StatelessWidget {
  const _EntryTile(this.e);

  final CatalogEntry e;

  @override
  Widget build(BuildContext context) {
    final installed = ZimLibrary.instance.books.any(
      (b) => b.file.uri.pathSegments.last == e.fileName,
    );
    final downloading = ZimDownloads.instance.isDownloading(e);
    final date = e.updated == null
        ? ''
        : ' · ${e.updated!.month.toString().padLeft(2, '0')}/${e.updated!.year}';
    return ListTile(
      title: Text(
        e.flavour.isEmpty ? e.title : '${e.title} · ${e.flavourLabel}',
      ),
      subtitle: Text(
        '${formatBytes(e.size)}$date · ${e.language}\n${e.summary}',
        maxLines: 3,
      ),
      isThreeLine: true,
      trailing: installed
          ? const Icon(Icons.check_circle, color: Colors.lightGreen)
          : e.isZimit
          ? const Tooltip(
              message:
                  'Sito web archiviato (zimit): formato non ancora supportato',
              child: Icon(Icons.block, color: Colors.white38),
            )
          : downloading
          ? const Icon(Icons.downloading, color: kAccent)
          : IconButton(
              icon: const Icon(Icons.download, color: kAccent),
              tooltip: 'Scarica',
              onPressed: () => _confirm(context),
            ),
    );
  }

  Future<void> _confirm(BuildContext context) async {
    var wifiOnly = e.size > 500e6;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (c, setState) => AlertDialog(
          title: Text('Scaricare ${formatBytes(e.size)}?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${e.title}${e.flavour.isEmpty ? '' : ' (${e.flavourLabel.toLowerCase()})'}',
              ),
              const SizedBox(height: 12),
              const Text(
                'Assicurati di avere abbastanza spazio libero. Il download continua anche ad app chiusa '
                'e riprende da dove si era fermato.',
                style: TextStyle(color: Colors.white70),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Solo con Wi-Fi'),
                value: wifiOnly,
                onChanged: (v) => setState(() => wifiOnly = v ?? true),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('Annulla'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Scarica'),
            ),
          ],
        ),
      ),
    );
    if (ok == true) await ZimDownloads.instance.start(e, wifiOnly: wifiOnly);
  }
}
