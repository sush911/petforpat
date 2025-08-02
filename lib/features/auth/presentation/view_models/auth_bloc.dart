import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:petforpat/features/auth/domain/repositories/auth_repository.dart';
import 'package:petforpat/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:petforpat/features/auth/domain/entities/user_entity.dart';

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
        await authRepository.login(event.username, event.password);
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(AuthUpdatingProfile());
      try {
        final user = await updateProfileUseCase(event.data, event.image);
        emit(AuthProfileUpdated(_withFullImageUrl(user)));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<FetchProfileEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.getCurrentUser();
        emit(AuthProfileUpdated(_withFullImageUrl(user)));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      // ✅ Clear auth_token from shared preferences

      // 🧼 Optional: Clear token from Dio headers
      await authRepository.clearToken();

      emit(AuthInitial());
    });
  }

  UserEntity _withFullImageUrl(UserEntity user) {
    if (user.profileImage != null && !user.profileImage!.startsWith('http')) {
      const baseUrl = 'http://192.168.10.69:3001';
      return user.copyWith(profileImage: '$baseUrl${user.profileImage}');
    }
    return user;
  }
}

