import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/settings.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import 'fallout.dart';
import 'fallout_phases.dart';

/// Timer del fallout: si avvia al momento dell'esplosione e indica fase per fase cosa fare e cosa indossare.
class FalloutScreen extends StatefulWidget {
  const FalloutScreen({super.key});

  @override
  State<FalloutScreen> createState() => _FalloutScreenState();
}

class _FalloutScreenState extends State<FalloutScreen> {
  final _timer = FalloutTimer.instance;
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _timer.load();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timer.running && mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  void _setStart(DateTime? start) => _timer.set(start);

  Future<void> _pickTime() async {
    final now = DateTime.now();
    final day = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 60)),
      lastDate: now,
    );
    if (day == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(now));
    if (time == null) return;
    // Intervalli di 5 minuti: basta un'indicazione approssimativa.
    final minute = (time.minute / 5).round() * 5;
    var start = DateTime(day.year, day.month, day.day, time.hour).add(Duration(minutes: minute));
    if (start.isAfter(now)) start = now;
    _setStart(start);
  }

  Future<void> _reset(AppLocalizations t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(t.falloutResetQ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(t.cancel)),
          TextButton(onPressed: () => Navigator.pop(c, true), child: Text(t.reset)),
        ],
      ),
    );
    if (ok == true) _setStart(null);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.falloutTitle),
        actions: [
          if (_timer.running) IconButton(icon: const Icon(Icons.restart_alt), tooltip: t.reset, onPressed: () => _reset(t)),
        ],
      ),
      body: ListenableBuilder(
        listenable: _timer,
        builder: (context, _) => !_timer.loaded
            ? const Center(child: CircularProgressIndicator())
            : _timer.start == null
                ? _StartView(onNow: () => _setStart(DateTime.now()), onPick: _pickTime)
                : _TimerView(start: _timer.start!),
      ),
    );
  }
}

class _StartView extends StatelessWidget {
  const _StartView({required this.onNow, required this.onPick});

  final VoidCallback onNow, onPick;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Icon(Icons.radar, size: 64, color: kAccent),
        const SizedBox(height: 16),
        Text(t.falloutStartIntro, style: const TextStyle(fontSize: 18, height: 1.4)),
        const SizedBox(height: 24),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: kDanger,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(76),
          ),
          icon: const Icon(Icons.timer, size: 30),
          label: Text(t.falloutStartNow, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          onPressed: onNow,
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(60)),
          icon: const Icon(Icons.schedule),
          label: Text(t.falloutStartAt, style: const TextStyle(fontSize: 17)),
          onPressed: onPick,
        ),
        const SizedBox(height: 24),
        Text(t.falloutDisclaimer, style: const TextStyle(color: Colors.white54)),
      ],
    );
  }
}

class _TimerView extends StatelessWidget {
  const _TimerView({required this.start});

