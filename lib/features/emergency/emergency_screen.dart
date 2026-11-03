import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/settings.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../search/search_screen.dart';
import '../tools/fallout_phases.dart';
import '../tools/fallout_screen.dart';
import '../tools/flashlight_screen.dart';
import 'card_screen.dart';
import 'cards.dart';

Future<void> callNumber(String number) => launchUrl(Uri(scheme: 'tel', path: number));

/// Schermata iniziale: "Cosa succede?" con pulsanti grandi, chiamata di emergenza e SOS sempre in cima.
class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final s = AppSettings.instance;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<EmergencyCard>>(
          future: loadCards(s.language, s.country, t),
          builder: (context, snap) => CustomScrollView(slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              sliver: SliverList.list(children: [
                Row(children: [
                  Expanded(
                    flex: 3,
                    child: _BigButton(
                      icon: Icons.call,
                      label: t.callNumber(s.country.emergency),
                      color: kDanger,
                      onTap: () => callNumber(s.country.emergency),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: _BigButton(
                      icon: Icons.flashlight_on,
                      label: t.sosLight,
                      color: Colors.white,
                      // Parte subito l'SOS lampeggiante, su schermo e torcia.
                      onTap: () => Navigator.push(
                          context, MaterialPageRoute(builder: (_) => const FlashlightScreen(startSos: true))),
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: t.searchHint,
                    border: const OutlineInputBorder(),
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
                ),
                const SizedBox(height: 18),
                Text(t.whatsHappening, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
              ]),
            ),
            if (snap.hasData)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.35,
                  children: [for (final c in snap.data!) _CardTile(c)],
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

class _BigButton extends StatelessWidget {
  const _BigButton({required this.icon, required this.label, required this.color, required this.onTap});

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 64,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: color, width: 2),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          icon: Icon(icon, size: 26),
          label: FittedBox(child: Text(label)),
          onPressed: onTap,
        ),
      );
}

class _CardTile extends StatelessWidget {
  const _CardTile(this.card);

  final EmergencyCard card;

  @override
  Widget build(BuildContext context) => Material(
        color: kSurface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CardScreen(card: card))),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(card.icon, color: card.color, size: 34),
              const Spacer(),
              Text(card.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1.2)),
            ]),
          ),
        ),
      );
}

/// Barra in cima alla schermata Emergenza mentre il timer del fallout è attivo:
/// colore della fase, tempo trascorso e indicazione breve. Tocca per aprire il timer.
class FalloutBanner extends StatelessWidget {
  const FalloutBanner({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: FalloutTimer.instance,
        builder: (context, _) {
          final timer = FalloutTimer.instance;
          if (!timer.running) return const SizedBox.shrink();
          return StreamBuilder<void>(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, _) {
              final t = AppLocalizations.of(context);
              final phase = phaseAt(timer.hours);
              final elapsed = DateTime.now().difference(timer.start!);
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Material(
                  color: phase.color.withValues(alpha: 0.18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: phase.color, width: 2),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FalloutScreen())),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                      child: Row(children: [
                        Icon(phase.icon, color: phase.color, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(phase.title(t),
                                style: TextStyle(color: phase.color, fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(phase.canGoOut ? t.falloutBannerOut : t.doNotGoOut,
                                style: const TextStyle(fontSize: 14)),
                          ]),
                        ),
                        const SizedBox(width: 8),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          const Icon(Icons.timer, size: 16, color: Colors.white70),
                          Text(formatDuration(t, elapsed),
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFeatures: [FontFeature.tabularFigures()])),
                        ]),
                      ]),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
}
