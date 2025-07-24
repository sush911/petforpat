import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/service_locator/service_locator.dart';
import 'app/app.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();

  final globalBlocs = [
    BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>(),
    ),
  ];

  runApp(
    MultiBlocProvider(
      providers: globalBlocs,
      child: const PetForPatApp(),
    ),
  );
}
