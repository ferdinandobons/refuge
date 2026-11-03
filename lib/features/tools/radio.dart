import 'dart:convert';

import 'package:flutter/services.dart';

/// Guida radio per paese, da `assets/radio/radio.json`.
/// Ogni valore viene da una fonte ufficiale (emittente, autorità o governo), indicata in [RadioEntry.source].
class RadioEntry {
  const RadioEntry({required this.label, required this.value, this.detail, required this.source});

  final String label;
  final String value;
  final String? detail;
  final String source;
}

class CountryRadio {
  const CountryRadio({
    required this.emergency,
    required this.dab,
    required this.am,
    required this.fm,
    this.finderName,
    this.finderUrl,
  });

  /// Stazioni che trasmettono i messaggi ufficiali in emergenza.
  final List<RadioEntry> emergency;

  /// Canali DAB+: value = canale, label = stazioni, detail = copertura.
  final List<RadioEntry> dab;

  /// Onde medie/lunghe: value = kHz, label = stazione, detail = luogo.
  final List<RadioEntry> am;

  /// FM: label = città, value = MHz, detail = stazione.
  final List<RadioEntry> fm;

  final String? finderName, finderUrl;

  Set<String> get sources => {
        for (final e in [...emergency, ...dab, ...am, ...fm]) e.source,
        ?finderUrl,
      };

  factory CountryRadio.fromJson(Map<String, dynamic> j) {
    List<Map<String, dynamic>> list(String k) => ((j[k] as List?) ?? const []).cast<Map<String, dynamic>>();
    String fmt(Object? v) => v is num ? _trim(v) : '$v';
    return CountryRadio(
      emergency: [
        for (final e in list('emergency')) RadioEntry(label: e['station'] as String, value: '', source: e['source'] as String),
      ],
      dab: [
        for (final e in list('dab'))
          RadioEntry(
            label: (e['stations'] as List).join(', '),
            value: e['channel'] as String,
            detail: e['coverage'] as String?,
            source: e['source'] as String,
          ),
      ],
      am: [
        for (final e in list('am'))
          RadioEntry(
            label: e['station'] as String,
            value: fmt(e['khz']),
            detail: e['location'] as String?,
            source: e['source'] as String,
          ),
      ],
      fm: [
        for (final e in list('fm'))
          RadioEntry(
            label: e['city'] as String,
            value: fmt(e['mhz']),
            detail: e['station'] as String?,
            source: e['source'] as String,
          ),
      ],
      finderName: (j['finder'] as Map?)?['name'] as String?,
      finderUrl: (j['finder'] as Map?)?['url'] as String?,
    );
  }
}

String _trim(num v) {
  final s = v.toStringAsFixed(2);
  return s.contains('.') ? s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '') : s;
}

Map<String, CountryRadio>? _cache;
String? radioUpdated;

Future<Map<String, CountryRadio>> loadRadio() async {
  if (_cache != null) return _cache!;
  final j = jsonDecode(await rootBundle.loadString('assets/radio/radio.json')) as Map<String, dynamic>;
  radioUpdated = j['updated'] as String?;
  return _cache = {
    for (final e in (j['countries'] as Map<String, dynamic>).entries)
      e.key: CountryRadio.fromJson(e.value as Map<String, dynamic>),
  };
}

/// Canali PMR446 (walkie-talkie senza licenza in Europa): 446,00625 MHz + 12,5 kHz per canale, 16 canali.
double pmr446(int channel) => 446.00625 + (channel - 1) * 0.0125;
