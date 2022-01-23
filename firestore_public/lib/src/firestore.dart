import '../firestore_public.dart';

abstract class Firestore {
  Future<void> createUserGame(int pin);

  Future<void> updateP1Score(int score);

  Future<void> updateP2Score(int score);

  Future<void> updateP1Name(String name);

  Future<void> updateP2Name(String name);

  Future<Game?> fetchGame(int pin);
}
