import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_map_tiles_pmtiles/vector_map_tiles_pmtiles.dart';
// Stili Protomaps v4 grezzi: servono per semplificare le etichette (vedi _theme).
// ignore: implementation_imports
import 'package:vector_map_tiles_pmtiles/src/themes/v4/_package.dart' as v4;
import 'package:vector_tile_renderer/vector_tile_renderer.dart' as vtr show Theme, ThemeLayerType;

import '../../app/settings.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import 'map_regions.dart';

/// Mappa offline con le zone scaricate, dal mondo intero fino alle singole vie, e la posizione GPS.
class OfflineMap extends StatefulWidget {
  const OfflineMap({super.key, this.position, this.accuracy, required this.fallbackCenter});

  final LatLng? position;
  final double? accuracy;
  final LatLng fallbackCenter;

  @override
  State<OfflineMap> createState() => _OfflineMapState();
}

class _OfflineMapState extends State<OfflineMap> {
  final _controller = MapController();
  List<(MapRegion, PmTilesVectorTileProvider)>? _providers;
  bool _centered = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final regions = MapRegions.instance;
    if (!regions.loaded) await regions.refresh();
    final providers = <(MapRegion, PmTilesVectorTileProvider)>[];
    for (final (r, File f) in regions.installed) {
      try {
        providers.add((r, await PmTilesVectorTileProvider.fromSource(f.path)));
      } catch (_) {
        // File danneggiato o incompleto: ignorato.
      }
    }
    if (mounted) setState(() => _providers = providers);
  }

  @override
  void didUpdateWidget(OfflineMap old) {
    super.didUpdateWidget(old);
    // Alla prima posizione GPS la mappa si centra su di te.
    if (!_centered && widget.position != null && _providers != null) {
      _centered = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _controller.move(widget.position!, 15));
    }
  }

  void _zoom(double delta) {
    final cam = _controller.camera;
    _controller.move(cam.center, (cam.zoom + delta).clamp(1, 18));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final providers = _providers;
    if (providers == null) return const Center(child: CircularProgressIndicator());
    final base = _theme(AppSettings.instance.language);
    // Sopra la prima zona si disegnano solo strade e luoghi, senza lo sfondo che coprirebbe quelle sotto.
    final overlay = base.copyWith(types: vtr.ThemeLayerType.values.where((t) => t != vtr.ThemeLayerType.background).toSet());
    final pos = widget.position;
    return Stack(children: [
      FlutterMap(
        mapController: _controller,
        options: MapOptions(
          initialCenter: pos ?? widget.fallbackCenter,
          initialZoom: pos != null ? 15 : 5,
          minZoom: 1,
          maxZoom: 18,
          backgroundColor: const Color(0xFF1A1A1A),
          interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
        ),
        children: [
          for (final (i, (_, provider)) in providers.indexed)
            VectorTileLayer(
              theme: i == 0 ? base : overlay,
              tileProviders: TileProviders({'protomaps': provider}),
              // Modalità vettoriale: disegna anche i nomi di città e vie.
              layerMode: VectorTileLayerMode.vector,
            ),
          if (pos != null && widget.accuracy != null)
            CircleLayer(circles: [
              CircleMarker(
                point: pos,
                radius: widget.accuracy!,
                useRadiusInMeter: true,
                color: kAccent.withValues(alpha: 0.15),
                borderColor: kAccent.withValues(alpha: 0.5),
                borderStrokeWidth: 1,
              ),
            ]),
          if (pos != null)
            MarkerLayer(markers: [
              Marker(
                point: pos,
                width: 26,
                height: 26,
                child: Container(
                  decoration: BoxDecoration(
                    color: kAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ]),
          const SimpleAttributionWidget(source: Text('OpenStreetMap · Protomaps')),
        ],
      ),
      Positioned(
        right: 10,
        top: 10,
        child: Column(children: [
          _MapButton(icon: Icons.add, tooltip: t.zoomIn, onTap: () => _zoom(1)),
          const SizedBox(height: 6),
          _MapButton(icon: Icons.remove, tooltip: t.zoomOut, onTap: () => _zoom(-1)),
          const SizedBox(height: 6),
          _MapButton(icon: Icons.public, tooltip: t.wholeWorld, onTap: () => _controller.move(const LatLng(30, 10), 1.5)),
          if (pos != null) ...[
            const SizedBox(height: 6),
            _MapButton(icon: Icons.my_location, tooltip: t.myPosition, onTap: () => _controller.move(pos, 16)),
          ],
        ]),
      ),
    ]);
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({required this.icon, required this.tooltip, required this.onTap});

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.black.withValues(alpha: 0.75),
        shape: const CircleBorder(side: BorderSide(color: Colors.white24)),
        child: IconButton(icon: Icon(icon), tooltip: tooltip, onPressed: onTap),
      );
}

/// Tema scuro Protomaps con etichette semplificate: nome nella lingua scelta, altrimenti quello locale.
/// Le espressioni originali ("case" a più rami) non vengono disegnate dal motore di rendering.
vtr.Theme _theme(String language) => const ProtomapsThemes().build([
      for (final layer in v4.themeDark)
        if (layer['type'] == 'symbol' && (layer['layout'] as Map?)?.containsKey('text-field') == true)
          {
            ...layer,
            'layout': {
              ...(layer['layout']! as Map<String, Object>),
              'text-field': [
                'coalesce',
                ['get', 'name:$language'],
                ['get', 'name'],
              ],
            },
          }
        else
          layer,
    ]);
