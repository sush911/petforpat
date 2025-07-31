import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:petforpat/app/service_locator/service_locator.dart';
import 'package:petforpat/app/shared_pref/shared_preferences.dart';

// Auth
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';
import 'package:petforpat/features/auth/data/datasources/remote_datasource/auth_remote_datasource.dart';
import 'package:petforpat/features/auth/presentation/views/login_view.dart';
import 'package:petforpat/features/auth/presentation/views/signup_view.dart';
import 'package:petforpat/features/auth/presentation/views/profile_view.dart';
import 'package:petforpat/features/notification/domain/usecases/get_notification_usecase.dart';

// Splash
import 'package:petforpat/features/splash/presentation/view_models/splash_cubit.dart';
import 'package:petforpat/features/splash/presentation/views/splash_view.dart';

// Dashboard
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_bloc.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_event.dart';
import 'package:petforpat/features/dashboard/presentation/views/dashboard_view.dart';

// Favorite
import 'package:petforpat/features/favorite/presentation/view_models/favorite_cubit.dart';

// Adoption
import 'package:petforpat/features/adoption/presentation/view_models/adoption_bloc.dart';
import 'package:petforpat/features/adoption/presentation/views/adoption_screen.dart';

// Notification
import 'package:petforpat/features/notification/presentation/view_models/notification_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(PetModelAdapter());

  // Open boxes
  await Hive.openBox<PetModel>('petBox');
  await Hive.openBox<PetModel>('favoriteBox');

  // Setup DI
  await setupServiceLocator();

  // Load token to Dio
  await sl<AuthRemoteDataSource>().loadToken();

  // Shared preferences helper
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
        BlocProvider<FavoriteCubit>(
          create: (_) => sl<FavoriteCubit>()..loadFavorites(),
        ),
        BlocProvider<PetBloc>(
          create: (_) => sl<PetBloc>()..add(LoadPetsEvent()),
        ),
        BlocProvider<AdoptionBloc>(
          create: (_) => sl<AdoptionBloc>(),
        ),

        // NotificationBloc provider with positional GetNotificationsUseCase
        BlocProvider<NotificationBloc>(
          create: (_) => NotificationBloc(sl<GetNotificationsUseCase>()),
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
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignupView(),
        '/dashboard home': (context) => const DashboardView(),
        '/profile': (context) => const ProfileView(),
        '/adoption': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AdoptionScreen(
            petId: args['petId'],
            petName: args['petName'],
            petType: args['petType'],
          );
        },
      },
      onUnknownRoute: (_) => MaterialPageRoute(
        builder: (_) => const SplashScreen(),
      ),
    );
  }
}
