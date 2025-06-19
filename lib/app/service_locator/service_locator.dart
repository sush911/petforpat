// lib/app/service_locator/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:petforpat/features/auth/data/models/user_model.dart';
import 'package:petforpat/features/auth/data/datasources/local_datasource/userlocal_datasource.dart';
import 'package:petforpat/features/auth/data/repositories/user_repository_impl.dart';
import 'package:petforpat/features/auth/domain/repositories/user_repository.dart';
import 'package:petforpat/features/auth/domain/usecases/login_usecase.dart';
import 'package:petforpat/features/auth/domain/usecases/register_usecase.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  Hive.registerAdapter(UserModelAdapter());

  final userBox = await Hive.openBox<UserModel>('users');
  sl.registerLazySingleton<Box<UserModel>>(() => userBox);

  // Register UserLocalDataSource with the registered box
  sl.registerLazySingleton<UserLocalDataSource>(
        () => UserLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<UserRepository>(
          () => UserRepositoryImpl(sl()));

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  sl.registerFactory(() => AuthBloc(
    loginUseCase: sl(),
    registerUseCase: sl(),
  ));
}
