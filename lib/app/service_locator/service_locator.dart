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

// Adoption
import 'package:petforpat/features/adoption/data/datasources/remote_datasource/adoption_remote_datasource.dart';
import 'package:petforpat/features/adoption/data/repositories/adoption_repository_impl.dart';
import 'package:petforpat/features/adoption/domain/repositories/adoption_repository.dart';
import 'package:petforpat/features/adoption/domain/usecases/submit_adoption_request.dart';
import 'package:petforpat/features/adoption/presentation/view_models/adoption_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Dio with base URL, timeouts, and JSON headers
  sl.registerLazySingleton(() => Dio(
    BaseOptions(
      baseUrl: 'http://192.168.10.70:3001/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  ));
  final dio = sl<Dio>();
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  // Auth feature registrations
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerFactory(() => AuthBloc(authRepository: sl(), updateProfileUseCase: sl()));

  // Hive: Register PetModel adapter only once
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(PetModelAdapter());
  }

  // Pet local datasource with Hive box
  final petBox = await Hive.openBox<PetModel>('petBox');
  sl.registerLazySingleton(() => PetLocalDatasource(petBox));

  // Pet feature registrations
  sl.registerLazySingleton<PetRemoteDataSource>(() => PetRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<PetRepository>(() => PetRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => GetPetsUseCase(sl()));
  sl.registerLazySingleton(() => GetPetUseCase(sl()));
  sl.registerFactory(() => PetBloc(getPetsUseCase: sl()));
  sl.registerFactory(() => PetDetailBloc(getPetUseCase: sl()));

  // Favorite feature with Hive box
  final favoriteBox = await Hive.openBox<PetModel>('favoriteBox');
  sl.registerLazySingleton(() => favoriteBox);
  sl.registerLazySingleton<FavoriteRepository>(() => FavoriteRepositoryImpl(favoriteBox));
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerFactory(() => FavoriteCubit(sl()));

  // Adoption feature registrations
  sl.registerLazySingleton<AdoptionRemoteDataSource>(() => AdoptionRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AdoptionRepository>(() => AdoptionRepositoryImpl(sl()));
  sl.registerLazySingleton(() => SubmitAdoptionRequestUseCase(sl()));
  // Fix here: pass use case as positional argument, NOT named
  sl.registerFactory(() => AdoptionBloc(sl()));
}
