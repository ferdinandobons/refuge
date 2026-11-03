import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';

import '../features/library/library_screen.dart';
import '../features/library/zim/downloads.dart';
import '../features/maps/map_download.dart';
import '../features/maps/map_regions.dart';
import '../l10n/app_localizations.dart';
import 'theme.dart';

/// Barra in cima a tutte le schede mentre si scaricano mappe o enciclopedie: nomi e avanzamento totale.
class DownloadsBanner extends StatelessWidget {
  const DownloadsBanner({super.key});

  static bool get active => _maps.isNotEmpty || _zims.isNotEmpty;

  static Iterable<MapJob> get _maps => MapRegions.instance.jobs.values.where((j) =>
      j.state == MapJobState.queued || j.state == MapJobState.planning || j.state == MapJobState.downloading);

  static Iterable<DownloadState> get _zims => ZimDownloads.instance.active;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final maps = _maps.toList(), zims = _zims.toList();
    final names = [for (final j in maps) regionName(t, j.region), for (final z in zims) z.title];
    // Avanzamento pesato sui byte di tutti i download.
    var done = 0.0, total = 0.0;
    for (final j in maps) {
      done += j.done;
      total += j.total;
    }
    for (final z in zims) {
      if (z.expectedSize > 0) {
        done += z.progress.clamp(0, 1) * z.expectedSize;
        total += z.expectedSize;
      }
    }
    final progress = total > 0 ? done / total : null;
    final paused = zims.isNotEmpty && maps.isEmpty && zims.every((z) => z.status == TaskStatus.paused);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Material(
        color: Colors.lightBlueAccent.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Colors.lightBlueAccent, width: 1.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => maps.isNotEmpty ? const MapDownloadScreen() : const LibraryScreen()),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            child: Row(children: [
              Icon(paused ? Icons.pause_circle : Icons.downloading, color: Colors.lightBlueAccent, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(
                      child: Text(t.downloadsActive(names.length),
                          style: const TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold)),
                    ),
                    if (progress != null)
                      Text('${(progress * 100).toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ]),
                  Text(names.join(' · '), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(value: progress, color: Colors.lightBlueAccent, backgroundColor: kSurface),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
