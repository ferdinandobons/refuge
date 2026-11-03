import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../features/tools/fallout_phases.dart';
import '../l10n/app_localizations.dart';

/// Promemoria che arrivano anche ad app chiusa, programmati sul telefono (nessun server):
/// l'inizio di ogni fase del timer del fallout e il controllo dello zaino ogni 6 mesi.
class Reminders {
  Reminders._();

  static final _plugin = FlutterLocalNotificationsPlugin();
  static Future<bool>? _ready;

  static const _falloutBase = 100;
  static const _bagCheckId = 200;

  /// Giorni dopo i quali ricontrollare lo zaino (cibo, farmaci e batterie scadono).
  static const bagCheckDays = 182;

  static Future<bool> _init() => _ready ??= () async {
        if (kIsWeb) return false;
        try {
          await _plugin.initialize(
            settings: const InitializationSettings(
              android: AndroidInitializationSettings('@mipmap/ic_launcher'),
              iOS: DarwinInitializationSettings(
                requestAlertPermission: false,
                requestBadgePermission: false,
                requestSoundPermission: false,
              ),
            ),
          );
          return true;
        } catch (_) {
          return false;
        }
      }();

  /// Chiede il permesso la prima volta che serve davvero (quando si programma un promemoria).
  static Future<bool> _allowed() async {
    if (!await _init()) return false;
    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    return await ios?.requestPermissions(alert: true, sound: true) ??
        await android?.requestNotificationsPermission() ??
        false;
  }

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails('reminders', 'Refuge', importance: Importance.high, priority: Priority.high),
    iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
  );

  /// Si programma all'istante esatto (in UTC), così il fuso orario del telefono non conta.
  static Future<void> _at(int id, DateTime when, String title, String body) => _plugin.zonedSchedule(
        id: id,
        scheduledDate: tz.TZDateTime.from(when.toUtc(), tz.UTC),
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: title,
        body: body,
      );

  /// Un avviso all'inizio di ogni fase del fallout ancora futura; nessuno se [explosion] è null.
  static Future<void> fallout(DateTime? explosion, AppLocalizations t) async {
    if (!await _init()) return;
    for (var i = 0; i < kPhases.length; i++) {
      await _plugin.cancel(id: _falloutBase + i);
    }
    if (explosion == null || !await _allowed()) return;
    for (final (i, p) in kPhases.indexed) {
      final when = explosion.add(Duration(minutes: (p.fromHours * 60).round()));
      if (p.fromHours == 0 || when.isBefore(DateTime.now())) continue;
      await _at(_falloutBase + i, when, '${t.falloutTitle}: ${p.title(t)}', p.actions(t).first);
    }
  }

  /// Un avviso 6 mesi dopo l'ultimo controllo dello zaino.
  static Future<void> bagCheck(DateTime lastCheck, AppLocalizations t) async {
    if (!await _init()) return;
    await _plugin.cancel(id: _bagCheckId);
    if (!await _allowed()) return;
    final when = lastCheck.add(const Duration(days: bagCheckDays));
    if (when.isAfter(DateTime.now())) await _at(_bagCheckId, when, t.bagCheckTitle, t.bagCheckReminder);
  }
}
