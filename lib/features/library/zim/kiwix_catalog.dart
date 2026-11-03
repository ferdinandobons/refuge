import 'dart:convert';
import 'dart:io';

import 'package:xml/xml.dart';

/// Voce del catalogo ufficiale Kiwix (OPDS): https://opds.library.kiwix.org
class CatalogEntry {
  const CatalogEntry({
    required this.name,
    required this.flavour,
    required this.title,
    required this.summary,
    required this.language,
    required this.size,
    required this.updated,
    required this.articleCount,
    required this.downloadUrl,
  });

  final String name, flavour, title, summary, language;
  final int size, articleCount;
  final DateTime? updated;
  final Uri downloadUrl;

  String get fileName => downloadUrl.pathSegments.last;

  /// Siti web archiviati con zimit: richiedono un riproduttore apposito, non ancora supportato.
  bool get isZimit => downloadUrl.path.contains('/zimit/');

  /// Versione: "mini" (solo introduzioni), "nopic" (senza immagini), "maxi" (completa).
  String get flavourLabel => switch (flavour) {
        'mini' => 'Mini: solo l\'introduzione di ogni voce',
        'nopic' => 'Completa, senza immagini',
        'maxi' => 'Completa, con immagini',
        _ => 'Completa',
      };
}

/// Raccolte consigliate, in ordine di utilità per l'emergenza.
const kRecommended = <(String name, String note)>[
  ('mdwiki_en_all', 'WikiMed: enciclopedia medica (inglese)'),
  ('wikipedia_it_all', 'Wikipedia in italiano'),
  ('wikipedia_en_all', 'Wikipedia in inglese'),
  ('wikivoyage_it_all', 'Wikivoyage: guide di paesi e città (italiano)'),
  ('libretexts.org_en_med', 'Libri di testo di medicina (inglese)'),
];

class KiwixCatalog {
  static final _base = Uri.parse('https://opds.library.kiwix.org/catalog/v2/entries');

  static Future<List<CatalogEntry>> byName(String name) => _query({'name': name, 'count': '20'});

  static Future<List<CatalogEntry>> search(String text) => _query({'q': text, 'count': '40'});

  static Future<List<CatalogEntry>> _query(Map<String, String> params) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 20);
    try {
      final req = await client.getUrl(_base.replace(queryParameters: params));
      final res = await req.close();
      if (res.statusCode != 200) throw HttpException('Catalogo non raggiungibile (${res.statusCode})');
      return parseFeed(await res.transform(utf8.decoder).join());
    } finally {
      client.close();
    }
  }

  static List<CatalogEntry> parseFeed(String xml) {
    final doc = XmlDocument.parse(xml);
    final out = <CatalogEntry>[];
    for (final e in doc.findAllElements('entry')) {
      String text(String tag) => e.getElement(tag)?.innerText.trim() ?? '';
      final link = e.findElements('link').where((l) => l.getAttribute('rel')?.endsWith('acquisition/open-access') ?? false);
      if (link.isEmpty) continue;
      final href = link.first.getAttribute('href') ?? '';
      // Il link .meta4 punta al file reale; download.kiwix.org reindirizza al mirror più vicino.
      final url = Uri.parse(href.replaceFirst('://lb.download.', '://download.').replaceAll(RegExp(r'\.meta4$'), ''));
      out.add(CatalogEntry(
        name: text('name'),
        flavour: text('flavour'),
        title: text('title'),
        summary: text('summary'),
        language: text('language'),
        size: int.tryParse(link.first.getAttribute('length') ?? '') ?? 0,
        updated: DateTime.tryParse(text('updated')),
        articleCount: int.tryParse(text('articleCount')) ?? 0,
        downloadUrl: url,
      ));
    }
    const order = {'mini': 0, 'nopic': 1, 'maxi': 2};
    out.sort((a, b) => (order[a.flavour] ?? 3).compareTo(order[b.flavour] ?? 3));
    return out;
  }
}

String formatBytes(int bytes) {
  if (bytes >= 1e9) return '${(bytes / 1e9).toStringAsFixed(1).replaceAll('.', ',')} GB';
  if (bytes >= 1e6) return '${(bytes / 1e6).round()} MB';
  return '${(bytes / 1e3).round()} kB';
}
