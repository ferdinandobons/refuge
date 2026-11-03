import '../l10n/app_localizations.dart';

/// Numero di emergenza aggiuntivo (oltre al numero principale).
enum ServiceKind { ambulance, fire, police, poison, deafSms }

/// Differenze tra paesi. Il resto dei contenuti è uguale in tutta Europa
/// (primo soccorso secondo le linee guida ERC, riparo al chiuso in caso di allarme).
class Country {
  const Country(this.code, this.language, this.emergency, {this.alert, this.extra = const [], this.siren});

  final String code;

  /// Lingua proposta al primo avvio.
  final String language;

  /// Numero da chiamare per qualsiasi emergenza.
  final String emergency;

  /// Nome del sistema di allerta sul telefono (Cell Broadcast / EU-Alert).
  final String? alert;

  final List<(ServiceKind, String)> extra;

  /// Codice del segnale delle sirene, se esiste un segnale nazionale documentato.
  final String? siren;

  String name(AppLocalizations t) => switch (code) {
        'IT' => t.countryIT,
        'FR' => t.countryFR,
        'DE' => t.countryDE,
        'ES' => t.countryES,
        'AT' => t.countryAT,
        'CH' => t.countryCH,
        'BE' => t.countryBE,
        'NL' => t.countryNL,
        'LU' => t.countryLU,
        'PT' => t.countryPT,
        'GB' => t.countryGB,
        'IE' => t.countryIE,
        _ => t.countryOther,
      };

  String alertName(AppLocalizations t) => alert ?? t.officialAlerts;

  String? sirenText(AppLocalizations t) => switch (siren) {
        'FR' => t.sirenFR,
        'DE' => t.sirenDE,
        'AT' => t.sirenAT,
        'CH' => t.sirenCH,
        _ => null,
      };

  /// Nota specifica del paese per una scheda, se c'è.
  String? cardNote(String cardId, AppLocalizations t) => switch ((code, cardId)) {
        ('DE', 'nuclear') => t.noteIodineDE,
        _ => null,
      };
}

const kCountries = <Country>[
  Country('IT', 'it', '112', alert: 'IT-alert'),
  Country('FR', 'fr', '112', alert: 'FR-Alert', siren: 'FR', extra: [
    (ServiceKind.ambulance, '15'),
    (ServiceKind.fire, '18'),
    (ServiceKind.police, '17'),
    (ServiceKind.deafSms, '114'),
  ]),
  Country('DE', 'de', '112', alert: 'Cell Broadcast / NINA', siren: 'DE', extra: [(ServiceKind.police, '110')]),
  Country('ES', 'es', '112', alert: 'ES-Alert'),
  Country('AT', 'de', '112', alert: 'AT-Alert', siren: 'AT', extra: [
    (ServiceKind.ambulance, '144'),
    (ServiceKind.fire, '122'),
    (ServiceKind.police, '133'),
  ]),
  Country('CH', 'de', '112', alert: 'Alertswiss', siren: 'CH', extra: [
    (ServiceKind.ambulance, '144'),
    (ServiceKind.fire, '118'),
    (ServiceKind.police, '117'),
    (ServiceKind.poison, '145'),
  ]),
  Country('BE', 'fr', '112', alert: 'BE-Alert', extra: [(ServiceKind.police, '101')]),
  Country('NL', 'en', '112', alert: 'NL-Alert'),
  Country('LU', 'fr', '112', alert: 'LU-Alert', extra: [(ServiceKind.police, '113')]),
  Country('PT', 'en', '112'),
  Country('GB', 'en', '999', alert: 'Emergency Alerts', extra: [(ServiceKind.ambulance, '112')]),
  Country('IE', 'en', '112', extra: [(ServiceKind.ambulance, '999')]),
  Country('XX', 'en', '112'),
];

Country countryByCode(String? code) => kCountries.firstWhere((c) => c.code == code, orElse: () => kCountries.last);

const kLanguages = <(String code, String name)>[
  ('it', 'Italiano'),
  ('en', 'English'),
  ('fr', 'Français'),
  ('de', 'Deutsch'),
  ('es', 'Español'),
];
