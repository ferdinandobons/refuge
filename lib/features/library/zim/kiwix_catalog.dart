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

}

/// Tipo di raccolta consigliata (il titolo viene tradotto nell'interfaccia).
enum Recommended { wikimed, wikipediaMedicine, wikipedia, wikivoyage, medicalTextbooks }

/// Raccolte consigliate, in ordine di utilità per l'emergenza: ognuna nella lingua scelta e in inglese.
/// Le raccolte che non esistono in una lingua semplicemente non compaiono.
List<(String name, Recommended kind, String language)> recommendedFor(String language) {
  final langs = {language, 'en'};
  return [
    ('mdwiki_en_all', Recommended.wikimed, 'en'),
    for (final l in langs) ('wikipedia_${l}_medicine', Recommended.wikipediaMedicine, l),
    for (final l in langs) ('wikipedia_${l}_all', Recommended.wikipedia, l),
    for (final l in langs) ('wikivoyage_${l}_all', Recommended.wikivoyage, l),
    ('libretexts.org_en_med', Recommended.medicalTextbooks, 'en'),
  ];
}

/// Nome della lingua (nella lingua stessa) da un codice ISO 639-1 o 639-3 del catalogo, es. "ita" → "Italiano".
String languageName(String code) {
  const iso3 = {'ita': 'it', 'eng': 'en', 'fra': 'fr', 'deu': 'de', 'spa': 'es'};
  const names = {'it': 'Italiano', 'en': 'English', 'fr': 'Français', 'de': 'Deutsch', 'es': 'Español'};
  final parts = code.split(',').map((c) => names[iso3[c.trim()] ?? c.trim()] ?? c.trim()).toList();
  return parts.length > 3 ? '${parts.take(3).join(', ')}…' : parts.join(', ');
}

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
