import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

const bool supported = true;
const bool supportsScheduling = true;

const _dailyReminderId = 1101;
const _testNotificationId = 1100;
const _channelId = 'nafas_support';
const _channelName = 'یادآوری‌های حمایتی نفس';
const _channelDescription = 'یادآوری‌های کوتاه و اختیاری برای ادامه مسیر ترک';
const _settingsChannel = MethodChannel('ir.wearepulse.nafas/settings');

final FlutterLocalNotificationsPlugin _plugin =
    FlutterLocalNotificationsPlugin();
Future<void>? _initialization;

Future<bool> _ensureInitialized() async {
  try {
    _initialization ??= _initializeNotifications();
    await _initialization;
    return true;
  } catch (_) {
    // Allow a later retry instead of leaving notification UI stuck forever.
    _initialization = null;
    return false;
  }
}

Future<void> _initializeNotifications() async {
  tz_data.initializeTimeZones();
  try {
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
  } catch (_) {
    tz.setLocalLocation(tz.UTC);
  }

  const android = AndroidInitializationSettings('ic_notification');
  const settings = InitializationSettings(android: android);
  await _plugin.initialize(settings);

  final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.createNotificationChannel(
    const AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.defaultImportance,
    ),
  );
}

Future<String> permissionStatus() async {
  // Permission checking must NOT depend on notification-plugin initialization.
  // This guarantees the Android permission UI can still work even if a
  // notification resource/channel has a problem.
  try {
    final enabled =
        await _settingsChannel.invokeMethod<bool>('areNotificationsEnabled');
    return enabled == true ? 'granted' : 'denied';
  } catch (_) {
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android == null) return 'unsupported';
      final enabled = await android.areNotificationsEnabled();
      return enabled == true ? 'granted' : 'denied';
    } catch (_) {
      return 'denied';
    }
  }
}

Future<String> requestPermission() async {
  // Primary path: native Android permission request. This is intentionally
  // independent from _plugin.initialize() so the system dialog is always
  // reachable on Android 13+.
  try {
    final granted =
        await _settingsChannel.invokeMethod<bool>('requestNotificationPermission');
    return granted == true ? 'granted' : 'denied';
  } catch (_) {
    // Fallback to flutter_local_notifications in case the native channel is
    // unavailable on an older installation.
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android == null) return 'unsupported';
      final granted = await android.requestNotificationsPermission();
      return granted == true ? 'granted' : 'denied';
    } catch (_) {
      return 'denied';
    }
  }
}

Future<bool> showTestNotification() async {
  if (await permissionStatus() != 'granted') return false;
  if (!await _ensureInitialized()) return false;

  try {
    await _plugin.show(
      _testNotificationId,
      'نفس 🌱',
      'همین که مسیرت رو ادامه می‌دی، خودش یک برده.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: 'ic_notification',
        ),
      ),
    );
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> scheduleDailySupportReminder({
  required int hour,
  required int minute,
}) async {
  if (await permissionStatus() != 'granted') return false;
  if (!await _ensureInitialized()) return false;

  try {
    final now = tz.TZDateTime.now(tz.local);
    var next = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!next.isAfter(now)) next = next.add(const Duration(days: 1));

    await _plugin.zonedSchedule(
      _dailyReminderId,
      'یک نفس برای خودت 🌿',
      'مسیرت رو یادت هست؛ امروز هم فقط همین امروز رو ادامه بده.',
      next,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: 'ic_notification',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    return true;
  } catch (_) {
    return false;
  }
}

Future<void> cancelDailySupportReminder() async {
  if (!await _ensureInitialized()) return;
  try {
    await _plugin.cancel(_dailyReminderId);
  } catch (_) {
    // No-op: disabling reminders should never crash the settings screen.
  }
}

Future<bool> openNotificationSettings() async {
  try {
    return await _settingsChannel.invokeMethod<bool>('openNotificationSettings') ??
        false;
  } catch (_) {
    return false;
  }
}
