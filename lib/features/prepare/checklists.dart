import '../guides/guide.dart';
import '../guides/guide_repository.dart';

/// Liste di preparazione nella lingua scelta (`assets/checklists/<lingua>/`), in italiano se mancano.
Future<List<Guide>> loadChecklists(String language) async {
  var lists = await loadMarkdownAssets('assets/checklists/$language/');
  if (lists.isEmpty) lists = await loadMarkdownAssets('assets/checklists/it/');
  return lists..sort((a, b) => a.order.compareTo(b.order));
}
