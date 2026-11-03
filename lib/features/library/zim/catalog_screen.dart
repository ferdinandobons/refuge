import 'package:flutter/material.dart';

import '../../../app/settings.dart';
import '../../../app/theme.dart';
import '../../../l10n/app_localizations.dart';
import 'downloads.dart';
import 'kiwix_catalog.dart';
import 'zim_library.dart';

/// Catalogo Kiwix: raccolte consigliate per la lingua scelta e ricerca libera.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late Future<List<(String, List<CatalogEntry>)>> _results;
  final _query = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _results = _recommended(AppLocalizations.of(context));
  }

  Future<List<(String, List<CatalogEntry>)>> _recommended(AppLocalizations t) => Future.wait([
        for (final (name, kind, lang) in recommendedFor(AppSettings.instance.language))
          KiwixCatalog.byName(name).then((l) => ('${_heading(t, kind)} · ${languageName(lang)}', l)),
      ]);

  static String _heading(AppLocalizations t, Recommended kind) => switch (kind) {
        Recommended.wikimed => t.recWikimed,
        Recommended.wikipediaMedicine => t.recWikipediaMedicine,
        Recommended.wikipedia => t.recWikipedia,
        Recommended.wikivoyage => t.recWikivoyage,
        Recommended.medicalTextbooks => t.recMedicalTextbooks,
      };

  void _search(String q) {
    final t = AppLocalizations.of(context);
    setState(() {
      _results = q.trim().isEmpty
          ? _recommended(t)
          : KiwixCatalog.search(q.trim()).then((l) => [(t.resultsFor(q.trim()), l)]);
    });
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.downloadEncyclopedias)),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(
            controller: _query,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: t.catalogSearchHint,
              border: const OutlineInputBorder(),
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
                    child: Text(t.catalogUnreachable, textAlign: TextAlign.center),
                  ),
                );
              }
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              return ListenableBuilder(
                listenable: Listenable.merge([ZimDownloads.instance, ZimLibrary.instance]),
                builder: (context, _) => ListView(
                  padding: const EdgeInsets.only(bottom: 32),
                  children: [
                    for (final (heading, entries) in snap.data!)
                      if (entries.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
                          child: Text(heading,
                              style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        for (final e in entries) _EntryTile(e),
                      ],
                  ],
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}

String flavourLabel(AppLocalizations t, String flavour) => switch (flavour) {
      'mini' => t.flavourMini,
      'nopic' => t.flavourNopic,
      'maxi' => t.flavourMaxi,
      _ => t.flavourFull,
    };

class _EntryTile extends StatelessWidget {
  const _EntryTile(this.e);

  final CatalogEntry e;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final installed = ZimLibrary.instance.books.any((b) => b.file.uri.pathSegments.last == e.fileName);
    final downloading = ZimDownloads.instance.isDownloading(e);
    final date = e.updated == null ? '' : ' · ${e.updated!.month.toString().padLeft(2, '0')}/${e.updated!.year}';
    final Widget trailing;
    if (installed) {
      trailing = const Icon(Icons.check_circle, color: Colors.lightGreen);
    } else if (e.isZimit) {
      trailing = Tooltip(message: t.zimitUnsupported, child: const Icon(Icons.block, color: Colors.white38));
    } else if (downloading) {
      trailing = const Icon(Icons.downloading, color: kAccent);
    } else {
      trailing = IconButton(
        icon: const Icon(Icons.download, color: kAccent),
        tooltip: t.download,
        onPressed: () => _confirm(context, t),
      );
    }
    return ListTile(
      title: Text('${e.title} · ${flavourLabel(t, e.flavour)}'),
      subtitle: Text.rich(
        TextSpan(children: [
          TextSpan(
            text: languageName(e.language),
            style: const TextStyle(color: kAccent, fontWeight: FontWeight.w600),
          ),
          TextSpan(text: ' · ${formatBytes(e.size)}$date\n${e.summary}'),
        ]),
        maxLines: 3,
      ),
      isThreeLine: true,
      trailing: trailing,
    );
  }

  Future<void> _confirm(BuildContext context, AppLocalizations t) async {
    var wifiOnly = e.size > 500e6;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (c, setState) => AlertDialog(
          title: Text(t.downloadQ(formatBytes(e.size))),
          content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${e.title} (${flavourLabel(t, e.flavour).toLowerCase()})'),
            const SizedBox(height: 12),
            Text(t.downloadBody, style: const TextStyle(color: Colors.white70)),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(t.wifiOnly),
              value: wifiOnly,
              onChanged: (v) => setState(() => wifiOnly = v ?? true),
            ),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: Text(t.cancel)),
            FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(t.download)),
          ],
        ),
      ),
    );
    if (ok == true) await ZimDownloads.instance.start(e, wifiOnly: wifiOnly);
  }
}
