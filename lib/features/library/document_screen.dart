import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import 'documents.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key, required this.doc, this.initialPage = 1});

  final OfficialDocument doc;
  final int initialPage;

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final _controller = PdfViewerController();
  late final _searcher = PdfTextSearcher(_controller)..addListener(_refresh);
  final _query = TextEditingController();
  bool _searching = false;

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _searcher
      ..removeListener(_refresh)
      ..dispose();
    _query.dispose();
    super.dispose();
  }

  void _showInfo() => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => DocumentInfo(doc: widget.doc),
      );

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final matches = _searcher.matches.length;
    final current = _searcher.currentIndex;
    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                controller: _query,
                autofocus: true,
                decoration: InputDecoration(hintText: t.searchDocument, border: InputBorder.none),
                onSubmitted: (q) => q.trim().isEmpty ? _searcher.resetTextSearch() : _searcher.startTextSearch(q.trim()),
              )
            : Text(widget.doc.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (_searching && matches > 0) ...[
            Center(child: Text('${(current ?? 0) + 1}/$matches')),
            IconButton(icon: const Icon(Icons.keyboard_arrow_up), onPressed: _searcher.goToPrevMatch),
            IconButton(icon: const Icon(Icons.keyboard_arrow_down), onPressed: _searcher.goToNextMatch),
          ],
          IconButton(
            icon: Icon(_searching ? Icons.close : Icons.search),
            tooltip: t.search,
            onPressed: () => setState(() {
              _searching = !_searching;
              if (!_searching) {
                _query.clear();
                _searcher.resetTextSearch();
              }
            }),
          ),
          IconButton(icon: const Icon(Icons.info_outline), tooltip: t.sources, onPressed: _showInfo),
        ],
      ),
      body: Column(
        children: [
          if (_searcher.isSearching) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: PdfViewer.asset(
              widget.doc.asset,
              controller: _controller,
              initialPageNumber: widget.initialPage,
              params: PdfViewerParams(
                backgroundColor: kSurface,
                pagePaintCallbacks: [_searcher.pageTextMatchPaintCallback],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DocumentInfo extends StatelessWidget {
  const DocumentInfo({super.key, required this.doc});

  final OfficialDocument doc;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    const label = TextStyle(color: Colors.white54, fontSize: 13);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(doc.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('${doc.author} · ${doc.year} · ${t.pagesN(doc.pages)} · ${doc.language.toUpperCase()}',
              style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Text(doc.description),
          const SizedBox(height: 16),
          Text(t.license.toUpperCase(), style: label),
          Text(doc.license),
          const SizedBox(height: 12),
          Text(t.sources.toUpperCase(), style: label),
          SelectableText(doc.source),
          const SizedBox(height: 12),
          Text(t.reproducedInFull, style: const TextStyle(color: Colors.lightGreen)),
        ]),
      ),
    );
  }
}
