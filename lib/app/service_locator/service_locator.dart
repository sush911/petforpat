final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Hive
  sl.registerLazySingleton(() => Hive.box('authBox'));

  // SharedPrefs
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // Data Layer
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));

  // BLoC
  sl.registerFactory(() => AuthBloc(
    loginUseCase: sl(),
    signupUseCase: sl(),
  ));
}
