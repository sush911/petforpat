import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

// Auth
import 'package:petforpat/features/auth/data/datasources/remote_datasource/auth_remote_datasource.dart';
import 'package:petforpat/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:petforpat/features/auth/domain/repositories/auth_repository.dart';
import 'package:petforpat/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';

// Pets
import 'package:petforpat/features/dashboard/data/datasources/remote_datasource/pet_remote_datasource.dart';
import 'package:petforpat/features/dashboard/data/datasources/local_datasource/pet_local_datasource.dart';
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';
import 'package:petforpat/features/dashboard/data/repositories/pet_repository_impl.dart';
import 'package:petforpat/features/dashboard/domain/repositories/pet_repository.dart';
import 'package:petforpat/features/dashboard/domain/usecases/get_pet_usecase.dart';
import 'package:petforpat/features/dashboard/domain/usecases/get_pets_usecase.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_bloc.dart';

// Favorite
import 'package:petforpat/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:petforpat/features/favorite/data/repositories/favorite_repository_impl.dart';
import 'package:petforpat/features/favorite/domain/usecases/get_favorites_usecase.dart';
import 'package:petforpat/features/favorite/presentation/view_models/favorite_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 🟢 Dio with base URL and headers
  sl.registerLazySingleton(() => Dio(BaseOptions(
    baseUrl: 'http://192.168.10.70:3001/api', // Must include /api
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  )));

  final dio = sl<Dio>();
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true)); // Debugging interceptor

  // 🟢 Auth feature registrations
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerFactory(() => AuthBloc(authRepository: sl(), updateProfileUseCase: sl()));

  // 🟢 Hive setup: register PetModel adapter once
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(PetModelAdapter());
  }

  // 🟢 Open petBox Hive box and register local datasource
  final petBox = await Hive.openBox<PetModel>('petBox');
  sl.registerLazySingleton(() => PetLocalDatasource(petBox));

  // 🟢 Pet feature registrations
  sl.registerLazySingleton<PetRemoteDataSource>(() => PetRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<PetRepository>(() => PetRepositoryImpl(
    sl(), // remote datasource
    sl(), // local datasource
  ));

  sl.registerLazySingleton(() => GetPetsUseCase(sl()));
  sl.registerLazySingleton(() => GetPetUseCase(sl()));

  sl.registerFactory(() => PetBloc(getPetsUseCase: sl()));
  sl.registerFactory(() => PetDetailBloc(getPetUseCase: sl()));

  // 🟢 Favorite feature Hive box for storing favorites
  final favoriteBox = await Hive.openBox<PetModel>('favoriteBox');
  sl.registerLazySingleton(() => favoriteBox);

  // 🟢 Favorite feature registrations
  sl.registerLazySingleton<FavoriteRepository>(() => FavoriteRepositoryImpl(favoriteBox));
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerFactory(() => FavoriteCubit(sl()));
}
