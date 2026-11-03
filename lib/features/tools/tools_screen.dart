import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import 'compass_screen.dart';
import 'fallout_screen.dart';
import 'flashlight_screen.dart';
import 'location_screen.dart';
import 'morse_screen.dart';
import 'radio_screen.dart';
import 'supplies_screen.dart';

class ToolItem {
  const ToolItem(this.title, this.subtitle, this.keywords, this.icon, this.builder);

  final String title, subtitle, keywords;
  final IconData icon;
  final WidgetBuilder builder;
}

/// In ordine di rilevanza in emergenza: prima informarsi e proteggersi, poi le scorte, poi orientarsi e segnalare.
List<ToolItem> toolItems(AppLocalizations t) => [
      ToolItem(t.radioTitle, t.radioSubtitle, t.radioKeywords, Icons.radio, (_) => const RadioScreen()),
      ToolItem(t.falloutTitle, t.falloutSubtitle, t.falloutKeywords, Icons.radar, (_) => const FalloutScreen()),
      ToolItem(t.suppliesTitle, t.suppliesSubtitle, t.suppliesKeywords, Icons.inventory_2, (_) => const SuppliesScreen()),
      ToolItem(t.torchTitle, t.torchSubtitle, t.torchKeywords, Icons.flashlight_on, (_) => const FlashlightScreen()),
      ToolItem(t.locationTitle, t.locationSubtitle, t.locationKeywords, Icons.my_location, (_) => const LocationScreen()),
      ToolItem(t.compassTitle, t.compassSubtitle, t.compassKeywords, Icons.explore, (_) => const CompassScreen()),
      ToolItem(t.morseTitle, t.morseSubtitle, t.morseKeywords, Icons.more_horiz, (_) => const MorseScreen()),
    ];

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final tools = toolItems(t);
    return Scaffold(
      appBar: AppBar(title: Text(t.tabTools)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tools.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final tool = tools[i];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              leading: Icon(tool.icon, color: kAccent, size: 34),
              title: Text(tool.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 19)),
              subtitle: Text(tool.subtitle),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: tool.builder)),
            ),
          );
        },
      ),
    );
  }
}
