import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'guide.dart';
import 'guide_links.dart';
import 'guides_screen.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key, required this.guide});

  final Guide guide;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(guide.category)),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
          children: [
            Text(guide.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(children: [
              UrgencyDot(guide.urgency),
              const SizedBox(width: 6),
              Text('Urgenza ${guide.urgency.name} · ${guide.minutes} min di lettura',
                  style: const TextStyle(color: Colors.white60)),
            ]),
            const SizedBox(height: 12),
            if (guide.status == GuideStatus.ufficiale)
              _Callout(
                icon: Icons.verified,
                color: Colors.lightGreen,
                child: Text(
                  'TESTO UFFICIALE riprodotto integralmente. ${guide.sources.first}',
                  style: const TextStyle(fontSize: 14),
                ),
              )
            else if (guide.status == GuideStatus.estratti)
              const _Callout(
                icon: Icons.format_quote,
                color: Colors.lightGreen,
                child: Text(
                  'ESTRATTI FEDELI di testi scritti da persone (Wikipedia in italiano), non riscritti, con rimandi '
                  'ai manuali ufficiali. Wikipedia non è una fonte ufficiale: dove i manuali dicono altro, '
                  'segui i manuali.',
                  style: TextStyle(fontSize: 14),
                ),
              )
            else if (guide.status == GuideStatus.bozza)
              const _Callout(
                icon: Icons.rate_review,
                color: Colors.lightBlueAccent,
                child: Text(
                  'BOZZA: riassunto delle fonti indicate in fondo, non ancora verificato da personale qualificato. '
                  'In caso di dubbio segui le fonti ufficiali e le indicazioni del 112.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            for (final b in guide.blocks) BlockView(b),
            if (guide.sources.isNotEmpty) ...[
              const Divider(height: 40),
              const Text('Fonti', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
              for (final s in guide.sources)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('• $s', style: const TextStyle(color: Colors.white54, fontSize: 13)),
                ),
            ],
            const SizedBox(height: 16),
            const Text(
              'Queste guide non sostituiscono un corso di primo soccorso né le indicazioni delle autorità. '
              'Se puoi, chiama il 112.',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      );
}

/// Testo con supporto a **grassetto**.
TextSpan richText(String text, TextStyle style) {
  final parts = text.split('**');
  return TextSpan(style: style, children: [
    for (var i = 0; i < parts.length; i++)
      TextSpan(text: parts[i], style: i.isOdd ? const TextStyle(fontWeight: FontWeight.bold) : null),
  ]);
}

class BlockView extends StatelessWidget {
  const BlockView(this.block, {super.key});

  final GuideBlock block;

  @override
  Widget build(BuildContext context) {
    const body = TextStyle(fontSize: 17, height: 1.4, color: Colors.white);
    final text = Text.rich(richText(block.text, body));

    switch (block.type) {
      case BlockType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 22, bottom: 8),
          child: Text(block.text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kAccent)),
        );
      case BlockType.subheading:
        return Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 4),
          child: Text(block.text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        );
      case BlockType.paragraph:
        return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: text);
      case BlockType.step:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: kAccent,
              child: Text('${block.number}',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Padding(padding: const EdgeInsets.only(top: 3), child: text)),
          ]),
        );
      case BlockType.bullet:
        return Padding(
          padding: const EdgeInsets.only(left: 8, top: 3, bottom: 3),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('•  ', style: body),
            Expanded(child: text),
          ]),
        );
      case BlockType.warning:
        return _Callout(icon: Icons.dangerous, color: kDanger, child: text);
      case BlockType.tip:
        return _Callout(icon: Icons.lightbulb, color: kAccent, child: text);
      case BlockType.citation:
        return Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 10),
          child: Row(children: [
            const Icon(Icons.format_quote, size: 14, color: Colors.white38),
            const SizedBox(width: 4),
            Expanded(
              child: Text(block.text,
                  style: const TextStyle(fontSize: 12, color: Colors.white38, fontStyle: FontStyle.italic)),
            ),
          ]),
        );
      case BlockType.official:
        return InkWell(
          onTap: () => openGuideTarget(context, block.target!),
          child: _Callout(
            icon: Icons.verified,
            color: Colors.lightGreen,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('“${block.text}”', style: body.copyWith(fontStyle: FontStyle.italic)),
              const SizedBox(height: 6),
              Text('${block.source ?? ''} · testo originale, tocca per aprire',
                  style: const TextStyle(fontSize: 13, color: Colors.lightGreen)),
            ]),
          ),
        );
      case BlockType.link:
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            dense: true,
            leading: Icon(guideTargetIcon(block.target!), color: kAccent),
            title: Text(block.text, style: const TextStyle(fontSize: 15)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => openGuideTarget(context, block.target!),
          ),
        );
    }
  }
}

class _Callout extends StatelessWidget {
  const _Callout({required this.icon, required this.color, required this.child});

  final IconData icon;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          border: Border(left: BorderSide(color: color, width: 4)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(child: child),
        ]),
      );
}
