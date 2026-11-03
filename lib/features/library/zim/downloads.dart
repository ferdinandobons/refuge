import 'dart:async';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';

import 'kiwix_catalog.dart';
import 'zim_library.dart';

class DownloadState {
  DownloadState(this.task, this.status, this.progress, this.expectedSize);

  final DownloadTask task;
  TaskStatus status;
  double progress;
  int expectedSize;
  double speedMBs = -1;
  Duration remaining = Duration.zero;

  String get title => task.displayName.isEmpty ? task.filename : task.displayName;
}

/// Download dei file ZIM, riprendibili e in background (anche ad app chiusa su iOS/Android).
class ZimDownloads extends ChangeNotifier {
  ZimDownloads._();

  static final instance = ZimDownloads._();

  static const _group = 'zim';
  final _states = <String, DownloadState>{};
  Future<void>? _init;

  List<DownloadState> get active => _states.values.where((s) => !s.status.isFinalState).toList();

  Future<void> init() => _init ??= _start();

  Future<void> _start() async {
    final fd = FileDownloader();
    // Su Android i download lunghi devono girare in primo piano con una notifica.
    await fd.configure(androidConfig: [(Config.runInForeground, Config.always)]);
    fd.configureNotificationForGroup(
      _group,
      running: const TaskNotification('Download in corso', '{displayName}'),
      complete: const TaskNotification('Download completato', '{displayName}'),
      error: const TaskNotification('Download interrotto', '{displayName}'),
      paused: const TaskNotification('Download in pausa', '{displayName}'),
      progressBar: true,
    );
    fd.updates.listen(_onUpdate);
    await fd.start();
    for (final r in await fd.database.allRecords(group: _group)) {
      if (r.task is DownloadTask) {
        _states[r.task.taskId] = DownloadState(r.task as DownloadTask, r.status, r.progress, r.expectedFileSize);
      }
    }
    notifyListeners();
  }

  void _onUpdate(TaskUpdate u) {
    if (u.task.group != _group || u.task is! DownloadTask) return;
    final s = _states.putIfAbsent(u.task.taskId, () => DownloadState(u.task as DownloadTask, TaskStatus.enqueued, 0, -1));
    switch (u) {
      case TaskStatusUpdate(:final status):
        s.status = status;
        if (status == TaskStatus.complete) unawaited(ZimLibrary.instance.refresh());
      case TaskProgressUpdate():
        if (u.progress >= 0) s.progress = u.progress;
        if (u.expectedFileSize > 0) s.expectedSize = u.expectedFileSize;
        s.speedMBs = u.networkSpeed;
        s.remaining = u.timeRemaining;
    }
    notifyListeners();
  }

  bool isDownloading(CatalogEntry e) => active.any((s) => s.task.filename == e.fileName);

  Future<bool> start(CatalogEntry e, {required bool wifiOnly}) async {
    await init();
    await ZimLibrary.directory();
    final task = DownloadTask(
      url: e.downloadUrl.toString(),
      filename: e.fileName,
      directory: 'zim',
      baseDirectory: BaseDirectory.applicationDocuments,
      group: _group,
      // La lingua nel nome: si vede nella barra dei download e nelle notifiche.
      displayName: '${e.title} · ${languageName(e.language)}${e.flavour.isEmpty ? '' : ' (${e.flavour})'}',
      updates: Updates.statusAndProgress,
      requiresWiFi: wifiOnly,
      allowPause: true,
      retries: 10,
    );
    _states[task.taskId] = DownloadState(task, TaskStatus.enqueued, 0, e.size);
    notifyListeners();
    return FileDownloader().enqueue(task);
  }

  Future<void> pause(DownloadState s) => FileDownloader().pause(s.task);

  Future<void> resume(DownloadState s) => FileDownloader().resume(s.task);

  Future<void> cancel(DownloadState s) async {
    await FileDownloader().cancelTaskWithId(s.task.taskId);
    _states.remove(s.task.taskId);
    notifyListeners();
  }
}
