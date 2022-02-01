import '../scoreboard_public.dart';

abstract class ClientFirestoreRepository {
  Future<void> createUserGame(int pin);

  Future<void> deleteUserGame(int pin);

  Future<void> updateScore({required int playerPosition, required int score});

  Future<void> updateName({required int playerPosition, required String name});

  Future<Game> fetchGame(int pin);
}
