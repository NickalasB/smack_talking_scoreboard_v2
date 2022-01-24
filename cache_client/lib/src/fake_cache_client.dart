import 'package:cache_client/cache_client.dart';

class FakeCacheClient implements CacheClient {
  final _fakeCache = <String, dynamic>{};

  @override
  T? read<T extends Object>({required String key}) {
    return _fakeCache[key];
  }

  @override
  void write<T extends Object>({required String key, required T value}) {
    _fakeCache.putIfAbsent(key, () => value);
  }
}
