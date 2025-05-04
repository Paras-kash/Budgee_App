import 'package:equatable/equatable.dart';

/// User entity class for the auth domain layer
class UserEntity extends Equatable {
  final String id;
  final String? displayName;
  final String email;
  final String? photoUrl;
  final bool isEmailVerified;

  const UserEntity({
    required this.id,
    this.displayName,
    required this.email,
    this.photoUrl,
    required this.isEmailVerified,
  });

  // Empty user
  factory UserEntity.empty() =>
      const UserEntity(id: '', email: '', isEmailVerified: false);

  // Create a copy of the user entity with modified properties
  UserEntity copyWith({
    String? id,
    String? displayName,
    String? email,
    String? photoUrl,
    bool? isEmailVerified,
  }) {
    return UserEntity(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  @override
  List<Object?> get props => [
    id,
    displayName,
    email,
    photoUrl,
    isEmailVerified,
  ];
}
