import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../app/theme.dart';
import '../../../l10n/app_localizations.dart';
import 'zim_archive.dart';
import 'zim_library.dart';
import 'zim_server.dart';

/// Lettura di un file ZIM (Wikipedia, WikiMed…) in una WebView alimentata dal server locale.
class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key, required this.book, this.entryUrl});

  final ZimBook book;
  final String? entryUrl;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final _web = WebViewController();
  int _progress = 0;
  bool _canGoBack = false;

  @override
  void initState() {
    super.initState();
    _web
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (p) => setState(() => _progress = p),
        onPageFinished: (_) async {
          final back = await _web.canGoBack();
          if (mounted) setState(() => _canGoBack = back);
        },
        onNavigationRequest: (req) {
          final uri = Uri.tryParse(req.url);
          if (uri == null || ZimServer.instance.isLocal(uri) || uri.scheme == 'about') {
            return NavigationDecision.navigate;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).externalLink)),
          );
          return NavigationDecision.prevent;
        },
      ));
    unawaited(_open(widget.entryUrl));
  }

  Future<void> _open(String? entryUrl) async =>
      _web.loadRequest(await ZimServer.instance.urlFor(widget.book.id, entryUrl));

  Future<void> _search() async {
    final entry = await showSearch<ZimEntry?>(
      context: context,
      delegate: _TitleSearch(widget.book.archive, AppLocalizations.of(context)),
    );
    if (entry != null) await _open(entry.url);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return PopScope(
        canPop: !_canGoBack,
        onPopInvokedWithResult: (didPop, _) async {
          if (!didPop && await _web.canGoBack()) await _web.goBack();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            actions: [
              IconButton(icon: const Icon(Icons.search), tooltip: t.search, onPressed: _search),
              IconButton(icon: const Icon(Icons.home), tooltip: t.mainPage, onPressed: () => _open(null)),
            ],
            bottom: _progress < 100
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(2),
                    child: LinearProgressIndicator(value: _progress / 100, minHeight: 2),
                  )
                : null,
          ),
          body: WebViewWidget(controller: _web),
        ),
      );
  }
}

class _TitleSearch extends SearchDelegate<ZimEntry?> {
  _TitleSearch(this.archive, this.t) : super(searchFieldLabel: t.searchByTitle);

  final ZimArchive archive;
  final AppLocalizations t;

  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);

  @override
  List<Widget> buildActions(BuildContext context) =>
      [if (query.isNotEmpty) IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) =>
      IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().length < 2) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(t.searchByTitleTip, style: const TextStyle(color: Colors.white60)),
      );
    }
    return FutureBuilder<List<ZimEntry>>(
      future: archive.searchTitles(query),
      builder: (context, snap) {
        if (!snap.hasData) return const LinearProgressIndicator(minHeight: 2);
        final hits = snap.data!;
        if (hits.isEmpty) {
          return Padding(padding: const EdgeInsets.all(24), child: Text(t.searchEmpty));
        }
        return ListView(children: [
          for (final e in hits)
            ListTile(
              leading: const Icon(Icons.article, color: kAccent),
              title: Text(e.title),
              onTap: () => close(context, e),
            ),
        ]);
      },
    );
  }
}
