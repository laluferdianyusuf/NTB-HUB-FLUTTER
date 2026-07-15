class LocalStorage {
  final Map<String, dynamic> _cache = {};

  Future<void> save(String key, dynamic value) async {
    _cache[key] = value;
  }

  Future<T?> read<T>(String key) async {
    return _cache[key] as T?;
  }

  Future<void> remove(String key) async {
    _cache.remove(key);
  }

  Future<void> clear() async {
    _cache.clear();
  }
}
