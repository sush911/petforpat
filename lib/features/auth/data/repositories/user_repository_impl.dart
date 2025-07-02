// features/auth/data/repositories/user_repository_impl.dart

import 'package:petforpat/features/auth/data/datasources/local_datasource/userlocal_datasource.dart';
import 'package:petforpat/features/auth/data/datasources/remote_datasource/userremote_datasource.dart';
import 'package:petforpat/features/auth/domain/entities/register_user.dart';
import 'package:petforpat/features/auth/domain/entities/user.dart';
import 'package:petforpat/features/auth/domain/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> register(RegisterUser user) async {
    await remoteDataSource.register(user);
  }

  @override
  Future<User?> login(String username, String password) async {
    try {
      final user = await remoteDataSource.login(username, password);
      final userModel = UserModel.fromEntity(user);
      await localDataSource.saveUser(userModel); // Cache for local use
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
