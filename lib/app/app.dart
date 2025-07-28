import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_state.dart';
import 'package:petforpat/features/auth/presentation/views/login_view.dart';
import 'package:petforpat/features/auth/presentation/views/signup_view.dart';
import 'package:petforpat/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:petforpat/features/splash/presentation/views/splash_view.dart';

class PetForPatApp extends StatelessWidget {
  const PetForPatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet For Pat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return _buildHome(state);
        },
      ),
      // Optional: in case you still need named routes for manual navigation
      routes: {
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignupView(),
      },
    );
  }

  Widget _buildHome(AuthState state) {
    if (state is AuthLoading || state is AuthInitial) {
      return const SplashScreen();
    } else if (state is AuthAuthenticated) {
      return DashboardView(user: state.user);
    } else if (state is AuthLoggedOut) {
      return const LoginView();
    } else if (state is AuthError) {
      return const LoginView(); // or ErrorView(message: state.message)
    } else {
      return const SplashScreen(); // fallback safety
    }
  }
}
