// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';
import 'package:petforpat/features/auth/presentation/views/login_view.dart';
import 'package:petforpat/app/theme/theme_data.dart';
import 'package:petforpat/app/service_locator/service_locator.dart';

class PetForPatApp extends StatelessWidget {
  const PetForPatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PetForPat',
        theme: getApplicationTheme(),
        home: const LoginView(),
      ),
    );
  }
}
