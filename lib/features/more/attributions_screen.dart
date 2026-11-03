import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/settings.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';

/// Licenze e attribuzioni: da dove vengono i contenuti e con quale licenza (`assets/legal/attributions.json`),
/// più le licenze delle librerie software usate.
class AttributionsScreen extends StatelessWidget {
  const AttributionsScreen({super.key});

  static Future<List<Map<String, dynamic>>> _load() async =>
      (jsonDecode(await rootBundle.loadString('assets/legal/attributions.json')) as List).cast<Map<String, dynamic>>();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final lang = AppSettings.instance.language;
    return Scaffold(
      appBar: AppBar(title: Text(t.attributionsTitle)),
      body: FutureBuilder(
        future: _load(),
        builder: (context, snap) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Text(t.attributionsBody, style: const TextStyle(color: Colors.white70, height: 1.35)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.code, color: kAccent),
                title: Text(t.attributionsApp),
                subtitle: const Text('GPL-3.0 · CC BY-SA 4.0'),
              ),
            ),
            if (!snap.hasData) const Center(child: CircularProgressIndicator()),
            for (final e in snap.data ?? const <Map<String, dynamic>>[])
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(e['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(e['license'] as String, style: const TextStyle(color: kAccent, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text((e['use'] as Map)[lang] as String? ?? (e['use'] as Map)['en'] as String),
                    const SizedBox(height: 4),
                    SelectableText(e['url'] as String, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                  ]),
                ),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              icon: const Icon(Icons.description),
              label: Text(t.softwareLicenses),
              onPressed: () => showLicensePage(context: context, applicationName: t.appTitle),
            ),
          ],
        ),
      ),
    );
  }
}
