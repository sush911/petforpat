import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart'; //
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginUseCase(event.username, event.password);
        if (user != null) {
          // ✅ Save login time in Hive
          final box = Hive.box('profileInstalled');
          await box.put('loginTime', DateTime.now().toIso8601String());
          print('✅ Saved login time: ${box.get('loginTime')}');

          emit(AuthSuccess(user));
        } else {
          emit(AuthFailure('Invalid username or password'));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await registerUseCase(event.user);
        emit(RegisterSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
