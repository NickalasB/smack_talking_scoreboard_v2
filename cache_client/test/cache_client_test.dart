import 'package:cache_client/src/cache_client.dart';
import 'package:cache_client/src/fake_cache_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CacheClient', () {
    test('can write and read a value for a given key', () {
      final cache = CacheClient();
      const key = '__key__';
      const value = '__value__';
      expect(cache.read(key: key), isNull);
      cache.write(key: key, value: value);
      expect(cache.read(key: key), equals(value));
    });
  });

  group('FakeCacheClient', () {
    test('FakeCache can write and read a value for a given key', () {
      final fakeCache = FakeCacheClient();
      const key = 'key';

      fakeCache.write<String>(key: key, value: 'fakeEntry');

      expect(fakeCache.read(key: key), equals('fakeEntry'));
    });
  });
}
