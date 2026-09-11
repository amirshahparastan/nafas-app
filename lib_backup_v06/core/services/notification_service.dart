import 'notification_service_stub.dart'
    if (dart.library.html) 'notification_service_web.dart' as impl;

abstract final class NafasNotificationService {
  static Future<String> permissionStatus() => impl.permissionStatus();
  static Future<String> requestPermission() => impl.requestPermission();
  static Future<bool> showTestNotification() => impl.showTestNotification();
  static bool get supported => impl.supported;
}
