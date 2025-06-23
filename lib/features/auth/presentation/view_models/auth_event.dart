part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested(this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}

class RegisterRequested extends AuthEvent {
  final RegisterUser user;  // <-- changed to RegisterUser

  RegisterRequested(this.user);

  @override
  List<Object?> get props => [user];
}
