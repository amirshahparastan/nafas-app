// ignore_for_file: deprecated_member_use
import 'dart:html' as html;

class NafasStoreAdapter {
  bool get isDurable => true;
  String get platformLabel => 'ذخیره محلی مرورگر';

  Future<String?> read(String key) async => html.window.localStorage[key];

  Future<void> write(String key, String value) async {
    html.window.localStorage[key] = value;
  }

  Future<void> remove(String key) async {
    html.window.localStorage.remove(key);
  }
}
