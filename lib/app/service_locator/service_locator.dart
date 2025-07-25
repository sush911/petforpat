import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:petforpat/features/auth/data/datasources/remote_datasource/auth_remote_datasource.dart';
import 'package:petforpat/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:petforpat/features/auth/domain/repositories/auth_repository.dart';
import 'package:petforpat/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ✅ Dio with proper BaseOptions setup
  sl.registerLazySingleton(() => Dio(
    BaseOptions(
      baseUrl: 'http://192.168.10.70:3001/api', // ✅ includes /api
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  ));

  // ✅ Optional: Logging interceptor for debugging HTTP traffic
  final dio = sl<Dio>();
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));

  // ✅ Register AuthRemoteDataSourceImpl
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));

  // ✅ Register AuthRepositoryImpl
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // ✅ Register UseCase
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  // ✅ Register Bloc
  sl.registerFactory(() => AuthBloc(
    authRepository: sl(),
    updateProfileUseCase: sl(),
  ));
}
