import 'package:flutter/material.dart';

import '../features/emergency/emergency_screen.dart';
import '../features/more/more_screen.dart';
import '../features/prepare/prepare_screen.dart';
import '../features/tools/fallout_phases.dart';
import '../features/tools/tools_screen.dart';
import '../l10n/app_localizations.dart';

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
      // Con il timer del fallout attivo, la barra della fase resta in cima a tutte le schede.
      body: ListenableBuilder(
        listenable: FalloutTimer.instance,
        builder: (context, child) => !FalloutTimer.instance.running
            ? child!
            : Column(children: [
                const SafeArea(bottom: false, child: FalloutBanner()),
                Expanded(child: MediaQuery.removePadding(context: context, removeTop: true, child: child!)),
              ]),
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
