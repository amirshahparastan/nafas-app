class NafasStoreAdapter {
  static final Map<String, String> _memory = <String, String>{};

  bool get isDurable => false;
  String get platformLabel => 'حافظه موقت پیش‌نمایش';

  Future<String?> read(String key) async => _memory[key];

  Future<void> write(String key, String value) async {
    _memory[key] = value;
  }

  Future<void> remove(String key) async {
    _memory.remove(key);
  }
}
