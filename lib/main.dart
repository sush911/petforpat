import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:petforpat/app/app.dart';
import 'package:petforpat/app/service_locator/service_locator.dart';
import 'package:petforpat/app/shared_pref/shared_preferences.dart';
import 'package:petforpat/features/auth/data/datasources/remote_datasource/auth_remote_datasource.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_event.dart';
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_bloc.dart';
import 'package:petforpat/features/splash/presentation/view_models/splash_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(PetModelAdapter());

  // Set up service locator
  await setupServiceLocator();

  // Load token if exists
  await sl<AuthRemoteDataSource>().loadToken();

  final sharedPrefsHelper = SharedPrefsHelper();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) {
            final bloc = sl<AuthBloc>();
            bloc.add(FetchProfileEvent());
            return bloc;
          },
        ),
        BlocProvider<DashboardBloc>(create: (_) => sl<DashboardBloc>()),
        BlocProvider<SplashCubit>(
          create: (_) => SplashCubit(sharedPrefsHelper),
        ),
      ],
      child: const PetForPatApp(),
    ),
  );
}
