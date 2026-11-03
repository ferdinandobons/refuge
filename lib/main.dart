import 'package:flutter/material.dart';

import 'app/home.dart';
import 'app/onboarding.dart';
import 'app/settings.dart';
import 'app/theme.dart';
import 'features/tools/fallout_phases.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.instance.load();
  await FalloutTimer.instance.load();
  runApp(const RifugioApp());
}

class RifugioApp extends StatelessWidget {
  const RifugioApp({super.key});

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
          home: AppSettings.instance.onboarded ? const HomeScreen() : const OnboardingScreen(),
        ),
      );
}
