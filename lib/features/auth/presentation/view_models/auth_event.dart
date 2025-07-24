import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterRequested extends AuthEvent {
  final Map<String, dynamic> userData;

  RegisterRequested(this.userData);

  @override
  List<Object?> get props => [userData];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested(this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}
