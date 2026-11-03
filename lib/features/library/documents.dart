import 'dart:convert';

import 'package:flutter/services.dart';

/// Documento ufficiale incluso nell'app, riprodotto integralmente (vedi `assets/documents/catalog.json`).
class OfficialDocument {
  const OfficialDocument({
    required this.file,
    required this.title,
    required this.author,
    required this.year,
    required this.language,
    required this.pages,
    required this.category,
    required this.description,
    required this.license,
    required this.source,
  });

  factory OfficialDocument.fromJson(Map<String, dynamic> j) => OfficialDocument(
        file: j['file'] as String,
        title: j['title'] as String,
        author: j['author'] as String,
        year: j['year'] as int,
        language: j['language'] as String,
        pages: j['pages'] as int,
        category: j['category'] as String,
        description: j['description'] as String,
        license: j['license'] as String,
        source: j['source'] as String,
      );

  final String file, title, author, language, category, description, license, source;
  final int year, pages;

  String get asset => 'assets/documents/$file';
}

Future<List<OfficialDocument>>? _cache;

Future<List<OfficialDocument>> loadDocuments() => _cache ??= rootBundle
    .loadString('assets/documents/catalog.json')
    .then((s) => [for (final j in jsonDecode(s) as List) OfficialDocument.fromJson(j as Map<String, dynamic>)]);
