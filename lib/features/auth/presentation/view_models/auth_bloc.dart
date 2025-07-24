import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:petforpat/features/auth/domain/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.register(event.userData);
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final token = await authRepository.login(event.username, event.password);
        // Store token somewhere or proceed
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });
  }
}
