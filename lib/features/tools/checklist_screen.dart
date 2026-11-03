import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/theme.dart';
import '../guides/guide.dart';
import '../guides/guide_repository.dart';

/// Le checklist usano lo stesso formato delle guide: `## Sezione` e voci `- elemento`.
class ChecklistListScreen extends StatelessWidget {
  const ChecklistListScreen({super.key});

  static final _lists = loadMarkdownAssets('assets/checklists/')
      .then((l) => l..sort((a, b) => a.order.compareTo(b.order)));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Checklist')),
        body: FutureBuilder<List<Guide>>(
          future: _lists,
          builder: (context, snap) {
            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final c in snap.data!)
                  Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.checklist, color: kAccent),
                      title: Text(c.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(c.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
                      onTap: () =>
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ChecklistScreen(list: c))),
                    ),
                  ),
              ],
            );
          },
        ),
      );
}

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key, required this.list});

  final Guide list;

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  SharedPreferences? _prefs;
  Set<String> _checked = {};

  String get _key => 'checklist:${widget.list.id}';

  int get _total => widget.list.blocks.where((b) => b.type == BlockType.bullet).length;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) => setState(() {
          _prefs = p;
          _checked = (p.getStringList(_key) ?? []).toSet();
        }));
  }

  void _toggle(String item) {
    setState(() => _checked.contains(item) ? _checked.remove(item) : _checked.add(item));
    _prefs?.setStringList(_key, _checked.toList());
  }

  Future<void> _reset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Azzerare la checklist?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Annulla')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Azzera')),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _checked = {});
    _prefs?.remove(_key);
  }

  @override
  Widget build(BuildContext context) {
    final done = widget.list.blocks.where((b) => b.type == BlockType.bullet && _checked.contains(b.text)).length;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list.title),
        actions: [IconButton(icon: const Icon(Icons.restart_alt), tooltip: 'Azzera', onPressed: _reset)],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: _total == 0 ? 0 : done / _total, minHeight: 6),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text('$done di $_total', style: const TextStyle(color: Colors.white60)),
          ),
          Expanded(
            child: ListView(
              children: [
                for (final b in widget.list.blocks)
                  switch (b.type) {
                    BlockType.heading => Padding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
                        child: Text(b.text,
                            style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                    BlockType.bullet => CheckboxListTile(
                        value: _checked.contains(b.text),
                        title: Text(b.text.replaceAll('**', '')),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (_) => _toggle(b.text),
                      ),
                    BlockType.paragraph || BlockType.tip || BlockType.warning => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Text(b.text.replaceAll('**', ''), style: const TextStyle(color: Colors.white60)),
                      ),
                    BlockType.step ||
                    BlockType.subheading ||
                    BlockType.citation ||
                    BlockType.official ||
                    BlockType.link =>
                      const SizedBox.shrink(),
                  },
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
