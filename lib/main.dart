import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Hive initialization
import 'package:petforpat/app/app.dart';
import 'package:petforpat/app/service_locator/service_locator.dart';
import 'package:petforpat/app/shared_pref/shared_preferences.dart';
import 'package:petforpat/features/auth/data/datasources/remote_datasource/auth_remote_datasource.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_bloc.dart';
import 'package:petforpat/features/splash/presentation/view_models/splash_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive (important if you use Hive anywhere)
  await Hive.initFlutter();

  // Setup DI
  await setupServiceLocator();

  // Load token into Dio headers if saved
  await sl<AuthRemoteDataSource>().loadToken();

  final sharedPrefsHelper = SharedPrefsHelper();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<DashboardBloc>(create: (_) => sl<DashboardBloc>()),
        BlocProvider<SplashCubit>(create: (_) => SplashCubit(sharedPrefsHelper)),
      ],
      child: const PetForPatApp(),
    ),
  );
}


