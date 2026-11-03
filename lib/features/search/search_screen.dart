import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/settings.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../emergency/card_screen.dart';
import '../emergency/cards.dart';
import '../guides/guide_repository.dart';
import '../guides/guide_screen.dart';
import '../library/document_screen.dart';
import '../library/documents.dart';
import '../library/library_screen.dart';
import '../library/zim/reader_screen.dart';
import '../library/zim/zim_library.dart';
import '../tools/tools_screen.dart';
import 'search_index.dart';

class _Result {
  const _Result(this.title, this.subtitle, this.icon, this.color, this.open);

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final WidgetBuilder open;
}

/// Ricerca unica su tutto: schede, strumenti, liste, testi originali, documenti ed enciclopedie scaricate.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Indexed<_Result>>? _index;
  List<_Result> _results = [];
  List<_Result> _encyclopedia = [];
  String _query = '';
  Timer? _debounce;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _index ??= [];
    if (_index!.isEmpty) _build();
  }

  Future<void> _build() async {
    final t = AppLocalizations.of(context);
    final s = AppSettings.instance;
    final index = <Indexed<_Result>>[];

    for (final c in await loadCards(s.language, s.country, t)) {
      index.add(Indexed(
        _Result(c.title, t.tabEmergency, c.icon, c.color, (_) => CardScreen(card: c)),
        title: c.title,
        keywords: c.keywords,
        body: '${c.steps.join(' ')} ${c.never.join(' ')}',
      ));
    }
    for (final tool in toolItems(t)) {
      index.add(Indexed(
        _Result(tool.title, t.tabTools, tool.icon, kAccent, tool.builder),
        title: tool.title,
        keywords: tool.keywords,
        body: tool.subtitle,
        priority: 1,
      ));
    }
    for (final g in await GuideRepository.load(s.language)) {
      index.add(Indexed(
        _Result(g.title, '${t.civilProtectionGuides} · ${g.category}', Icons.article, Colors.white70,
            (_) => GuideScreen(guide: g)),
        title: g.title,
        keywords: g.category,
        body: g.searchText,
        priority: 3,
      ));
    }
    final docs = await loadDocuments(s.language);
    await DocumentFiles.instance.refresh(docs);
    for (final d in docs) {
      index.add(Indexed(
        _Result(d.title, t.documents, Icons.picture_as_pdf, Colors.white70,
            (_) => DocumentFiles.instance.isAvailable(d) ? DocumentScreen(doc: d) : const LibraryScreen()),
        title: d.title,
        body: d.description(s.language),
        priority: 4,
      ));
    }
    if (mounted) setState(() => _index = index);
    if (_query.isNotEmpty) _run(_query);
  }

  void _onChanged(String q) {
    _query = q;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), () => _run(q));
  }

  Future<void> _run(String q) async {
    final local = search<_Result>(_index ?? const [], q);
    setState(() {
      _results = local;
      _encyclopedia = [];
    });
    // Voci delle enciclopedie scaricate (per titolo), dopo i risultati locali.
    if (q.trim().length < 3) return;
    final library = ZimLibrary.instance;
    if (!library.loaded) await library.refresh();
    final hits = <_Result>[];
    for (final book in library.books) {
      for (final e in await book.archive.searchTitles(q.trim(), limit: 8)) {
        hits.add(_Result(e.title, book.title, Icons.public, Colors.white70,
            (_) => ReaderScreen(book: book, entryUrl: e.url)));
      }
    }
    if (mounted && q == _query) setState(() => _encyclopedia = hits);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final all = [..._results, ..._encyclopedia];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          autofocus: true,
          style: const TextStyle(fontSize: 19),
          decoration: InputDecoration(hintText: t.searchHint, border: InputBorder.none),
          onChanged: _onChanged,
        ),
      ),
      body: _query.trim().isEmpty
          ? Padding(padding: const EdgeInsets.all(24), child: Text(t.searchTip, style: const TextStyle(color: Colors.white54)))
          : all.isEmpty
              ? Padding(padding: const EdgeInsets.all(24), child: Text(t.searchEmpty))
              : ListView.builder(
                  itemCount: all.length,
                  itemBuilder: (context, i) {
                    final r = all[i];
                    return ListTile(
                      leading: Icon(r.icon, color: r.color),
                      title: Text(r.title, style: const TextStyle(fontSize: 17)),
                      subtitle: Text(r.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: r.open)),
                    );
                  },
                ),
    );
  }
}
