// theme_cubit.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit()
      : super(
    ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.teal,
    ),
  );

  void toggleTheme() {
    emit(state.brightness == Brightness.dark
        ? ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.teal,
    )
        : ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.teal,
    ));
  }
}
