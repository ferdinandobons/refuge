import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../../app/theme.dart';
import 'coords.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late final Future<String?> _permission = _checkPermission();

  /// Restituisce un messaggio d'errore, o null se la posizione è utilizzabile.
  Future<String?> _checkPermission() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return 'La localizzazione è disattivata. Attivala nelle impostazioni del telefono '
            '(il GPS funziona anche in modalità aereo).';
      }
      var p = await Geolocator.checkPermission();
      if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
      if (p == LocationPermission.denied || p == LocationPermission.deniedForever) {
        return 'Permesso di posizione negato. Puoi concederlo dalle impostazioni del telefono.';
      }
      return null;
    } catch (e) {
      return 'Posizione non disponibile su questo dispositivo.';
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Posizione')),
        body: FutureBuilder<String?>(
          future: _permission,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.data != null) {
              return Center(
                child: Padding(padding: const EdgeInsets.all(24), child: Text(snap.data!, textAlign: TextAlign.center)),
              );
            }
            return StreamBuilder<Position>(
              stream: Geolocator.getPositionStream(
                locationSettings: const LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 1),
              ),
              builder: (context, pos) {
                if (pos.hasError) return Center(child: Text('Errore GPS: ${pos.error}'));
                if (!pos.hasData) {
                  return const Center(
                    child: Text('Ricerca satelliti… all\'aperto è più veloce.', textAlign: TextAlign.center),
                  );
                }
                return _PositionView(pos.data!);
              },
            );
          },
        ),
      );
}

class _PositionView extends StatelessWidget {
  const _PositionView(this.p);

  final Position p;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      ('Decimale', '${p.latitude.toStringAsFixed(6)}, ${p.longitude.toStringAsFixed(6)}'),
      ('Gradi, minuti, secondi', '${toDms(p.latitude, isLat: true)}\n${toDms(p.longitude, isLat: false)}'),
      ('UTM', toUtm(p.latitude, p.longitude)?.toString() ?? 'n/d'),
      ('MGRS (militare / soccorsi)', toMgrs(p.latitude, p.longitude) ?? 'n/d'),
      ('Altitudine', '${p.altitude.round()} m'),
      ('Precisione', '± ${p.accuracy.round()} m'),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final (label, value) in rows)
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text(label, style: const TextStyle(color: Colors.white60, fontSize: 14)),
              subtitle: Text(value,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'monospace', height: 1.4)),
              trailing: IconButton(
                icon: const Icon(Icons.copy, color: kAccent),
                tooltip: 'Copia',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copiato')));
                },
              ),
            ),
          ),
        const Text(
          'Al telefono con il 112 detta le coordinate decimali. Con militari o protezione civile '
          'può servire il formato MGRS.',
          style: TextStyle(color: Colors.white54),
        ),
      ],
    );
  }
}
