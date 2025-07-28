import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/app/shared_pref/shared_preferences.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_state.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_event.dart';
import 'package:petforpat/app/service_locator/service_locator.dart';

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashAuthenticated extends SplashState {}

class SplashUnauthenticated extends SplashState {}

class SplashCubit extends Cubit<SplashState> {
  final SharedPrefsHelper sharedPrefsHelper;
  late final StreamSubscription authSubscription;
  final AuthBloc authBloc = sl<AuthBloc>();

  bool _emitted = false;

  SplashCubit(this.sharedPrefsHelper) : super(SplashInitial()) {
    // Listen to AuthBloc states and emit splash states accordingly
    authSubscription = authBloc.stream.listen((authState) {
      print('🔄 SplashCubit received authState: $authState');

      if (_emitted) return;

      if (authState is AuthAuthenticated || authState is AuthProfileUpdated) {
        _emitted = true;
        emit(SplashAuthenticated());
      } else if (authState is AuthInitial || authState is AuthError || authState is AuthLoggedOut) {
        _emitted = true;
        emit(SplashUnauthenticated());
      }
    });
  }

  Future<void> checkLoginStatus() async {
    final token = await sharedPrefsHelper.getToken();

    if (token != null && token.isNotEmpty) {
      // Token exists → try to get user
      authBloc.add(FetchProfileEvent());
    } else {
      // No token → direct to login
      emit(SplashUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    authSubscription.cancel();
    return super.close();
  }
}
