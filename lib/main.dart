import 'package:flutter/material.dart';

import 'app/home.dart';
import 'app/theme.dart';

void main() => runApp(const RifugioApp());

class RifugioApp extends StatelessWidget {
  const RifugioApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Rifugio',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const HomeScreen(),
      );
}
