import 'package:shared_preferences/shared_preferences.dart';

class NafasStoreAdapter {
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  bool get isDurable => true;
  String get platformLabel => 'فضای محلی خصوصی برنامه';

  Future<String?> read(String key) => _preferences.getString(key);

  Future<void> write(String key, String value) =>
      _preferences.setString(key, value);

  Future<void> remove(String key) => _preferences.remove(key);
}
