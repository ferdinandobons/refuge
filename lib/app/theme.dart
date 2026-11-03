import 'package:flutter/material.dart';

/// Colori principali. Sfondo nero puro: sugli schermi OLED risparmia batteria.
const kAccent = Color(0xFFFFB300);
const kDanger = Color(0xFFEF5350);
const kSurface = Color(0xFF121212);

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: kAccent,
    brightness: Brightness.dark,
  ).copyWith(
    primary: kAccent,
    onPrimary: Colors.black,
    surface: Colors.black,
    surfaceContainerHighest: kSurface,
    error: kDanger,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.black, elevation: 0),
    navigationBarTheme: const NavigationBarThemeData(backgroundColor: kSurface),
    cardTheme: const CardThemeData(color: kSurface, margin: EdgeInsets.zero),
  );
}
