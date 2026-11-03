import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'guide.dart';

/// Ordine e icone delle categorie. Le categorie non elencate finiscono in fondo.
const kCategories = <String, IconData>{
  'Primo soccorso': Icons.medical_services,
  'Bombardamenti': Icons.warning_amber,
  'Rischio nucleare': Icons.radar,
  'Rischio chimico e industriale': Icons.factory,
  'Terremoto': Icons.house_siding,
  'Incendi': Icons.local_fire_department,
  'Alluvione': Icons.flood,
  'Maremoto': Icons.tsunami,
  'Dighe': Icons.water,
  'Vulcani': Icons.volcano,
  'Acqua': Icons.water_drop,
  'Igiene e malattie': Icons.sanitizer,
  'Cibo': Icons.restaurant,
  'Fuoco e riparo': Icons.fireplace,
  'Orientamento': Icons.explore,
  'Comunicazioni': Icons.cell_tower,
};

IconData categoryIcon(String category) => kCategories[category] ?? Icons.article;

int _categoryRank(String c) {
  final i = kCategories.keys.toList().indexOf(c);
  return i < 0 ? kCategories.length : i;
}

/// Carica i file Markdown inclusi nell'app sotto [folder].
Future<List<Guide>> loadMarkdownAssets(String folder) async {
  final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  final paths = manifest.listAssets().where((p) => p.startsWith(folder) && p.endsWith('.md'));
  return [
    for (final p in paths) Guide.parse(p.split('/').last.replaceAll('.md', ''), await rootBundle.loadString(p)),
  ];
}

class GuideRepository {
  static Future<List<Guide>>? _cache;

  static Future<List<Guide>> load() => _cache ??= _load();

  static Future<List<Guide>> _load() async {
    final guides = await loadMarkdownAssets('assets/guides/');
    guides.sort((a, b) {
      final c = _categoryRank(a.category).compareTo(_categoryRank(b.category));
      if (c != 0) return c;
      final o = a.order.compareTo(b.order);
      return o != 0 ? o : a.title.compareTo(b.title);
    });
    return guides;
  }
}
