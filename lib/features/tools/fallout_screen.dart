import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'fallout.dart';

class FalloutScreen extends StatefulWidget {
  const FalloutScreen({super.key});

  @override
  State<FalloutScreen> createState() => _FalloutScreenState();
}

class _FalloutScreenState extends State<FalloutScreen> {
  final _rate = TextEditingController(text: '10');
  final _hours = TextEditingController(text: '1');

  static const _checkpoints = <(String, double)>[
    ('1 ora', 1), ('2 ore', 2), ('7 ore', 7), ('12 ore', 12), ('1 giorno', 24), ('2 giorni', 48),
    ('3 giorni', 72), ('1 settimana', 168), ('2 settimane', 336), ('7 settimane', 1176),
  ];

  double? _num(TextEditingController c) => double.tryParse(c.text.replaceAll(',', '.'));

  String _fmt(double v) => v >= 100 ? v.toStringAsFixed(0) : v >= 1 ? v.toStringAsFixed(1) : v.toStringAsFixed(3);

  @override
  void dispose() {
    _rate.dispose();
    _hours.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rate = _num(_rate), t0 = _num(_hours);
    final valid = rate != null && rate > 0 && t0 != null && t0 >= 0.5;

    return Scaffold(
      appBar: AppBar(title: const Text('Fallout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Inserisci un\'intensità misurata con un dosimetro (es. mSv/h) e quante ore sono passate '
            'dall\'esplosione. Il calcolo stima come scenderà nel tempo.',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _rate,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Intensità misurata', border: OutlineInputBorder()),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _hours,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Ore dall\'esplosione', border: OutlineInputBorder()),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          if (!valid)
            const Text('Inserisci valori positivi (minimo 0,5 ore).', style: TextStyle(color: kDanger))
          else ...[
            Card(
              child: Column(children: [
                const ListTile(
                  title: Text('Dopo l\'esplosione', style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text('Intensità', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                for (final (label, t) in _checkpoints)
                  if (t >= t0)
                    ListTile(
                      dense: true,
                      title: Text(label),
                      trailing: Text(_fmt(falloutRate(rate, t0, t)),
                          style: const TextStyle(fontFamily: 'monospace', fontSize: 16)),
                    ),
              ]),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.warning_amber, color: kAccent),
                title: const Text('Se resti all\'aperto per le prossime 24 ore'),
                subtitle: Text('Dose stimata: ${_fmt(falloutDose(rate, t0, t0, t0 + 24))} (unità × ora, es. mSv)\n'
                    'Un riparo al chiuso la riduce: una cantina di 10-40 volte, un rifugio vero anche oltre 100.'),
              ),
            ),
          ],
          const SizedBox(height: 16),
          const Text(
            'Regola del 7-10: ogni volta che il tempo trascorso si moltiplica per 7, l\'intensità si riduce di circa 10 volte. '
            'Dopo 7 ore è un decimo di quella a 1 ora; dopo 2 giorni un centesimo.\n\n'
            'È una stima: la misura reale con un dosimetro e le indicazioni delle autorità vengono prima.',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
