import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

class FakeFirebase extends FirebasePlatform {
  FakeFirebase();
  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return FirebaseAppPlatform(
      'test',
      const FirebaseOptions(
        appId: 'test',
        projectId: '1234',
        apiKey: '321',
        messagingSenderId: 'anything',
      ),
    );
  }
}
