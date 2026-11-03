import 'package:torch_light/torch_light.dart';

const kMorse = <String, String>{
  'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.', 'F': '..-.', 'G': '--.', 'H': '....',
  'I': '..', 'J': '.---', 'K': '-.-', 'L': '.-..', 'M': '--', 'N': '-.', 'O': '---', 'P': '.--.',
  'Q': '--.-', 'R': '.-.', 'S': '...', 'T': '-', 'U': '..-', 'V': '...-', 'W': '.--', 'X': '-..-',
  'Y': '-.--', 'Z': '--..',
  '0': '-----', '1': '.----', '2': '..---', '3': '...--', '4': '....-', '5': '.....', '6': '-....',
  '7': '--...', '8': '---..', '9': '----.',
  '.': '.-.-.-', ',': '--..--', '?': '..--..', '/': '-..-.', '=': '-...-', '@': '.--.-.',
};

const _accents = {'À': 'A', 'Á': 'A', 'È': 'E', 'É': 'E', 'Ì': 'I', 'Í': 'I', 'Ò': 'O', 'Ó': 'O', 'Ù': 'U', 'Ú': 'U'};

String _normalize(String text) =>
    text.toUpperCase().split('').map((c) => _accents[c] ?? c).join();

/// Testo in codice Morse leggibile, es. "SOS" → "... --- ...". Le parole sono separate da " / ".
String encodeMorse(String text) => _normalize(text)
    .trim()
    .split(RegExp(r'\s+'))
    .map((w) => w.split('').map((c) => kMorse[c]).whereType<String>().join(' '))
    .where((w) => w.isNotEmpty)
    .join(' / ');

/// Durate in unità, alternando acceso/spento e partendo da acceso.
/// Punto = 1, linea = 3, pausa tra simboli = 1, tra lettere = 3, tra parole = 7.
List<int> morseTimings(String text) {
  final out = <int>[];
  final words = encodeMorse(text).split(' / ').where((w) => w.isNotEmpty);
  for (final word in words) {
    for (final letter in word.split(' ')) {
      for (final s in letter.split('')) {
        out
          ..add(s == '.' ? 1 : 3)
          ..add(1);
      }
      out[out.length - 1] = 3;
    }
    out[out.length - 1] = 7;
  }
  return out;
}

/// Riproduce una sequenza Morse chiamando [onChange] e, se richiesto, accendendo la torcia.
class MorsePlayer {
  MorsePlayer(this.onChange);

  final void Function(bool on) onChange;

  /// Incrementato a ogni avvio e a ogni stop: una riproduzione continua solo finché il suo id è attuale.
  int _run = 0;

  Future<void> play(String text, {int unitMs = 200, bool loop = false, bool useTorch = true}) async {
    final timings = morseTimings(text);
    if (timings.isEmpty) return;
    final id = ++_run;

    do {
      for (var i = 0; i < timings.length; i++) {
        if (_run != id) return;
        final on = i.isEven;
        onChange(on);
        if (useTorch) await setTorch(on);
        await Future<void>.delayed(Duration(milliseconds: timings[i] * unitMs));
      }
    } while (loop && _run == id);

    if (_run == id) await stop(useTorch: useTorch);
  }

  Future<void> stop({bool useTorch = true}) async {
    _run++;
    onChange(false);
    if (useTorch) await setTorch(false);
  }
}

/// Accende/spegne la torcia. Restituisce false se non disponibile (es. simulatore, desktop).
Future<bool> setTorch(bool on) async {
  try {
    on ? await TorchLight.enableTorch() : await TorchLight.disableTorch();
    return true;
  } catch (_) {
    return false;
  }
}
