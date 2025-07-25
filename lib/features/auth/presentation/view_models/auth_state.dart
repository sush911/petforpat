// auth_state.dart
import 'package:equatable/equatable.dart';
import 'package:petforpat/features/auth/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUpdatingProfile extends AuthState {}

class AuthProfileUpdated extends AuthState {
  final UserEntity user;

  AuthProfileUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
