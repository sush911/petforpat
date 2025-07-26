import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:petforpat/features/auth/data/datasources/remote_datasource/auth_remote_datasource.dart';
import 'package:petforpat/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:petforpat/features/auth/domain/repositories/auth_repository.dart';
import 'package:petforpat/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';
import 'package:petforpat/features/dashboard/data/datasources/local_datasource/pet_local_datasource.dart';
import 'package:petforpat/features/dashboard/data/datasources/remote_datasource/pet_remote_datasource.dart';
import 'package:petforpat/features/dashboard/data/repositories/pet_repository_impl.dart';
import 'package:petforpat/features/dashboard/domain/repositories/pet_repository.dart';
import 'package:petforpat/features/dashboard/domain/usecases/adopt_pet_usecase.dart';
import 'package:petforpat/features/dashboard/domain/usecases/get_pets_usecase.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ✅ Dio with BaseOptions
  sl.registerLazySingleton(() => Dio(
    BaseOptions(
      baseUrl: 'http://192.168.10.70:3001/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  ));

  // ✅ Optional: HTTP logging
  final dio = sl<Dio>();
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));

  // ✅ Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerFactory(() => AuthBloc(
    authRepository: sl(),
    updateProfileUseCase: sl(),
  ));

  // ✅ Pet Local + Remote + Repository
  sl.registerLazySingleton<PetLocalDataSource>(() => PetLocalDataSourceImpl());
  sl.registerLazySingleton<PetRemoteDataSource>(() => PetRemoteDataSourceImpl(sl(), sl()));
  sl.registerLazySingleton<PetRepository>(() => PetRepositoryImpl(
    sl<PetRemoteDataSource>(),
    sl<PetLocalDataSource>(),
  ));

  // ✅ UseCases
  sl.registerLazySingleton(() => GetPetsUseCase(sl()));
  sl.registerLazySingleton(() => AdoptPetUseCase(sl()));

  // ✅ Dashboard Bloc
  sl.registerFactory(() => DashboardBloc(
    getPets: sl(),
    adoptPet: sl(),
  ));
}
