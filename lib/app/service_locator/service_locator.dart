import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:petforpat/features/auth/data/datasources/remote_datasource/auth_remote_datasource.dart';
import 'package:petforpat/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:petforpat/features/auth/domain/repositories/auth_repository.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Dio with your server's base URL
  sl.registerLazySingleton(() => Dio(
    BaseOptions(baseUrl: 'http://192.168.10.70:3001/api/users'),
  ));

  // Register the concrete data source directly
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Bloc
  sl.registerFactory(() => AuthBloc(sl()));
}
