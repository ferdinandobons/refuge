import 'package:flutter/material.dart';

import '../../app/settings.dart';
import '../library/document_screen.dart';
import '../library/documents.dart';
import '../library/zim/reader_screen.dart';
import '../library/zim/zim_library.dart';
import '../../l10n/app_localizations.dart';
import 'guide_repository.dart';
import 'guide_screen.dart';

/// Rimandi dentro le guide:
/// - `doc:file.pdf#pagina`: documento ufficiale, aperto alla pagina indicata
/// - `doc:id`: la stessa opera nella lingua scelta (o in inglese)
/// - `guide:id`: un'altra guida
/// - `zim:Titolo`: voce di un'enciclopedia scaricata (WikiMed, Wikipedia…)
IconData guideTargetIcon(String target) => switch (target.split(':').first) {
      'doc' => Icons.picture_as_pdf,
      'guide' => Icons.menu_book,
      'zim' => Icons.public,
      _ => Icons.link,
    };

/// Titoli leggibili dei rimandi `doc:` e `guide:`.
Future<Map<String, String>> refTitles(List<String> refs, String language) async {
  final docs = await loadAllDocuments();
  final local = await loadDocuments(language);
  final guides = await GuideRepository.load();
  final out = <String, String>{};
  for (final r in refs) {
    final i = r.indexOf(':');
    if (i < 0) continue;
    final value = r.substring(i + 1).split('#').first;
    final title = switch (r.substring(0, i)) {
      'doc' => (docs.where((d) => d.file == value).firstOrNull ?? local.where((d) => d.id == value).firstOrNull)?.title,
      'guide' => guides.where((g) => g.id == value).firstOrNull?.title,
      _ => null,
    };
    if (title != null) out[r] = title;
  }
  return out;
}

Future<void> openGuideTarget(BuildContext context, String target) async {
  final i = target.indexOf(':');
  final kind = target.substring(0, i);
  final value = target.substring(i + 1);
  final nav = Navigator.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final t = AppLocalizations.of(context);

  switch (kind) {
    case 'doc':
      final [file, page] = '$value#1'.split('#').take(2).toList();
      // Per nome del file, o per opera (`doc:id`) nella lingua scelta.
      final doc = (await loadAllDocuments()).where((d) => d.file == file).firstOrNull ??
          (await loadDocuments(AppSettings.instance.language)).where((d) => d.id == file).firstOrNull;
      if (doc == null) return _missing(messenger, t.notAvailable);
      await DocumentFiles.instance.refresh([doc]);
      if (!DocumentFiles.instance.isAvailable(doc)) return _missing(messenger, t.docNotDownloaded);
      await nav.push(MaterialPageRoute(
        builder: (_) => DocumentScreen(doc: doc, initialPage: int.tryParse(page) ?? 1),
      ));
    case 'guide':
      final guide = (await GuideRepository.load()).where((g) => g.id == value).firstOrNull;
      if (guide == null) return _missing(messenger, t.notAvailable);
      await nav.push(MaterialPageRoute(builder: (_) => GuideScreen(guide: guide)));
    case 'zim':
      final library = ZimLibrary.instance;
      if (!library.loaded) await library.refresh();
      for (final book in library.books) {
        final hits = await book.archive.searchTitles(value, limit: 5);
        final hit = hits.where((e) => e.title.toLowerCase() == value.toLowerCase()).firstOrNull ?? hits.firstOrNull;
        if (hit != null) {
          await nav.push(MaterialPageRoute(builder: (_) => ReaderScreen(book: book, entryUrl: hit.url)));
          return;
        }
      }
      _missing(messenger, t.entryMissing(value));
  }
}

void _missing(ScaffoldMessengerState messenger, String text) =>
    messenger.showSnackBar(SnackBar(content: Text(text)));
