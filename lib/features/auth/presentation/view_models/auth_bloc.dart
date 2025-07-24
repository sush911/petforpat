import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:petforpat/features/auth/domain/repositories/auth_repository.dart';
import 'package:petforpat/features/auth/domain/usecases/update_profile_usecase.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final UpdateProfileUseCase updateProfileUseCase;

  AuthBloc({
    required this.authRepository,
    required this.updateProfileUseCase,
  }) : super(AuthInitial()) {
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
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(AuthUpdatingProfile());
      try {
        final user = await updateProfileUseCase(event.data, event.image);
        emit(AuthProfileUpdated(user));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<FetchProfileEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.getCurrentUser(); // ✅ Ensure this exists
        emit(AuthProfileUpdated(user));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      // Optional: clear token/session info
      emit(AuthInitial());
    });
  }
}
