import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
import 'package:petforpat/features/dashboard/presentation/view_models/pet_bloc.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_event.dart';

// Import your PetModel and generated adapter
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive Flutter
  await Hive.initFlutter();
  Hive.registerAdapter(PetModelAdapter());

  // Setup DI container
  await setupServiceLocator();

  // Load token into Dio headers
  await sl<AuthRemoteDataSource>().loadToken();

  // Init shared prefs
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
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignupView(),
        '/dashboard home': (context) => BlocProvider(
          create: (_) => sl<PetBloc>()..add(LoadPetsEvent()),
          child: const DashboardView(),
        ),
        '/profile': (context) => const ProfileView(),
      },
      onUnknownRoute: (_) => MaterialPageRoute(
        builder: (_) => const SplashScreen(),
      ),
    );
  }
}
