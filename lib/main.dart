import 'package:flutter/material.dart';

import 'app/home.dart';
import 'app/onboarding.dart';
import 'app/settings.dart';
import 'app/theme.dart';
import 'features/library/zim/downloads.dart';
import 'features/tools/fallout_phases.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.instance.load();
  await FalloutTimer.instance.load();
  // Riprende a seguire i download delle enciclopedie avviati prima (anche ad app chiusa).
  ZimDownloads.instance.init();
  runApp(const RefugeApp());
}

class RefugeApp extends StatelessWidget {
  const RefugeApp({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: AppSettings.instance,
        builder: (context, _) => MaterialApp(
          onGenerateTitle: (c) => AppLocalizations.of(c).appTitle,
          debugShowCheckedModeBanner: false,
          theme: buildTheme(),
          locale: AppSettings.instance.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // Il testo segue l'impostazione del telefono, fino a 1,6 volte: oltre, i comandi non starebbero sullo schermo.
          builder: (context, child) => MediaQuery.withClampedTextScaling(maxScaleFactor: 1.6, child: child!),
          home: AppSettings.instance.onboarded ? const HomeScreen() : const OnboardingScreen(),
        ),
      );
}
