import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:petforpat/app/shared_pref/shared_pref_service.dart';
import 'package:petforpat/features/auth/domain/entities/register_user.dart';
import 'package:petforpat/features/auth/domain/entities/user.dart';
import 'package:petforpat/features/auth/domain/usecases/login_usecase.dart';
import 'package:petforpat/features/auth/domain/usecases/register_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final SharedPrefService _sharedPrefService = SharedPrefService();

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
  }) : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final User? user = await loginUseCase(event.email, event.password); // 👈 email instead of username
      if (user != null) {
        final box = Hive.box('profileInstalled');
        await box.put('loginTime', DateTime.now().toIso8601String());
        print('✅ Saved login time: ${box.get('loginTime')}');

        await _sharedPrefService.saveLoginSession(
          userId: user.id,
          authToken: user.token,
        );

        emit(AuthSuccess(user));
      } else {
        emit(const AuthFailure('Invalid email or password')); // 👈 updated message
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await registerUseCase(event.user);
      emit(const RegisterSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
