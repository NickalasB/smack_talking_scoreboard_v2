import 'package:authentication_private/authentication_private.dart';
import 'package:authentication_public/authentication_public.dart';

class FakeAuthentication extends AuthenticationRepository {
  static ScoreboardUser fakeCurrentUser = ScoreboardUser.empty;

  @override
  ScoreboardUser get currentUser => fakeCurrentUser;

  @override
  Future<void> logInWithEmailAndPassword({required String email, required String password}) async {}

  @override
  Future<void> logInWithGoogle() async {}

  @override
  Future<void> logOut() async {}

  @override
  Future<void> signUp({required String email, required String password}) async {}

  @override
  Stream<ScoreboardUser> get user {
    return Stream.fromIterable([fakeCurrentUser]);
  }
}
