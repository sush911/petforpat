import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/app/service_locator/service_locator.dart';
import 'package:petforpat/app/shared_pref/shared_preferences.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';
import 'package:petforpat/features/auth/data/datasources/remote_datasource/auth_remote_datasource.dart';
import 'package:petforpat/features/auth/presentation/views/login_view.dart';
import 'package:petforpat/features/auth/presentation/views/signup_view.dart';
import 'package:petforpat/features/auth/presentation/views/profile_view.dart';
import 'package:petforpat/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:petforpat/features/splash/presentation/view_models/splash_cubit.dart';
import 'package:petforpat/features/splash/presentation/views/splash_view.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup DI
  await setupServiceLocator();

  // Load token into Dio headers if saved
  await sl<AuthRemoteDataSource>().loadToken();

  // Init shared prefs helper
  final sharedPrefsHelper = SharedPrefsHelper();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
        ),
        BlocProvider<SplashCubit>(
          create: (_) => SplashCubit(sharedPrefsHelper),
        ),
      ],
      child: const PetForPatApp(),
    ),
  );
}

class PetForPatApp extends StatelessWidget {
  const PetForPatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetForPat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // ✅ Always show splash screen first
      initialRoute: '/splash',

      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignupView(),
        '/dashboard home': (context) => const DashboardView(),
        '/profile': (context) => const ProfileView(),
      },

      // Optional fallback route
      onUnknownRoute: (_) => MaterialPageRoute(
        builder: (_) => const SplashScreen(),
      ),
    );
  }
}
