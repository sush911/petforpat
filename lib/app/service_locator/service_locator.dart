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

// Notification
import 'package:petforpat/features/notification/data/datasources/remote_datasource/notification_remote_datasource.dart';
import 'package:petforpat/features/notification/data/datasources/remote_datasource/notitifcation_remote_datasource_impl.dart';
import 'package:petforpat/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:petforpat/features/notification/domain/repositories/notification_repository.dart';
import 'package:petforpat/features/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:petforpat/features/notification/domain/usecases/get_notification_usecase.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Dio HTTP client
  sl.registerLazySingleton(() => Dio(
    BaseOptions(
      baseUrl: 'http://192.168.10.69:3001/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  ));

  final dio = sl<Dio>();
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  // ---------------- Auth ----------------
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerFactory(() => AuthBloc(authRepository: sl(), updateProfileUseCase: sl()));

  // ---------------- Pets ----------------
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(PetModelAdapter());
  }
  final petBox = await Hive.openBox<PetModel>('petBox');
  sl.registerLazySingleton(() => PetLocalDatasource(petBox));

  sl.registerLazySingleton<PetRemoteDataSource>(() => PetRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<PetRepository>(() => PetRepositoryImpl(sl(), sl()));

  sl.registerLazySingleton(() => GetPetsUseCase(sl()));
  sl.registerLazySingleton(() => GetPetUseCase(sl()));

  sl.registerFactory(() => PetBloc(getPetsUseCase: sl()));
  sl.registerFactory(() => PetDetailBloc(getPetUseCase: sl())); // ✅ FIXED: Register missing bloc

  // ---------------- Favorite ----------------
  final favoriteBox = await Hive.openBox<PetModel>('favoriteBox');
  sl.registerLazySingleton(() => favoriteBox);

  sl.registerLazySingleton<FavoriteRepository>(() => FavoriteRepositoryImpl(favoriteBox));
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerFactory(() => FavoriteCubit(sl()));

  // ---------------- Adoption ----------------
  sl.registerLazySingleton<AdoptionRemoteDataSource>(() => AdoptionRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AdoptionRepository>(() => AdoptionRepositoryImpl(sl()));
  sl.registerLazySingleton(() => SubmitAdoptionRequestUseCase(sl()));
  sl.registerFactory(() => AdoptionBloc(sl()));

  // ---------------- Notification ----------------
  sl.registerLazySingleton<NotificationRemoteDataSource>(() => NotificationRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl(sl()));

  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteNotificationUseCase(sl()));

  sl.registerFactory(() => NotificationBloc(
    sl<GetNotificationsUseCase>(),
    sl<DeleteNotificationUseCase>(),
  ));
}
