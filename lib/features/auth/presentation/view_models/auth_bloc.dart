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
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.getCurrentUser();
        final fullUser = _withFullImageUrl(user);
        emit(AuthAuthenticated(user: fullUser));
        print('🚀 App started, user loaded: ${user.username}');
      } catch (e) {
        emit(AuthInitial());
        print('🚀 App started, no user found');
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.register(event.userData);
        final user = await authRepository.getCurrentUser();
        emit(AuthAuthenticated(user: _withFullImageUrl(user)));
        print('✅ Registered: ${user.username}');
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.login(event.username, event.password);
        final user = await authRepository.getCurrentUser();
        final fullUser = _withFullImageUrl(user);
        emit(AuthAuthenticated(user: fullUser));
        print('✅ Logged in as: ${user.username}, ID: ${user.id}');
      } catch (e) {
        print('❌ Login error: $e');
        emit(AuthError(message: e.toString()));
      }
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(AuthUpdatingProfile());
      try {
        final user = await updateProfileUseCase(event.data, event.image);
        final fullUser = _withFullImageUrl(user);
        emit(AuthAuthenticated(user: fullUser));
        print('📝 Profile updated: ${user.username}, ID: ${user.id}');
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<FetchProfileEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.getCurrentUser();
        final fullUser = _withFullImageUrl(user);
        emit(AuthAuthenticated(user: fullUser));
        print('📥 Fetched profile: ${user.username}, ID: ${user.id}');
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      try {
        await authRepository.clearToken();
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
        emit(AuthInitial());
        print('🔓 Logged out and cleared token');
      } catch (e) {
        emit(AuthError(message: 'Logout failed: ${e.toString()}'));
      }
    });
  }

  UserEntity _withFullImageUrl(UserEntity user) {
    if (user.profileImage != null && !user.profileImage!.startsWith('http')) {
      const baseUrl = 'http://192.168.10.70:3001';
      return user.copyWith(profileImage: '$baseUrl${user.profileImage}');
    }
    return user;
  }
}