  final DateTime start;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final lang = AppSettings.instance.language;
    final elapsed = DateTime.now().difference(start);
    final hours = elapsed.inSeconds / 3600;
    final phase = phaseAt(hours);
    final next = phase.toHours == null ? null : start.add(Duration(minutes: (phase.toHours! * 60).round()));
    final clock = DateFormat.Hm(lang);
    final dayClock = DateFormat('E d MMM, HH:mm', lang);
    final remaining = remainingFraction(hours);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(t.falloutSince(dayClock.format(start)), style: const TextStyle(color: Colors.white60)),
        const SizedBox(height: 4),
        Text(_duration(t, elapsed), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        // Fase attuale
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: phase.color.withValues(alpha: 0.15),
            border: Border.all(color: phase.color, width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(phase.icon, color: phase.color, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Text(phase.title(t),
                    style: TextStyle(color: phase.color, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ]),
            const SizedBox(height: 10),
            Text(
              hours < 1 ? t.falloutMax : t.falloutRemaining(NumberFormat.percentPattern(lang).format(remaining)),
              style: const TextStyle(fontSize: 16),
            ),
            if (next != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(t.falloutNextPhase(_duration(t, next.difference(DateTime.now())), clock.format(next)),
                    style: const TextStyle(color: Colors.white70)),
              ),
          ]),
        ),
        const SizedBox(height: 16),
        // Cosa indossare per uscire
        Text(t.whatToWear.toUpperCase(),
            style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        const SizedBox(height: 8),
        if (!phase.canGoOut)
          _Wear(icon: Icons.do_not_disturb_on, label: t.doNotGoOut, color: kDanger)
        else
          Wrap(spacing: 8, runSpacing: 8, children: [
            _Wear(icon: Icons.masks, label: t.wearMask),
            _Wear(icon: Icons.front_hand, label: t.wearGloves),
            _Wear(icon: Icons.checkroom, label: t.wearCovered),
            _Wear(icon: Icons.hiking, label: t.wearBoots),
          ]),
        const SizedBox(height: 16),
        Text(t.whatToDoNow.toUpperCase(),
            style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        const SizedBox(height: 6),
        for (final a in phase.actions(t))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.arrow_right, color: phase.color),
              const SizedBox(width: 4),
              Expanded(child: Text(a, style: const TextStyle(fontSize: 18, height: 1.3))),
            ]),
          ),
        const SizedBox(height: 16),
        // Tutte le fasi con l'ora di inizio
        Text(t.falloutTimeline.toUpperCase(),
            style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        const SizedBox(height: 6),
        for (final p in kPhases)
          Card(
            margin: const EdgeInsets.only(bottom: 6),
            color: p == phase ? p.color.withValues(alpha: 0.2) : kSurface,
            child: ListTile(
              leading: Icon(p.icon, color: p.color),
              title: Text(p.title(t), style: TextStyle(fontWeight: p == phase ? FontWeight.bold : FontWeight.normal)),
              trailing: Text(dayClock.format(start.add(Duration(minutes: (p.fromHours * 60).round()))),
                  style: const TextStyle(color: Colors.white60, fontSize: 13)),
            ),
          ),
        const SizedBox(height: 8),
        _Dosimeter(hours: hours),
        const SizedBox(height: 12),
        Text(t.falloutDisclaimer, style: const TextStyle(color: Colors.white54)),
      ],
    );
  }

  static String _duration(AppLocalizations t, Duration d) => formatDuration(t, d);
}

class _Wear extends StatelessWidget {
  const _Wear({required this.icon, required this.label, this.color = Colors.white});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(10)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: color, fontSize: 16)),
        ]),
      );
}

/// Calcolo con un dosimetro: dalla misura attuale, come scenderà l'intensità.
class _Dosimeter extends StatefulWidget {
  const _Dosimeter({required this.hours});

  final double hours;

  @override
  State<_Dosimeter> createState() => _DosimeterState();
}

class _DosimeterState extends State<_Dosimeter> {
  final _rate = TextEditingController();

  @override
  void dispose() {
    _rate.dispose();
    super.dispose();
  }

  String _fmt(double v) => v >= 100 ? v.toStringAsFixed(0) : v >= 1 ? v.toStringAsFixed(1) : v.toStringAsFixed(3);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final rate = double.tryParse(_rate.text.replaceAll(',', '.'));
    final t0 = widget.hours < 0.5 ? 0.5 : widget.hours;
    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.speed, color: kAccent),
        title: Text(t.haveDosimeter),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          TextField(
            controller: _rate,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: t.measuredRate, border: const OutlineInputBorder()),
            onChanged: (_) => setState(() {}),
          ),
          if (rate != null && rate > 0)
            for (final h in [t0 + 1, t0 + 6, t0 + 24, t0 + 72, t0 + 168])
              ListTile(
                dense: true,
                title: Text(t.inHours(h.round() - t0.round())),
                trailing: Text(_fmt(falloutRate(rate, t0, h)), style: const TextStyle(fontFamily: 'monospace', fontSize: 16)),
              ),
          if (rate != null && rate > 0)
            Text(t.falloutDose(_fmt(falloutDose(rate, t0, t0, t0 + 24))), style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
