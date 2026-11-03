import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'checklist_screen.dart';
import 'compass_screen.dart';
import 'fallout_screen.dart';
import 'flashlight_screen.dart';
import 'location_screen.dart';
import 'morse_screen.dart';
import 'supplies_screen.dart';

class _Tool {
  const _Tool(this.title, this.subtitle, this.icon, this.builder);

  final String title;
  final String subtitle;
  final IconData icon;
  final WidgetBuilder builder;
}

final _tools = <_Tool>[
  _Tool('Torcia e SOS', 'Luce, SOS lampeggiante, luce schermo', Icons.flashlight_on, (_) => const FlashlightScreen()),
  _Tool('Morse', 'Trasmetti testo con luce, tabella codici', Icons.more_horiz, (_) => const MorseScreen()),
  _Tool('Bussola', 'Direzione e punti cardinali', Icons.explore, (_) => const CompassScreen()),
  _Tool('Posizione', 'Coordinate GPS, UTM, MGRS', Icons.my_location, (_) => const LocationScreen()),
  _Tool('Checklist', 'Zaino 72 ore, scorte di casa', Icons.checklist, (_) => const ChecklistListScreen()),
  _Tool('Scorte', 'Acqua e cibo per persone e giorni', Icons.inventory_2, (_) => const SuppliesScreen()),
  _Tool('Fallout', 'Decadimento delle radiazioni nel tempo', Icons.radar, (_) => const FalloutScreen()),
];

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Strumenti')),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _tools.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final t = _tools[i];
            return Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Icon(t.icon, color: kAccent, size: 32),
                title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                subtitle: Text(t.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: t.builder)),
              ),
            );
          },
        ),
      );
}
