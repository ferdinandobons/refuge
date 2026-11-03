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
import 'pins.dart';

/// Mappa offline con le zone scaricate, dal mondo intero fino alle singole vie, e la posizione GPS.
class OfflineMap extends StatefulWidget {
  const OfflineMap({
    super.key,
    this.position,
    this.accuracy,
    required this.fallbackCenter,
    this.pins = const [],
    this.selected,
    this.track = const [],
    this.onLongPress,
    this.onPinTap,
    this.focus,
    this.fitTo,
  });

  final LatLng? position;
  final double? accuracy;
  final LatLng fallbackCenter;

  /// Punti salvati; [selected] è collegato alla posizione con una linea retta.
  final List<Pin> pins;
  final Pin? selected;

  /// Percorso registrato.
  final List<LatLng> track;
  final void Function(LatLng point)? onLongPress;
  final void Function(Pin pin)? onPinTap;

  /// Quando cambia, la mappa si sposta su questo punto.
  final LatLng? focus;

  /// Quando cambia, la mappa inquadra tutti questi punti (es. il percorso registrato).
  final List<LatLng>? fitTo;

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
    final fit = widget.fitTo;
    if (fit != null && fit.length > 1 && fit != old.fitTo) {
      _centered = true;
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => _controller.fitCamera(CameraFit.coordinates(coordinates: fit, padding: const EdgeInsets.all(40))));
    } else if (widget.focus != null && widget.focus != old.focus) {
      _centered = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _controller.move(widget.focus!, 15));
    } else if (!_centered && widget.position != null && _providers != null) {
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
          onLongPress: widget.onLongPress == null ? null : (_, point) => widget.onLongPress!(point),
        ),
        children: [
          for (final (i, (_, provider)) in providers.indexed)
            VectorTileLayer(
              theme: i == 0 ? base : overlay,
              tileProviders: TileProviders({'protomaps': provider}),
              // Modalità vettoriale: disegna anche i nomi di città e vie.
              layerMode: VectorTileLayerMode.vector,
            ),
          if (widget.track.length > 1)
            PolylineLayer(polylines: [
              Polyline(points: widget.track, strokeWidth: 4, color: Colors.lightBlueAccent),
            ]),
          if (pos != null && widget.selected != null)
            PolylineLayer(polylines: [
              Polyline(
                points: [pos, widget.selected!.point],
                strokeWidth: 3,
                color: kDanger,
                pattern: StrokePattern.dashed(segments: const [12, 8]),
              ),
            ]),
          if (widget.pins.isNotEmpty)
            MarkerLayer(markers: [
              for (final pin in widget.pins)
                Marker(
                  point: pin.point,
                  width: 44,
                  height: 44,
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: () => widget.onPinTap?.call(pin),
                    child: Icon(Icons.location_on,
                        size: 44, color: pin == widget.selected ? kDanger : Colors.white,
                        shadows: const [Shadow(blurRadius: 4)]),
                  ),
                ),
            ]),
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
