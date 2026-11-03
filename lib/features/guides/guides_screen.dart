import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'guide.dart';
import 'guide_repository.dart';
import 'guide_screen.dart';

class GuidesScreen extends StatefulWidget {
  const GuidesScreen({super.key});

  @override
  State<GuidesScreen> createState() => _GuidesScreenState();
}

class _GuidesScreenState extends State<GuidesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Guide')),
        body: FutureBuilder<List<Guide>>(
          future: GuideRepository.load(),
          builder: (context, snap) {
            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
            final q = _query.trim().toLowerCase();
            final guides = q.isEmpty ? snap.data! : snap.data!.where((g) => g.searchText.contains(q)).toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Cerca (es. emorragia, acqua, iodio)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
                Expanded(
                  child: guides.isEmpty
                      ? const Center(child: Text('Nessuna guida trovata'))
                      : ListView(children: _buildList(context, guides)),
                ),
              ],
            );
          },
        ),
      );

  List<Widget> _buildList(BuildContext context, List<Guide> guides) {
    final items = <Widget>[];
    String? category;
    for (final g in guides) {
      if (g.category != category) {
        category = g.category;
        items.add(Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
          child: Row(children: [
            Icon(categoryIcon(category), color: kAccent, size: 20),
            const SizedBox(width: 8),
            Text(category.toUpperCase(),
                style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ]),
        ));
      }
      items.add(GuideTile(guide: g));
    }
    items.add(const SizedBox(height: 24));
    return items;
  }
}

class GuideTile extends StatelessWidget {
  const GuideTile({super.key, required this.guide});

  final Guide guide;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: UrgencyDot(guide.urgency),
        title: Text.rich(TextSpan(children: [
          TextSpan(text: guide.title, style: const TextStyle(fontWeight: FontWeight.w600)),
          if (guide.status != GuideStatus.bozza)
            const WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(left: 6),
                child: Icon(Icons.verified, size: 16, color: Colors.lightGreen),
              ),
            ),
          if (guide.status == GuideStatus.bozza)
            const TextSpan(text: '  BOZZA', style: TextStyle(fontSize: 11, color: Colors.lightBlueAccent)),
        ])),
        subtitle: Text(guide.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Text('${guide.minutes} min', style: const TextStyle(color: Colors.white54)),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GuideScreen(guide: guide))),
      );
}

class UrgencyDot extends StatelessWidget {
  const UrgencyDot(this.urgency, {super.key});

  final Urgency urgency;

  static Color colorOf(Urgency u) => switch (u) {
        Urgency.alta => kDanger,
        Urgency.media => kAccent,
        Urgency.bassa => Colors.lightGreen,
      };

  @override
  Widget build(BuildContext context) => Icon(Icons.circle, size: 14, color: colorOf(urgency));
}
