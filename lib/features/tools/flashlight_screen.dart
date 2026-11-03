import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'morse.dart';

class FlashlightScreen extends StatefulWidget {
  const FlashlightScreen({super.key});

  @override
  State<FlashlightScreen> createState() => _FlashlightScreenState();
}

class _FlashlightScreenState extends State<FlashlightScreen> {
  bool _torchOn = false;
  bool _sos = false;
  bool _flash = false;
  bool _torchMissing = false;
  late final _player = MorsePlayer((on) {
    if (mounted) setState(() => _flash = on);
  });

  Future<void> _toggleTorch() async {
    await _player.stop();
    final ok = await setTorch(!_torchOn);
    setState(() {
      _sos = false;
      _torchMissing = !ok;
      if (ok) _torchOn = !_torchOn;
    });
  }

  Future<void> _toggleSos() async {
    if (_sos) {
      setState(() => _sos = false);
      await _player.stop();
      return;
    }
    await setTorch(false);
    setState(() {
      _sos = true;
      _torchOn = false;
    });
    _player.play('SOS', unitMs: 250, loop: true);
  }

  @override
  void dispose() {
    _player.stop();
    setTorch(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _sos && _flash ? Colors.white : Colors.black,
        appBar: AppBar(title: const Text('Torcia e SOS'), backgroundColor: Colors.transparent),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                _BigButton(
                  label: _torchOn ? 'Spegni torcia' : 'Accendi torcia',
                  icon: _torchOn ? Icons.flashlight_off : Icons.flashlight_on,
                  color: kAccent,
                  onTap: _toggleTorch,
                ),
                if (_torchMissing)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('Torcia non disponibile su questo dispositivo. Usa la luce schermo.',
                        textAlign: TextAlign.center, style: TextStyle(color: Colors.white60)),
                  ),
                const SizedBox(height: 20),
                _BigButton(
                  label: _sos ? 'Ferma SOS' : 'SOS lampeggiante',
                  icon: Icons.sos,
                  color: kDanger,
                  onTap: _toggleSos,
                ),
                const SizedBox(height: 20),
                _BigButton(
                  label: 'Luce schermo',
                  icon: Icons.light_mode,
                  color: Colors.white,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _ScreenLight())),
                ),
                const Spacer(),
                Text(
                  'SOS = ··· ─── ··· ripetuto. Segnale internazionale di soccorso, visibile di notte anche a chilometri.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _sos && _flash ? Colors.black54 : Colors.white54),
                ),
              ],
            ),
          ),
        ),
      );
}

class _BigButton extends StatelessWidget {
  const _BigButton({required this.label, required this.icon, required this.color, required this.onTap});

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 76,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            backgroundColor: Colors.black,
            side: BorderSide(color: color, width: 2),
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          icon: Icon(icon, size: 30),
          label: Text(label),
          onPressed: onTap,
        ),
      );
}

class _ScreenLight extends StatelessWidget {
  const _ScreenLight();

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: Text('Tocca per chiudere', style: TextStyle(color: Colors.black26))),
        ),
      );
}
