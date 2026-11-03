import 'package:flutter/services.dart';

/// Lettura ad alta voce con la sintesi vocale del telefono (funziona offline).
/// Implementazione nativa: AVSpeechSynthesizer su iOS, TextToSpeech su Android.
class Speech {
  static const _channel = MethodChannel('rifugio/speech');

  static Future<void> speak(String text, String language) async {
    try {
      await _channel.invokeMethod('speak', {'text': text, 'language': language});
    } on MissingPluginException {
      // Piattaforma senza sintesi vocale (desktop): nessuna lettura.
    } on PlatformException {
      // Voce non disponibile per la lingua.
    }
  }

  static Future<void> stop() async {
    try {
      await _channel.invokeMethod('stop');
    } on MissingPluginException {
      // ignorato
    } on PlatformException {
      // ignorato
    }
  }
}
