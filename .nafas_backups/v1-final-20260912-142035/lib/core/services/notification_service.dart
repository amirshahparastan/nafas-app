import 'notification_service_stub.dart'
    if (dart.library.html) 'notification_service_web.dart' as impl;

abstract final class NafasNotificationService {
  static Future<String> permissionStatus() => impl.permissionStatus();
  static Future<String> requestPermission() => impl.requestPermission();
  static Future<bool> showTestNotification() => impl.showTestNotification();
  static Future<bool> scheduleDailySupportReminder({
    required int hour,
    required int minute,
  }) =>
      impl.scheduleDailySupportReminder(hour: hour, minute: minute);
  static Future<void> cancelDailySupportReminder() =>
      impl.cancelDailySupportReminder();
  static Future<bool> openNotificationSettings() =>
      impl.openNotificationSettings();
  static bool get supported => impl.supported;
  static bool get supportsScheduling => impl.supportsScheduling;
}
