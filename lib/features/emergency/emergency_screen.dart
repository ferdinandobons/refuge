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
                // Un titolo per gruppo: il colore da solo non basta (chi distingue male rosso e giallo).
                // Le schede crescono con il testo: con i caratteri grandi (accessibilità) una per riga.
                sliver: SliverList.list(children: [
                  for (final (group, cards) in _groups(snap.data!)) ...[
                    _GroupHeader(groupTitle(t, group), groupColor(group)),
                    for (final row in _rows(cards, _columns(context)))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: IntrinsicHeight(
                          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                            for (final (i, c) in row.indexed) ...[
                              if (i > 0) const SizedBox(width: 10),
                              Expanded(child: _CardTile(c)),
                            ],
                            if (row.length == 1 && _columns(context) == 2) ...[
                              const SizedBox(width: 10),
                              const Expanded(child: SizedBox()),
                            ],
                          ]),
                        ),
                      ),
                  ],
                ]),
              ),
          ]),
        ),
      ),
    );
  }
}

int _columns(BuildContext context) => MediaQuery.textScalerOf(context).scale(1) > 1.35 ? 1 : 2;

List<List<EmergencyCard>> _rows(List<EmergencyCard> cards, int columns) => [
      for (var i = 0; i < cards.length; i += columns) cards.sublist(i, (i + columns).clamp(0, cards.length)),
    ];

/// Le schede divise per gruppo, nell'ordine del file (prima le rosse, poi le gialle, poi le blu).
List<(String, List<EmergencyCard>)> _groups(List<EmergencyCard> cards) {
  final groups = <String, List<EmergencyCard>>{};
  for (final c in cards) {
    (groups[c.group] ??= []).add(c);
  }
  return [for (final e in groups.entries) (e.key, e.value)];
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader(this.title, this.color);

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) => Semantics(
        header: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 10),
          child: Row(children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title.toUpperCase(),
                  style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
            ),
          ]),
        ),
      );
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
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 96),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(card.icon, color: card.color, size: 34),
                const SizedBox(height: 10),
                Text(card.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1.2)),
              ]),
            ),
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
                            // Prima riga: fase a sinistra, tempo trascorso a destra (icona e ore sempre insieme).
                            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Expanded(
                                child: Text(phase.title(t),
                                    style: TextStyle(color: phase.color, fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              Row(mainAxisSize: MainAxisSize.min, children: [
                                const Icon(Icons.timer, size: 18, color: Colors.white70),
                                const SizedBox(width: 4),
                                Text(formatDuration(t, elapsed),
                                    maxLines: 1,
                                    softWrap: false,
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold, fontFeatures: [FontFeature.tabularFigures()])),
                              ]),
                            ]),
                            const SizedBox(height: 2),
                            Text(phase.canGoOut ? t.falloutBannerOut : t.doNotGoOut, style: const TextStyle(fontSize: 14)),
                          ]),
                        ),
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
