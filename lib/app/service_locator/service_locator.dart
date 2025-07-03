
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

  // Open Hive box for UserModel
  final userBox = await Hive.openBox<UserModel>('users');
  sl.registerLazySingleton<Box<UserModel>>(() => userBox);

  // Local data source
  sl.registerLazySingleton<UserLocalDataSource>(
        () => UserLocalDataSourceImpl(sl()),
  );

  // Dio client with increased timeouts
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30);
    return dio;
  });

  // API client
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

  // Remote data source
  sl.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  // BLoC
  sl.registerFactory(() => AuthBloc(
    loginUseCase: sl(),
    registerUseCase: sl(),
  ));
}
