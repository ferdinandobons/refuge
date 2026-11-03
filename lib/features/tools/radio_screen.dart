import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/countries.dart';
import '../../app/settings.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import 'radio.dart';

/// Guida radio: cosa ascoltare in emergenza nel paese, su quali frequenze, e i canali dei walkie-talkie.
class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  late String _country = AppSettings.instance.country.code;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final sep = NumberFormat.decimalPattern(AppSettings.instance.language).symbols.DECIMAL_SEP;
    String n(String v) => v.replaceAll('.', sep);
    return Scaffold(
      appBar: AppBar(title: Text(t.radioTitle)),
      body: FutureBuilder<Map<String, CountryRadio>>(
        future: loadRadio(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final all = snap.data!;
          final r = all[_country];
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
            children: [
              DropdownButtonFormField<String>(
                initialValue: all.containsKey(_country) ? _country : null,
                decoration: InputDecoration(labelText: t.country, border: const OutlineInputBorder()),
                items: [
                  for (final c in kCountries.where((c) => all.containsKey(c.code)))
                    DropdownMenuItem(value: c.code, child: Text(c.name(t))),
                ],
                onChanged: (v) => setState(() => _country = v ?? _country),
              ),
              if (r == null)
                Padding(padding: const EdgeInsets.only(top: 16), child: Text(t.radioNoData))
              else ...[
                if (r.emergency.isNotEmpty) ...[
                  _Header(Icons.campaign, t.radioListen),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        for (final e in r.emergency)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Text('• ${e.label}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          ),
                        const SizedBox(height: 6),
                        Text(t.radioListenBody, style: const TextStyle(color: Colors.white60)),
                      ]),
                    ),
                  ),
                ],
                if (r.fm.isNotEmpty) ...[
                  _Header(Icons.radio, t.radioFm),
                  Card(
                    child: Column(children: [
                      for (final e in r.fm)
                        ListTile(
                          dense: true,
                          title: Text(e.label, style: const TextStyle(fontSize: 16)),
                          subtitle: e.detail == null ? null : Text(e.detail!),
                          trailing: Text('${n(e.value)} MHz',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kAccent)),
                        ),
                    ]),
                  ),
                ],
                if (r.am.isNotEmpty) ...[
                  _Header(Icons.settings_input_antenna, t.radioAm),
                  Card(
                    child: Column(children: [
                      for (final e in r.am)
                        ListTile(
                          dense: true,
                          title: Text(e.label, style: const TextStyle(fontSize: 16)),
                          subtitle: e.detail == null ? null : Text(e.detail!),
                          trailing: Text('${n(e.value)} kHz',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kAccent)),
                        ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(t.radioAmNote, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                  ),
                ],
                if (r.dab.isNotEmpty) ...[
                  _Header(Icons.settings_input_component, t.radioDab),
                  Card(
                    child: Column(children: [
                      for (final e in r.dab)
                        ListTile(
                          leading: Text(e.value,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kAccent)),
                          title: Text(e.label),
                          subtitle: e.detail == null
                              ? null
                              : Text(e.detail!.toLowerCase().startsWith('nationwide') ? t.radioNationwide : e.detail!),
                        ),
                    ]),
                  ),
                ],
              ],
              _Header(Icons.search, t.radioNotFound),
              _Tips([t.radioTip1, t.radioTip2, t.radioTip3, t.radioTip4]),
              _Header(Icons.radio, t.radioWhich),
              _Tips([t.radioWhich1, t.radioWhich2, t.radioWhich3]),
              _Header(Icons.settings_remote, t.pmrTitle),
              Text(t.pmrBody, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(spacing: 6, runSpacing: 6, children: [
                    for (var c = 1; c <= 16; c++)
                      Container(
                        width: 150,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                        child: Text('${t.pmrChannel(c)}  ${n(pmr446(c).toStringAsFixed(5))}',
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 14)),
                      ),
                  ]),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: kDanger.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.warning_amber, color: kDanger),
                  const SizedBox(width: 10),
                  Expanded(child: Text(t.radioOpsec)),
                ]),
              ),
              if (r != null) ...[
                const SizedBox(height: 20),
                TextButton.icon(
                  icon: const Icon(Icons.info_outline),
                  label: Text(t.sources),
                  onPressed: () => _sources(context, t, r),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  void _sources(BuildContext context, AppLocalizations t, CountryRadio r) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.sources, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              if (radioUpdated != null) Text(t.radioChecked(radioUpdated!), style: const TextStyle(color: Colors.white60)),
              if (r.finderUrl != null) ...[
                const SizedBox(height: 10),
                Text(t.radioFinder(r.finderName ?? '')),
                SelectableText(r.finderUrl!, style: const TextStyle(color: kAccent)),
              ],
              const SizedBox(height: 10),
              for (final s in r.sources) Padding(padding: const EdgeInsets.only(bottom: 6), child: SelectableText(s)),
            ]),
          ),
        ),
      );
}

class _Header extends StatelessWidget {
  const _Header(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 20, 2, 8),
        child: Row(children: [
          Icon(icon, color: kAccent, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text.toUpperCase(),
                style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
          ),
        ]),
      );
}

class _Tips extends StatelessWidget {
  const _Tips(this.tips);

  final List<String> tips;

  @override
  Widget build(BuildContext context) => Column(children: [
        for (final tip in tips)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.arrow_right, color: kAccent),
              Expanded(child: Text(tip, style: const TextStyle(fontSize: 16, height: 1.35))),
            ]),
          ),
      ]);
}
