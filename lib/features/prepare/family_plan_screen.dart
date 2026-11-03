import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';

/// Piano di emergenza della famiglia, come raccomandano le linee guida UE sulle 72 ore
/// (SWD(2026) 826 e 828): contatti scritti, punti d'incontro, rifugio, chi aiuta chi.
/// Resta sul telefono; si può copiare per scriverlo su carta o condividerlo.
class FamilyPlanScreen extends StatefulWidget {
  const FamilyPlanScreen({super.key});

  @override
  State<FamilyPlanScreen> createState() => _FamilyPlanScreenState();
}

const kPlanFields = ['contacts', 'meetNear', 'meetFar', 'shelter', 'children', 'help', 'health', 'notes'];

class _FamilyPlanScreenState extends State<FamilyPlanScreen> {
  final _controllers = {for (final f in kPlanFields) f: TextEditingController()};
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      _prefs = p;
      for (final f in kPlanFields) {
        _controllers[f]!.text = p.getString('plan:$f') ?? '';
      }
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  (String, String, IconData) _field(AppLocalizations t, String f) => switch (f) {
        'contacts' => (t.planContacts, t.planContactsHint, Icons.contacts),
        'meetNear' => (t.planMeetNear, t.planMeetNearHint, Icons.place),
        'meetFar' => (t.planMeetFar, t.planMeetFarHint, Icons.near_me),
        'shelter' => (t.planShelter, t.planShelterHint, Icons.night_shelter),
        'children' => (t.planChildren, t.planChildrenHint, Icons.child_care),
        'help' => (t.planHelp, t.planHelpHint, Icons.accessible),
        'health' => (t.planHealth, t.planHealthHint, Icons.medication),
        _ => (t.planNotes, '', Icons.notes),
      };

  void _copy(AppLocalizations t) {
    final text = [
      t.planTitle.toUpperCase(),
      for (final f in kPlanFields)
        if (_controllers[f]!.text.trim().isNotEmpty) '${_field(t, f).$1}:\n${_controllers[f]!.text.trim()}',
    ].join('\n\n');
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.planCopied)));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.planTitle),
        actions: [IconButton(icon: const Icon(Icons.copy), tooltip: t.planCopy, onPressed: () => _copy(t))],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Text(t.planIntro, style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.35)),
          const SizedBox(height: 16),
          for (final f in kPlanFields) ...[
            Row(children: [
              Icon(_field(t, f).$3, color: kAccent, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(_field(t, f).$1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ]),
            const SizedBox(height: 6),
            TextField(
              controller: _controllers[f],
              minLines: f == 'contacts' ? 3 : 1,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(hintText: _field(t, f).$2, border: const OutlineInputBorder()),
              onChanged: (v) => _prefs?.setString('plan:$f', v),
            ),
            const SizedBox(height: 18),
          ],
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: kAccent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.edit_note, color: kAccent),
              const SizedBox(width: 10),
              Expanded(child: Text(t.planPaper)),
            ]),
          ),
        ],
      ),
    );
  }
}
