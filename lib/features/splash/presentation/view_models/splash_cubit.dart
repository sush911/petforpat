import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/app/shared_pref/shared_preferences.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SharedPrefsHelper prefsHelper;

  SplashCubit(this.prefsHelper) : super(SplashInitial());

  Future<void> checkLoginStatus() async {
    final token = await prefsHelper.getToken();
    if (token != null && token.isNotEmpty) {
      emit(SplashAuthenticated());
    } else {
      emit(SplashUnauthenticated());
    }
  }
}
