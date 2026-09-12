import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

const bool supported = true;
const bool supportsScheduling = true;

const _dailyReminderId = 1101;
const _channelId = 'nafas_support';
const _channelName = 'یادآوری‌های حمایتی نفس';
const _channelDescription = 'یادآوری‌های کوتاه و اختیاری برای ادامه مسیر ترک';

final FlutterLocalNotificationsPlugin _plugin =
    FlutterLocalNotificationsPlugin();
Future<void>? _initialization;

Future<void> _ensureInitialized() =>
    _initialization ??= _initializeNotifications();

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
}

Future<String> permissionStatus() async {
  await _ensureInitialized();
  final android = _plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  if (android == null) return 'unsupported';
  final enabled = await android.areNotificationsEnabled();
  return enabled == true ? 'granted' : 'denied';
}

Future<String> requestPermission() async {
  await _ensureInitialized();
  final android = _plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  if (android == null) return 'unsupported';
  final granted = await android.requestNotificationsPermission();
  return granted == true ? 'granted' : 'denied';
}

Future<bool> showTestNotification() async {
  await _ensureInitialized();
  if (await permissionStatus() != 'granted') return false;
  await _plugin.show(
    1100,
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
}

Future<bool> scheduleDailySupportReminder({
  required int hour,
  required int minute,
}) async {
  await _ensureInitialized();
  if (await permissionStatus() != 'granted') return false;

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
}

Future<void> cancelDailySupportReminder() async {
  await _ensureInitialized();
  await _plugin.cancel(_dailyReminderId);
}


Future<bool> openNotificationSettings() async {
  try {
    const channel = MethodChannel('ir.wearepulse.nafas/settings');
    return await channel.invokeMethod<bool>('openNotificationSettings') ?? false;
  } catch (_) {
    return false;
  }
}
