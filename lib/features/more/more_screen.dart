import 'package:flutter/material.dart';

import '../../app/countries.dart';
import '../../app/settings.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import 'attributions_screen.dart';

/// Impostazioni e informazioni sull'app.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final s = AppSettings.instance;
    final language = kLanguages.firstWhere((l) => l.$1 == s.language).$2;
    return Scaffold(
      appBar: AppBar(title: Text(t.tabMore)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Tile(Icons.language, t.language, language, () => _pickLanguage(context)),
          _Tile(Icons.flag, t.country, s.country.name(t), () => _pickCountry(context)),
          const SizedBox(height: 20),
          _Tile(Icons.info_outline, t.about, t.aboutBody, () => _about(context)),
          _Tile(Icons.gavel, t.attributionsTitle, t.attributionsSubtitle,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttributionsScreen()))),
        ],
      ),
    );
  }

  Future<void> _pickLanguage(BuildContext context) async {
    final code = await showDialog<String>(
      context: context,
      builder: (c) => SimpleDialog(children: [
        for (final (code, name) in kLanguages)
          SimpleDialogOption(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            onPressed: () => Navigator.pop(c, code),
            child: Text(name, style: const TextStyle(fontSize: 19)),
          ),
      ]),
    );
    if (code != null) await AppSettings.instance.setLanguage(code);
  }

  Future<void> _pickCountry(BuildContext context) async {
    final t = AppLocalizations.of(context);
    final code = await showDialog<String>(
      context: context,
      builder: (c) => SimpleDialog(children: [
        for (final country in kCountries)
          SimpleDialogOption(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            onPressed: () => Navigator.pop(c, country.code),
            child: Row(children: [
              Expanded(child: Text(country.name(t), style: const TextStyle(fontSize: 18))),
              Text(country.emergency, style: const TextStyle(color: Colors.white54)),
            ]),
          ),
      ]),
    );
    if (code != null) await AppSettings.instance.setCountry(code);
  }

  void _about(BuildContext context) {
    final t = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t.appTitle, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(t.aboutText, style: const TextStyle(height: 1.4)),
          ]),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.icon, this.title, this.subtitle, this.onTap);

  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Icon(icon, color: kAccent, size: 30),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      );
}
