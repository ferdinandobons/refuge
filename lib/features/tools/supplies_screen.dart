import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Litri d'acqua per persona al giorno: circa 2-3 da bere più cucina e igiene minima.
const kWaterPerDay = 4.0;
const kKcalPerDay = 2000;

class SuppliesScreen extends StatefulWidget {
  const SuppliesScreen({super.key});

  @override
  State<SuppliesScreen> createState() => _SuppliesScreenState();
}

class _SuppliesScreenState extends State<SuppliesScreen> {
  int _people = 2;
  int _days = 14;

  @override
  Widget build(BuildContext context) {
    final pd = _people * _days;
    final water = pd * kWaterPerDay;
    final kcal = pd * kKcalPerDay;
    return Scaffold(
      appBar: AppBar(title: const Text('Scorte')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Stepper(label: 'Persone', value: _people, min: 1, max: 30, onChanged: (v) => setState(() => _people = v)),
          _Stepper(label: 'Giorni', value: _days, min: 1, max: 180, step: 1, onChanged: (v) => setState(() => _days = v)),
          const SizedBox(height: 16),
          _Result(
            icon: Icons.water_drop,
            title: '${water.round()} litri d\'acqua',
            detail: '≈ ${(water / 1.5).ceil()} bottiglie da 1,5 L · ${(water / 5).ceil()} taniche da 5 L\n'
                'Minimo vitale solo da bere: ${(pd * 2).round()} L',
          ),
          _Result(
            icon: Icons.restaurant,
            title: '${(kcal / 1000).round()}.000 kcal di cibo',
            detail: 'Esempi equivalenti (non tutto insieme):\n'
                '≈ ${(kcal / 3600).ceil()} kg di pasta o riso secco\n'
                '≈ ${(kcal / 400).ceil()} scatolette di legumi da 400 g (~400 kcal)\n'
                '≈ ${(kcal / 5900).ceil()} kg di frutta secca o burro di arachidi',
          ),
          _Result(
            icon: Icons.local_fire_department,
            title: 'Cottura',
            detail: 'Una cartuccia di gas da 220 g cuoce circa 8-10 pasti per una persona: '
                '≈ ${(pd / 9).ceil()} cartucce se cucini un pasto caldo al giorno.',
          ),
          const SizedBox(height: 8),
          const Text(
            'Valori indicativi per adulti. Bambini, anziani, donne incinte, caldo e fatica cambiano molto il fabbisogno. '
            'Ruota le scorte: consuma le più vecchie e sostituiscile.',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.step = 1,
  });

  final String label;
  final int value, min, max, step;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(children: [
            Text(label, style: const TextStyle(fontSize: 18)),
            const Spacer(),
            IconButton.outlined(
              icon: const Icon(Icons.remove),
              onPressed: value > min ? () => onChanged(value - step) : null,
            ),
            SizedBox(
              width: 56,
              child: Text('$value',
                  textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            IconButton.outlined(
              icon: const Icon(Icons.add),
              onPressed: value < max ? () => onChanged(value + step) : null,
            ),
          ]),
        ),
      );
}

class _Result extends StatelessWidget {
  const _Result({required this.icon, required this.title, required this.detail});

  final IconData icon;
  final String title, detail;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          contentPadding: const EdgeInsets.all(14),
          leading: Icon(icon, color: kAccent, size: 32),
          title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Text(detail)),
        ),
      );
}
