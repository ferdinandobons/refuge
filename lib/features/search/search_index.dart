/// Ricerca tollerante: ignora maiuscole, accenti e punteggiatura, accetta parole incomplete
/// ("emorr" → emorragia) e piccoli errori di battitura ("emoragia", "ustone").
library;

const _accents = {
  'à': 'a', 'á': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a', 'å': 'a',
  'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
  'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
  'ò': 'o', 'ó': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o',
  'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
  'ç': 'c', 'ñ': 'n', 'ß': 'ss', 'œ': 'oe', 'æ': 'ae',
};

String normalize(String s) {
  final b = StringBuffer();
  for (final ch in s.toLowerCase().split('')) {
    b.write(_accents[ch] ?? ch);
  }
  return b.toString().replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();
}

List<String> tokens(String s) => normalize(s).split(' ').where((w) => w.length > 1).toList();

/// Distanza di modifica (Levenshtein), limitata a [max] per velocità.
int editDistance(String a, String b, {int max = 2}) {
  if ((a.length - b.length).abs() > max) return max + 1;
  var prev = List<int>.generate(b.length + 1, (i) => i);
  for (var i = 1; i <= a.length; i++) {
    final cur = List<int>.filled(b.length + 1, 0)..[0] = i;
    var best = cur[0];
    for (var j = 1; j <= b.length; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      cur[j] = [prev[j] + 1, cur[j - 1] + 1, prev[j - 1] + cost].reduce((x, y) => x < y ? x : y);
      if (cur[j] < best) best = cur[j];
    }
    if (best > max) return max + 1;
    prev = cur;
  }
  return prev[b.length];
}

/// Quanto bene la parola cercata [q] corrisponde a una parola del testo [w] (0 = per niente).
double wordMatch(String q, String w) {
  if (w == q) return 1;
  if (w.startsWith(q)) return q.length >= 3 ? 0.9 : 0.6;
  if (q.length >= 4) {
    final allowed = q.length >= 8 ? 2 : 1;
    // Confronta anche con l'inizio della parola, per tollerare errori su parole incomplete.
    final head = w.length > q.length ? w.substring(0, q.length) : w;
    final d = [editDistance(q, w, max: allowed), editDistance(q, head, max: allowed)].reduce((a, b) => a < b ? a : b);
    if (d <= allowed) return d == 1 ? 0.6 : 0.4;
  }
  return 0;
}

class Indexed<T> {
  Indexed(this.item, {required String title, String keywords = '', String body = '', this.priority = 0})
      : _title = tokens(title),
        _keywords = tokens(keywords),
        _body = tokens(body).toSet().toList();

  final T item;

  /// Ordine dei gruppi a parità di punteggio (0 = più importante).
  final int priority;
  final List<String> _title, _keywords, _body;

  /// Punteggio per la ricerca; 0 se una parola cercata non compare da nessuna parte.
  double score(List<String> query) {
    var total = 0.0;
    for (final q in query) {
      double best(List<String> words) => words.fold(0, (m, w) => m > 0.99 ? m : (wordMatch(q, w) > m ? wordMatch(q, w) : m));
      final s = [best(_title) * 3, best(_keywords) * 2.5, best(_body)].reduce((a, b) => a > b ? a : b);
      if (s == 0) return 0;
      total += s;
    }
    return total;
  }
}

List<T> search<T>(List<Indexed<T>> index, String query, {int limit = 40}) {
  final q = tokens(query);
  if (q.isEmpty) return [];
  final scored = [
    for (final e in index)
      if (e.score(q) case final s when s > 0) (e, s),
  ]..sort((a, b) {
      final c = b.$2.compareTo(a.$2);
      return c != 0 ? c : a.$1.priority.compareTo(b.$1.priority);
    });
  return [for (final (e, _) in scored.take(limit)) e.item];
}
