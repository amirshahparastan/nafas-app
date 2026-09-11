import 'local_store_stub.dart'
    if (dart.library.html) 'local_store_web.dart' as impl;

class NafasLocalStore {
  NafasLocalStore._();

  static final instance = NafasLocalStore._();
  final impl.NafasStoreAdapter _adapter = impl.NafasStoreAdapter();

  bool get isDurable => _adapter.isDurable;
  String get platformLabel => _adapter.platformLabel;

  Future<String?> read(String key) => _adapter.read(key);
  Future<void> write(String key, String value) => _adapter.write(key, value);
  Future<void> remove(String key) => _adapter.remove(key);
}
