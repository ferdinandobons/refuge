import 'package:flutter/material.dart';

import '../features/emergency/emergency_screen.dart';
import '../features/more/more_screen.dart';
import '../features/prepare/prepare_screen.dart';
import '../features/library/zim/downloads.dart';
import '../features/maps/map_regions.dart';
import '../features/tools/fallout_phases.dart';
import '../features/tools/tools_screen.dart';
import '../l10n/app_localizations.dart';
import 'downloads_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  static const _pages = [EmergencyScreen(), PrepareScreen(), ToolsScreen(), MoreScreen()];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      // In cima a tutte le schede, quando servono: prima i download in corso, poi il timer del fallout.
      body: ListenableBuilder(
        listenable: Listenable.merge([FalloutTimer.instance, MapRegions.instance, ZimDownloads.instance]),
        builder: (context, child) {
          final downloads = DownloadsBanner.active, fallout = FalloutTimer.instance.running;
          if (!downloads && !fallout) return child!;
          return Column(children: [
            SafeArea(
              bottom: false,
              child: Column(children: [
                if (downloads) const DownloadsBanner(),
                if (fallout) const FalloutBanner(),
              ]),
            ),
            Expanded(child: MediaQuery.removePadding(context: context, removeTop: true, child: child!)),
          ]);
        },
        child: IndexedStack(index: _index, children: _pages),
      ),
      // Linea chiara sul bordo superiore: separa la barra dai riquadri, che hanno lo stesso colore.
      bottomNavigationBar: DecoratedBox(
        // In primo piano: lo sfondo della barra altrimenti copre il bordo.
        position: DecorationPosition.foreground,
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white38))),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(icon: const Icon(Icons.emergency), label: t.tabEmergency),
            NavigationDestination(icon: const Icon(Icons.inventory_2), label: t.tabPrepare),
            NavigationDestination(icon: const Icon(Icons.handyman), label: t.tabTools),
            NavigationDestination(icon: const Icon(Icons.more_horiz), label: t.tabMore),
          ],
        ),
      ),
    );
  }
}
