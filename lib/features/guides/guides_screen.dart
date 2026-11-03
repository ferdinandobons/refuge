import 'package:flutter/material.dart';

import '../../app/settings.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import 'guide.dart';
import 'guide_repository.dart';
import 'guide_screen.dart';

/// Guide della Protezione Civile nella lingua scelta (vedi [GuideRepository]).
class GuidesScreen extends StatefulWidget {
  const GuidesScreen({super.key});

  @override
  State<GuidesScreen> createState() => _GuidesScreenState();
}

class _GuidesScreenState extends State<GuidesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.civilProtectionGuides)),
      body: FutureBuilder<List<Guide>>(
        future: GuideRepository.load(AppSettings.instance.language),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final q = _query.trim().toLowerCase();
          final guides = q.isEmpty ? snap.data! : snap.data!.where((g) => g.searchText.contains(q)).toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Text(t.civilProtectionGuidesBody, style: const TextStyle(color: Colors.white54)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: t.search,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              Expanded(
                child: guides.isEmpty
                    ? Center(child: Text(t.searchEmpty))
                    : ListView(children: _buildList(guides)),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildList(List<Guide> guides) {
    final items = <Widget>[];
    String? category;
    for (final g in guides) {
      if (g.category != category) {
        category = g.category;
        items.add(Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
          child: Row(children: [
            Icon(guideIcon(g.id), color: kAccent, size: 20),
            const SizedBox(width: 8),
            Text(category.toUpperCase(),
                style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ]),
        ));
      }
      items.add(ListTile(
        title: Text(g.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(g.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GuideScreen(guide: g))),
      ));
    }
    items.add(const SizedBox(height: 24));
    return items;
  }
}
