import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'countries.dart';

/// Lingua e paese scelti al primo avvio, salvati sul dispositivo.
class AppSettings extends ChangeNotifier {
  AppSettings._();

  static final instance = AppSettings._();

  SharedPreferences? _prefs;
  String? _language;
  String? _country;
  bool _onboarded = false;

  /// Prima della scelta: la prima delle lingue del telefono, in ordine di preferenza, che l'app supporta.
  String get language {
    if (_language != null) return _language!;
    for (final l in PlatformDispatcher.instance.locales) {
      if (kLanguages.any((k) => k.$1 == l.languageCode)) return l.languageCode;
    }
    return 'en';
  }

  Locale get locale => Locale(language);

  /// Paese impostato sul telefono (regione), se è tra quelli previsti.
  String? get deviceCountry {
    for (final l in PlatformDispatcher.instance.locales) {
      final code = l.countryCode;
      if (code != null && code != 'XX' && kCountries.any((c) => c.code == code)) return code;
    }
    return null;
  }

  /// Prima della scelta vale il paese del telefono, così anche il numero di emergenza è già giusto.
  Country get country => countryByCode(_country ?? deviceCountry);

  bool get onboarded => _onboarded;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    _language = _prefs!.getString('language');
    _country = _prefs!.getString('country');
    _onboarded = _prefs!.getBool('onboarded') ?? false;
  }

  Future<void> finishOnboarding() async {
    _onboarded = true;
    await _prefs?.setBool('onboarded', true);
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _language = code;
    await _prefs?.setString('language', code);
    notifyListeners();
  }

  Future<void> setCountry(String code) async {
    _country = code;
    await _prefs?.setString('country', code);
    notifyListeners();
  }
}
