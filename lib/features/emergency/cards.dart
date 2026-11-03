import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/countries.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';

/// Scheda d'emergenza: pochi passi brevi, nella lingua scelta.
///
/// Contenuto standard europeo (primo soccorso secondo le linee guida ERC, riparo secondo la
/// protezione civile) in `assets/cards/cards.json`, con tutte le lingue affiancate.
/// `{emergency}` e `{alert}` vengono sostituiti con il numero e il sistema di allerta del paese.
class EmergencyCard {
  const EmergencyCard({
    required this.id,
    required this.group,
    required this.title,
    required this.keywords,
    required this.steps,
    required this.never,
    required this.refs,
  });

  final String id;

  /// body (corpo / primo soccorso), danger (pericoli), survive (sopravvivenza).
  final String group;
  final String title;
  final String keywords;
  final List<String> steps;
  final List<String> never;

  /// Fonti (testo o rimando `doc:`/`guide:`), mostrate solo su richiesta.
  final List<String> refs;

  IconData get icon => switch (id) {
        'bleeding' => Icons.bloodtype,
        'cpr' => Icons.monitor_heart,
        'choking' => Icons.no_food,
        'unconscious' => Icons.airline_seat_flat,
        'burns' => Icons.local_fire_department,
        'airraid' => Icons.flight,
        'nuclear' => Icons.radar,
        'chemical' => Icons.science,
        'earthquake' => Icons.house_siding,
        'fire' => Icons.fireplace,
        'flood' => Icons.flood,
        'cold' => Icons.ac_unit,
        'heat' => Icons.wb_sunny,
        'water' => Icons.water_drop,
        'blackout' => Icons.power_off,
        _ => Icons.help,
      };

  Color get color => switch (group) {
        'body' => kDanger,
        'danger' => kAccent,
        _ => Colors.lightBlueAccent,
      };
}

List<dynamic>? _raw;

Future<List<EmergencyCard>> loadCards(String language, Country country, AppLocalizations t) async {
  _raw ??= jsonDecode(await rootBundle.loadString('assets/cards/cards.json')) as List;
  String fill(String s) => s.replaceAll('{emergency}', country.emergency).replaceAll('{alert}', country.alertName(t));
  return [
    for (final c in _raw!.cast<Map<String, dynamic>>())
      if (c[language] ?? c['en'] case final Map<String, dynamic> l)
        EmergencyCard(
          id: c['id'] as String,
          group: c['group'] as String,
          title: l['title'] as String,
          keywords: l['keywords'] as String,
          steps: [for (final s in (l['steps'] as List).cast<String>()) fill(s)],
          never: [for (final s in (l['never'] as List).cast<String>()) fill(s)],
          refs: (c['refs'] as List).cast<String>(),
        ),
  ];
}
