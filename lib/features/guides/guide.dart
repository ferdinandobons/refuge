/// Modello e parser delle guide.
///
/// Formato dei file `assets/guides/*.md`:
///
/// ```
/// ---
/// title: Emorragia grave
/// category: Primo soccorso
/// urgency: alta            (alta | media | bassa)
/// minutes: 3
/// order: 1
/// status: ufficiale       (ufficiale | estratti | verificata | bozza, vedi [GuideStatus])
/// sources: Fonte A | Fonte B
/// ---
/// Paragrafo introduttivo (diventa il riassunto).
///
/// ## Titolo sezione
/// ### Sottosezione
/// 1. Passo numerato
/// - Elenco puntato
/// !! Avviso importante (cosa NON fare)
/// >> Consiglio
/// ^^ Fonte dell'estratto qui sopra
/// @@ doc:file.pdf#62 | Citazione letterale da un manuale ufficiale | Nome fonte, pag. 62
/// => guide:id | Rimando     (destinazioni: doc:file.pdf#pagina, guide:id, zim:titolo voce)
/// ```
///
/// Il testo può contenere **grassetto**.
library;

enum BlockType { heading, subheading, paragraph, step, bullet, warning, tip, citation, official, link }

class GuideBlock {
  const GuideBlock(this.type, this.text, {this.number, this.target, this.source});

  final BlockType type;
  final String text;
  final int? number;

  /// Destinazione di [BlockType.link] e [BlockType.official].
  final String? target;

  /// Fonte di [BlockType.official].
  final String? source;
}

enum Urgency { alta, media, bassa }

/// Provenienza del testo: [ufficiale] è riprodotto integralmente da una fonte istituzionale,
/// [estratti] è una raccolta di brani fedeli di fonti scritte da persone (es. Wikipedia) con rimandi ai manuali,
/// [verificata] è stata controllata da personale qualificato, [bozza] no.
enum GuideStatus { ufficiale, estratti, verificata, bozza }

class Guide {
  const Guide({
    required this.id,
    required this.title,
    required this.category,
    required this.urgency,
    required this.minutes,
    required this.order,
    required this.sources,
    required this.blocks,
    this.status = GuideStatus.bozza,
  });

  final String id;
  final String title;
  final String category;
  final Urgency urgency;
  final int minutes;
  final int order;
  final List<String> sources;
  final List<GuideBlock> blocks;

  final GuideStatus status;

  String get summary => blocks
      .firstWhere((b) => b.type == BlockType.paragraph, orElse: () => const GuideBlock(BlockType.paragraph, ''))
      .text
      .replaceAll('**', '');

  String get searchText => '$title $category ${blocks.map((b) => b.text).join(' ')}'.toLowerCase();

  static Guide parse(String id, String raw) {
    final meta = <String, String>{};
    var lines = raw.replaceAll('\r\n', '\n').split('\n');

    if (lines.isNotEmpty && lines.first.trim() == '---') {
      final end = lines.indexWhere((l) => l.trim() == '---', 1);
      for (final l in lines.sublist(1, end)) {
        final i = l.indexOf(':');
        if (i > 0) meta[l.substring(0, i).trim()] = l.substring(i + 1).trim();
      }
      lines = lines.sublist(end + 1);
    }

    return Guide(
      id: id,
      title: meta['title'] ?? id,
      category: meta['category'] ?? 'Altro',
      urgency: Urgency.values.firstWhere((u) => u.name == meta['urgency'], orElse: () => Urgency.media),
      minutes: int.tryParse(meta['minutes'] ?? '') ?? 0,
      order: int.tryParse(meta['order'] ?? '') ?? 99,
      sources: (meta['sources'] ?? '').split('|').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
      blocks: parseBlocks(lines),
      status: GuideStatus.values.firstWhere((s) => s.name == meta['status'], orElse: () => GuideStatus.bozza),
    );
  }

  static final _stepRe = RegExp(r'^(\d+)\.\s+(.*)$');

  static List<GuideBlock> parseBlocks(List<String> lines) {
    final blocks = <GuideBlock>[];
    final paragraph = <String>[];

    void flush() {
      if (paragraph.isNotEmpty) {
        blocks.add(GuideBlock(BlockType.paragraph, paragraph.join(' ')));
        paragraph.clear();
      }
    }

    for (final raw in lines) {
      final line = raw.trim();
      final step = _stepRe.firstMatch(line);
      if (line.isEmpty) {
        flush();
      } else if (line.startsWith('### ')) {
        flush();
        blocks.add(GuideBlock(BlockType.subheading, line.substring(4)));
      } else if (line.startsWith('## ')) {
        flush();
        blocks.add(GuideBlock(BlockType.heading, line.substring(3)));
      } else if (step != null) {
        flush();
        blocks.add(GuideBlock(BlockType.step, step.group(2)!, number: int.parse(step.group(1)!)));
      } else if (line.startsWith('- ')) {
        flush();
        blocks.add(GuideBlock(BlockType.bullet, line.substring(2)));
      } else if (line.startsWith('!! ')) {
        flush();
        blocks.add(GuideBlock(BlockType.warning, line.substring(3)));
      } else if (line.startsWith('>> ')) {
        flush();
        blocks.add(GuideBlock(BlockType.tip, line.substring(3)));
      } else if (line.startsWith('^^ ')) {
        flush();
        blocks.add(GuideBlock(BlockType.citation, line.substring(3)));
      } else if (line.startsWith('@@ ') || line.startsWith('=> ')) {
        flush();
        final parts = line.substring(3).split(' | ');
        blocks.add(line.startsWith('@@ ')
            ? GuideBlock(BlockType.official, parts.length > 1 ? parts[1] : '',
                target: parts[0].trim(), source: parts.length > 2 ? parts[2] : null)
            : GuideBlock(BlockType.link, parts.length > 1 ? parts[1] : parts[0], target: parts[0].trim()));
      } else {
        paragraph.add(line);
      }
    }
    flush();
    return blocks;
  }
}
