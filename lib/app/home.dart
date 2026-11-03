import 'package:flutter/material.dart';

import '../features/guides/guides_screen.dart';
import '../features/library/library_screen.dart';
import '../features/tools/tools_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  static const _pages = [GuidesScreen(), ToolsScreen(), LibraryScreen()];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(index: _index, children: _pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.menu_book), label: 'Guide'),
            NavigationDestination(icon: Icon(Icons.handyman), label: 'Strumenti'),
            NavigationDestination(icon: Icon(Icons.local_library), label: 'Biblioteca'),
          ],
        ),
      );
}
