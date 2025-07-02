// lib/app/service_locator/service_locator.dart

import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';

import 'package:petforpat/core/network/api_client.dart';
import 'package:petforpat/features/auth/data/models/user_model.dart';
import 'package:petforpat/features/auth/data/datasources/local_datasource/userlocal_datasource.dart';
import 'package:petforpat/features/auth/data/datasources/remote_datasource/userremote_datasource.dart';
import 'package:petforpat/features/auth/data/repositories/user_repository_impl.dart';
import 'package:petforpat/features/auth/domain/repositories/user_repository.dart';
import 'package:petforpat/features/auth/domain/usecases/login_usecase.dart';
import 'package:petforpat/features/auth/domain/usecases/register_usecase.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 🧠 Register Hive adapter for user model
  Hive.registerAdapter(UserModelAdapter());

  // 📦 Open Hive box for storing user data locally
  final userBox = await Hive.openBox<UserModel>('users');
  sl.registerLazySingleton<Box<UserModel>>(() => userBox);

  // 💾 Local data source (Hive)
  sl.registerLazySingleton<UserLocalDataSource>(
        () => UserLocalDataSourceImpl(sl()),
  );

  // 🌐 Dio client for making HTTP requests
  sl.registerLazySingleton<Dio>(() => Dio());

  // 🌍 API client wrapper over Dio
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

  // 🔌 Remote data source (API calls for login/register)
  sl.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSourceImpl(sl()),
  );

  // 📚 Repository combining remote and local sources
  sl.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // ✅ Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  // 🧠 BLoC for Auth
  sl.registerFactory(() => AuthBloc(
    loginUseCase: sl(),
    registerUseCase: sl(),
  ));
}
