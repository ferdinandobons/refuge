import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'guide.dart';

/// Ordine e icone dei temi, ricavati dal nome del file (`pc-terremoto-cosa-fare` → terremoto),
/// così valgono in tutte le lingue.
const kTopics = <String, IconData>{
  'nucleare': Icons.radar,
  'industriale': Icons.factory,
  'terremoto': Icons.house_siding,
  'incendi': Icons.local_fire_department,
  'alluvione': Icons.flood,
  'maremoto': Icons.tsunami,
  'grandi': Icons.water,
  'vulcani': Icons.volcano,
};

String _topic(String id) => id.split('-').elementAtOrNull(1) ?? '';

IconData guideIcon(String id) => kTopics[_topic(id)] ?? Icons.article;

int _topicRank(String id) {
  final i = kTopics.keys.toList().indexOf(_topic(id));
  return i < 0 ? kTopics.length : i;
}

/// Carica i file Markdown inclusi nell'app sotto [folder].
Future<List<Guide>> loadMarkdownAssets(String folder) async {
  final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  // Solo i file della cartella, non quelli delle sottocartelle.
  final paths = manifest
      .listAssets()
      .where((p) => p.startsWith(folder) && p.endsWith('.md') && !p.substring(folder.length).contains('/'));
  return [
    for (final p in paths) Guide.parse(p.split('/').last.replaceAll('.md', ''), await rootBundle.loadString(p)),
  ];
}

/// Guide della Protezione Civile: in italiano tutte (anche quelle che valgono solo per l'Italia),
/// nelle altre lingue solo quelle tradotte perché utili in tutta Europa (`assets/guides/<lingua>/`).
class GuideRepository {
  static final _cache = <String, Future<List<Guide>>>{};

  static Future<List<Guide>> load(String language) => _cache[language] ??= _load(language);

  static Future<List<Guide>> _load(String language) async {
    final guides = await loadMarkdownAssets(language == 'it' ? 'assets/guides/' : 'assets/guides/$language/');
    guides.sort((a, b) {
      final c = _topicRank(a.id).compareTo(_topicRank(b.id));
      if (c != 0) return c;
      final o = a.order.compareTo(b.order);
      return o != 0 ? o : a.title.compareTo(b.title);
    });
    return guides;
  }
}
