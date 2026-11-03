import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../guides/guide.dart';

/// Lista con spunte salvate. Usa lo stesso formato delle guide: `## Sezione` e voci `- elemento`.
class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key, required this.list});

  final Guide list;

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  SharedPreferences? _prefs;
  Set<String> _checked = {};

  // Le spunte sono per posizione, così restano valide anche cambiando lingua.
  String get _key => 'checklist:${widget.list.id}:index';

  int get _total => widget.list.blocks.where((b) => b.type == BlockType.bullet).length;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) => setState(() {
          _prefs = p;
          _checked = (p.getStringList(_key) ?? []).toSet();
        }));
  }

  void _toggle(int i) {
    final k = '$i';
    setState(() => _checked.contains(k) ? _checked.remove(k) : _checked.add(k));
    _prefs?.setStringList(_key, _checked.toList());
  }

  Future<void> _reset(AppLocalizations t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(t.resetChecklistQ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(t.cancel)),
          TextButton(onPressed: () => Navigator.pop(c, true), child: Text(t.reset)),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _checked = {});
    _prefs?.remove(_key);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final total = _total;
    final done = _checked.length;
    final rows = <Widget>[];
    var item = 0;
    for (final b in widget.list.blocks) {
      if (b.type == BlockType.heading) {
        rows.add(Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
          child: Text(b.text, style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold, fontSize: 17)),
        ));
      } else if (b.type == BlockType.bullet) {
        final i = item++;
        rows.add(CheckboxListTile(
          value: _checked.contains('$i'),
          title: Text(b.text.replaceAll('**', ''), style: const TextStyle(fontSize: 17)),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (_) => _toggle(i),
        ));
      } else if (b.type == BlockType.paragraph) {
        rows.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(b.text.replaceAll('**', ''), style: const TextStyle(color: Colors.white60)),
        ));
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list.title),
        actions: [IconButton(icon: const Icon(Icons.restart_alt), tooltip: t.reset, onPressed: () => _reset(t))],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: total == 0 ? 0 : done / total, minHeight: 6),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(t.doneOf(done, total), style: const TextStyle(color: Colors.white60)),
          ),
          Expanded(child: ListView(children: [...rows, const SizedBox(height: 32)])),
        ],
      ),
    );
  }
}
