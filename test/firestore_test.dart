import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FakeFirebaseFirestore should work', () async {
    final instance = FakeFirebaseFirestore();
    await instance.collection('users').add({
      'username': 'Bob',
    });
    final snapshot = await instance.collection('users').get();

    expect(snapshot.docs.length, 1);
    expect(snapshot.docs.first.get('username'), 'Bob');

    print(instance.dump());
  });
}
