import 'dart:html' as html;

const bool supported = true;

Future<String> permissionStatus() async {
  return html.Notification.permission ?? 'default';
}

Future<String> requestPermission() async {
  try {
    final result = await html.Notification.requestPermission();
    return result ?? 'default';
  } catch (_) {
    return 'denied';
  }
}

Future<bool> showTestNotification() async {
  if ((html.Notification.permission ?? 'default') != 'granted') {
    return false;
  }

  html.Notification(
    'نفس 🌱',
    body: 'اعلان‌ها آماده‌اند؛ فقط وقتی واقعاً به کارت بیان.',
  );

  return true;
}
