import 'package:authentication_private/authentication_private.dart';

abstract class Authentication {
  ScoreboardUser? get currentUser => throw UnimplementedError();

  Future<void> logInWithEmailAndPassword({required String email, required String password});

  Future<void> logInWithGoogle();

  Future<void> logOut();

  Future<void> signUp({required String email, required String password});

  Stream<ScoreboardUser> get user;
}
