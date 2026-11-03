import 'package:flutter/material.dart';

import '../features/library/zim/catalog_screen.dart';
import '../features/maps/map_download.dart';
import '../l10n/app_localizations.dart';
import 'countries.dart';
import 'settings.dart';
import 'theme.dart';

/// Primo avvio in tre passi: lingua, paese, pronto.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.initialPage = 0});

  final int initialPage;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final _pages = PageController(initialPage: widget.initialPage);
  late int _page = widget.initialPage;

  void _go(int page) {
    setState(() => _page = page);
    _pages.animateToPage(page, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final s = AppSettings.instance;
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Row(children: [
              if (_page > 0) IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => _go(_page - 1)),
              const Spacer(),
              Text('${_page + 1} / 4', style: const TextStyle(color: Colors.white54)),
            ]),
          ),
          Expanded(
            child: PageView(
              controller: _pages,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _Step(
                  icon: Icons.language,
                  title: t.onbLanguageTitle,
                  children: [
                    for (final (code, name) in kLanguages)
                      _Choice(
                        label: name,
                        selected: s.language == code,
                        onTap: () async {
                          await s.setLanguage(code);
                          _go(1);
                        },
                      ),
                  ],
                ),
                _Step(
                  icon: Icons.flag,
                  title: t.onbCountryTitle,
                  subtitle: t.onbCountryHint,
                  children: [
                    // Prima il paese selezionato (quello del telefono), poi i paesi della lingua scelta.
                    for (final c in [
                      if (s.country.code != 'XX') s.country,
                      ...kCountries.where((c) => c.code != s.country.code && c.language == s.language && c.code != 'XX'),
                      ...kCountries.where((c) => c.code != s.country.code && (c.language != s.language || c.code == 'XX')),
                      if (s.country.code == 'XX') s.country,
                    ])
                      _Choice(
                        label: c.name(t),
                        trailing: c.emergency,
                        selected: s.country.code == c.code,
                        onTap: () async {
                          await s.setCountry(c.code);
                          _go(2);
                        },
                      ),
                  ],
                ),
                _Step(
                  icon: Icons.map,
                  title: t.onbMapTitle,
                  subtitle: t.onbMapBody,
                  children: [
                    MapPicker(onStarted: () => _go(3)),
                    const SizedBox(height: 4),
                    TextButton(
                      style: TextButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                      onPressed: () => _go(3),
                      child: Text(t.mapSkip, style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
                _Step(
                  icon: Icons.check_circle,
                  title: t.onbReadyTitle,
                  subtitle: t.onbReadyBody(s.country.emergency),
                  children: [
                    Text(t.onbOptionalTitle,
                        style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 6),
                    Text(t.onbOptionalBody, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                    const SizedBox(height: 8),
                    _Pack(Icons.medical_information, t.onbPackWikimed, t.onbPackWikimedBody),
                    _Pack(Icons.public, t.onbPackWikipedia, t.onbPackWikipediaBody),
                    _Pack(Icons.map, t.onbPackWikivoyage, t.onbPackWikivoyageBody),
                    Text(t.onbDownloadNote, style: const TextStyle(color: Colors.white54, fontSize: 14)),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(64)),
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(t.onbStart, style: const TextStyle(fontSize: 20)),
                      onPressed: s.finishOnboarding,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                      icon: const Icon(Icons.download),
                      label: Text(t.onbDownload),
                      onPressed: () async {
                        await s.finishOnboarding();
                        if (context.mounted) {
                          await Navigator.push(context, MaterialPageRoute(builder: (_) => const CatalogScreen()));
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.icon, required this.title, this.subtitle, required this.children});

  final IconData icon;
  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Icon(icon, size: 56, color: kAccent),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle!, style: const TextStyle(fontSize: 17, color: Colors.white70, height: 1.4)),
          ],
          const SizedBox(height: 24),
          ...children,
        ],
      );
}

/// Una raccolta scaricabile, con quello che contiene.
class _Pack extends StatelessWidget {
  const _Pack(this.icon, this.title, this.body);

  final IconData icon;
  final String title, body;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: kAccent, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(body, style: const TextStyle(fontSize: 15, color: Colors.white70, height: 1.35)),
            ]),
          ),
        ]),
      );
}

class _Choice extends StatelessWidget {
  const _Choice({required this.label, required this.onTap, this.selected = false, this.trailing});

  final String label;
  final String? trailing;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(
          color: selected ? kAccent.withValues(alpha: 0.2) : kSurface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(children: [
                Expanded(child: Text(label, style: const TextStyle(fontSize: 20))),
                if (trailing != null) Text(trailing!, style: const TextStyle(fontSize: 18, color: Colors.white54)),
              ]),
            ),
          ),
        ),
      );
}
