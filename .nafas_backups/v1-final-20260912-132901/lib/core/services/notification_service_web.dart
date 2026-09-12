// ignore_for_file: deprecated_member_use
import 'dart:html' as html;

const bool supported = true;
const bool supportsScheduling = false;

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
    body: 'این یک اعلان آزمایشی از نفس است.',
  );
  return true;
}

Future<bool> scheduleDailySupportReminder({
  required int hour,
  required int minute,
}) async =>
    false;

Future<void> cancelDailySupportReminder() async {}
