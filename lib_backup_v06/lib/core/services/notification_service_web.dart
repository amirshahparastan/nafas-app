// ignore_for_file: deprecated_member_use
import 'dart:html' as html;

const bool supported = true;

Future<String> permissionStatus() async =>
    html.Notification.permission ?? 'default';

Future<String> requestPermission() async {
  try {
    return await html.Notification.requestPermission() ?? 'default';
  } catch (_) {
    return 'denied';
  }
}

Future<bool> showTestNotification() async {
  if (html.Notification.permission != 'granted') return false;
  html.Notification(
    'نفس 🌱',
    body: 'اعلان‌ها آماده‌اند؛ بدون شلوغی و فقط وقتی واقعاً به دردت می‌خورند.',
  );
  return true;
}
