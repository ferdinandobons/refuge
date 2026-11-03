import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'morse.dart';

class MorseScreen extends StatefulWidget {
  const MorseScreen({super.key});

  @override
  State<MorseScreen> createState() => _MorseScreenState();
}

class _MorseScreenState extends State<MorseScreen> {
  final _controller = TextEditingController(text: 'SOS');
  bool _on = false;
  bool _playing = false;
  bool _useTorch = true;
  bool _loop = false;
  double _unitMs = 200;
  late final _player = MorsePlayer((on) {
    if (mounted) setState(() => _on = on);
  });

  Future<void> _play() async {
    if (_playing) {
      await _player.stop(useTorch: _useTorch);
      setState(() => _playing = false);
      return;
    }
    setState(() => _playing = true);
    await _player.play(_controller.text, unitMs: _unitMs.round(), loop: _loop, useTorch: _useTorch);
    if (mounted) setState(() => _playing = false);
  }

  @override
  void dispose() {
    _player.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Morse')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(labelText: 'Messaggio', border: OutlineInputBorder()),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            SelectableText(encodeMorse(_controller.text),
                style: const TextStyle(fontSize: 22, letterSpacing: 2, color: kAccent, fontFamily: 'monospace')),
            const SizedBox(height: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 30),
              height: 120,
              decoration: BoxDecoration(
                color: _on ? Colors.white : kSurface,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SwitchListTile(
              title: const Text('Usa anche la torcia'),
              value: _useTorch,
              onChanged: _playing ? null : (v) => setState(() => _useTorch = v),
            ),
            SwitchListTile(
              title: const Text('Ripeti'),
              value: _loop,
              onChanged: _playing ? null : (v) => setState(() => _loop = v),
            ),
            ListTile(
              title: Text('Velocità: punto = ${_unitMs.round()} ms'),
              subtitle: Slider(
                min: 80,
                max: 600,
                value: _unitMs,
                onChanged: _playing ? null : (v) => setState(() => _unitMs = v),
              ),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
              icon: Icon(_playing ? Icons.stop : Icons.play_arrow),
              label: Text(_playing ? 'Ferma' : 'Trasmetti'),
              onPressed: _play,
            ),
            const SizedBox(height: 24),
            const Text('Tabella', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final e in kMorse.entries)
                  Container(
                    width: 96,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(8)),
                    child: Text('${e.key}  ${e.value}', style: const TextStyle(fontFamily: 'monospace', fontSize: 16)),
                  ),
              ],
            ),
          ],
        ),
      );
}
