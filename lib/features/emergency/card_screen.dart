import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../app/settings.dart';
import '../../app/speech.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../guides/guide_links.dart';
import 'cards.dart';
import 'emergency_screen.dart';

/// Una scheda, un passo alla volta: testo grande, avanti/indietro, lettura ad alta voce, schermo sempre acceso.
class CardScreen extends StatefulWidget {
  const CardScreen({super.key, required this.card});

  final EmergencyCard card;

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final _pages = PageController();
  int _index = 0;
  bool _voice = false;

  EmergencyCard get card => widget.card;

  /// Un passo per pagina, più una pagina finale con cosa NON fare.
  int get _count => card.steps.length + 1;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    Speech.stop();
    _pages.dispose();
    super.dispose();
  }

  String _pageText(AppLocalizations t, int i) =>
      i < card.steps.length ? card.steps[i] : '${t.neverDo}. ${card.never.join(' ')}';

  void _onPage(int i) {
    setState(() => _index = i);
    if (_voice) Speech.speak(_pageText(AppLocalizations.of(context), i), AppSettings.instance.language);
  }

  void _toggleVoice() {
    setState(() => _voice = !_voice);
    _voice ? Speech.speak(_pageText(AppLocalizations.of(context), _index), AppSettings.instance.language) : Speech.stop();
  }

  void _goTo(int i) => _pages.animateToPage(i, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final country = AppSettings.instance.country;
    final last = _index == _count - 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(card.title),
        actions: [
          IconButton(
            icon: Icon(_voice ? Icons.volume_up : Icons.volume_off),
            tooltip: t.readAloud,
            onPressed: _toggleVoice,
          ),
          IconButton(icon: const Icon(Icons.list), tooltip: t.allSteps, onPressed: () => _showAll(t)),
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              for (var i = 0; i < _count; i++)
                Expanded(
                  child: Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: i <= _index ? card.color : Colors.white12,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
            ]),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pages,
              itemCount: _count,
              onPageChanged: _onPage,
              itemBuilder: (context, i) => i < card.steps.length
                  ? _StepPage(number: i + 1, total: card.steps.length, text: card.steps[i], color: card.color, t: t)
                  : _NeverPage(card: card, note: country.cardNote(card.id, t), t: t),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(children: [
              if (_index > 0)
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(60)),
                    onPressed: () => _goTo(_index - 1),
                    child: Text(t.previous, style: const TextStyle(fontSize: 18)),
                  ),
                ),
              if (_index > 0) const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(60)),
                  onPressed: last ? () => Navigator.pop(context) : () => _goTo(_index + 1),
                  child: Text(last ? t.done : t.next, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, card.group == 'body' ? 2 : 0, 16, 8),
            // Nel primo soccorso chiamare è spesso la cosa più urgente: lì è un pulsante vero.
            child: card.group == 'body'
                ? OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kDanger,
                      side: const BorderSide(color: kDanger, width: 2),
                      minimumSize: const Size.fromHeight(56),
                    ),
                    icon: const Icon(Icons.call, size: 24),
                    label: Text(t.callNumber(country.emergency),
                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                    onPressed: () => callNumber(country.emergency),
                  )
                : TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: kDanger, minimumSize: const Size.fromHeight(48)),
                    icon: const Icon(Icons.call),
                    label: Text(t.callNumber(country.emergency), style: const TextStyle(fontSize: 17)),
                    onPressed: () => callNumber(country.emergency),
                  ),
          ),
        ]),
      ),
    );
  }

  void _showAll(AppLocalizations t) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (c) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          builder: (c, scroll) => ListView(
            controller: scroll,
            padding: const EdgeInsets.all(20),
            children: [
              Text(card.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              for (var i = 0; i < card.steps.length; i++)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: card.color,
                    child: Text('${i + 1}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(card.steps[i], style: const TextStyle(fontSize: 17)),
                  onTap: () {
                    Navigator.pop(c);
                    _goTo(i);
                  },
                ),
              const SizedBox(height: 12),
              Text(t.neverDo.toUpperCase(), style: const TextStyle(color: kDanger, fontWeight: FontWeight.bold)),
              for (final n in card.never)
                Padding(padding: const EdgeInsets.only(top: 6), child: Text('✕  $n', style: const TextStyle(fontSize: 16))),
              const Divider(height: 32),
              Text(t.sources, style: const TextStyle(color: Colors.white54)),
              FutureBuilder(
                future: refTitles(card.refs, AppSettings.instance.language),
                builder: (context, snap) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  for (final r in card.refs)
                    r.contains(':') && !r.contains(' ')
                        ? TextButton(
                            style: TextButton.styleFrom(alignment: Alignment.centerLeft, padding: EdgeInsets.zero),
                            onPressed: () => openGuideTarget(context, r),
                            child: Text(snap.data?[r] ?? r.split(':').last.split('#').first,
                                style: const TextStyle(fontSize: 13)),
                          )
                        : Text(r, style: const TextStyle(color: Colors.white38, fontSize: 13)),
                ]),
              ),
            ],
          ),
        ),
      );
}

class _StepPage extends StatelessWidget {
  const _StepPage({required this.number, required this.total, required this.text, required this.color, required this.t});

  final int number, total;
  final String text;
  final Color color;
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t.stepOf(number, total), style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Text(text, style: const TextStyle(fontSize: 30, height: 1.3, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      );
}

class _NeverPage extends StatelessWidget {
  const _NeverPage({required this.card, required this.note, required this.t});

  final EmergencyCard card;
  final String? note;
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        children: [
          Row(children: [
            const Icon(Icons.dangerous, color: kDanger, size: 32),
            const SizedBox(width: 10),
            Text(t.neverDo.toUpperCase(),
                style: const TextStyle(color: kDanger, fontSize: 22, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 16),
          for (final n in card.never)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(n, style: const TextStyle(fontSize: 24, height: 1.3)),
            ),
          if (note != null)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: kAccent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: Text(note!, style: const TextStyle(fontSize: 18)),
            ),
        ],
      );
}
