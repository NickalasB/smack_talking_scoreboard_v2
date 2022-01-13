import 'package:equatable/equatable.dart';

class ScoreboardUser extends Equatable {
  const ScoreboardUser({
    required this.id,
    this.email,
    this.name,
  });

  /// The current user's email address.
  final String? email;

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String? name;

  /// Anonymous user which represents an unauthenticated user.
  static const anonymous = ScoreboardUser(id: '');

  /// Convenience getter to determine whether the current user is anonymous.
  bool get isAnonymous => this == ScoreboardUser.anonymous;

  /// Convenience getter to determine whether the current user is not anonymous.
  bool get isNotAnonymous => this != ScoreboardUser.anonymous;

  @override
  List<Object?> get props => [email, id, name];
}
