import 'package:flutter/material.dart';

import '../../app/countries.dart';
import '../../app/settings.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../emergency/emergency_screen.dart';
import '../library/library_screen.dart';
import '../tools/location_screen.dart';
import '../tools/radio_screen.dart';
import '../tools/supplies_screen.dart';
import 'family_plan_screen.dart';

/// Prepararsi prima che serva: numeri e allerte del paese, liste, scorte, contenuti da scaricare.
class PrepareScreen extends StatelessWidget {
  const PrepareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final s = AppSettings.instance;
    final country = s.country;
    final siren = country.sirenText(t);
    return Scaffold(
      appBar: AppBar(title: Text(t.tabPrepare)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(t.yourCountry(country.name(t))),
          Card(
            child: Column(children: [
              _NumberTile(label: t.emergencyNumber, number: country.emergency, main: true),
              for (final (kind, number) in country.extra) _NumberTile(label: _serviceName(t, kind), number: number),
              ListTile(
                leading: const Icon(Icons.notifications_active, color: kAccent),
                title: Text(t.phoneAlerts),
                subtitle: Text(t.phoneAlertsBody(country.alertName(t))),
              ),
              ListTile(
                leading: const Icon(Icons.radio, color: kAccent),
                title: Text(t.radioTitle),
                subtitle: Text(t.radioSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RadioScreen())),
              ),
              if (siren != null)
                ListTile(
                  leading: const Icon(Icons.campaign, color: kAccent),
                  title: Text(t.sirens),
                  subtitle: Text(siren),
                ),
            ]),
          ),
          const SizedBox(height: 20),
          _Section(t.checklists),
          _Tile(
            icon: Icons.family_restroom,
            title: t.planTitle,
            subtitle: t.planSubtitle,
            open: (_) => const FamilyPlanScreen(),
          ),
          _Tile(
            icon: Icons.inventory_2,
            title: t.suppliesTitle,
            subtitle: t.suppliesSubtitle,
            open: (_) => const SuppliesScreen(),
          ),
          const SizedBox(height: 20),
          _Section(t.offlineContent),
          _Tile(
            icon: Icons.map,
            title: t.mapsTitle,
            subtitle: t.onbMapBody,
            open: (_) => const LocationScreen(),
          ),
          _Tile(
            icon: Icons.download,
            title: t.downloadEncyclopedias,
            subtitle: t.downloadEncyclopediasBody,
            open: (_) => const LibraryScreen(),
          ),
        ],
      ),
    );
  }

  static String _serviceName(AppLocalizations t, ServiceKind k) => switch (k) {
        ServiceKind.ambulance => t.serviceAmbulance,
        ServiceKind.fire => t.serviceFire,
        ServiceKind.police => t.servicePolice,
        ServiceKind.poison => t.servicePoison,
        ServiceKind.deafSms => t.serviceDeafSms,
      };
}

class _Section extends StatelessWidget {
  const _Section(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text.toUpperCase(),
            style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
      );
}

class _NumberTile extends StatelessWidget {
  const _NumberTile({required this.label, required this.number, this.main = false});

  final String label, number;
  final bool main;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(Icons.call, color: main ? kDanger : Colors.white70),
        title: Text(label),
        trailing: Text(number, style: TextStyle(fontSize: main ? 26 : 20, fontWeight: FontWeight.bold)),
        onTap: () => callNumber(number),
      );
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.title, required this.subtitle, required this.open});

  final IconData icon;
  final String title, subtitle;
  final WidgetBuilder open;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Icon(icon, color: kAccent, size: 30),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
          subtitle: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: open)),
        ),
      );
}
