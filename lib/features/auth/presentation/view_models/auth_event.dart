import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class RegisterRequested extends AuthEvent {
  final Map<String, dynamic> userData;

  RegisterRequested({required this.userData});

  @override
  List<Object?> get props => [userData];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class UpdateProfileEvent extends AuthEvent {
  final Map<String, dynamic> data;
  final File? image;

  UpdateProfileEvent({required this.data, this.image});

  @override
  List<Object?> get props => [data, image];
}

class LogoutEvent extends AuthEvent {}

class FetchProfileEvent extends AuthEvent {}
