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
    // Convert entity to model for API
    final userModel = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: user.username,
      email: user.email,
      password: user.password,
      token: '', // This will likely be empty on registration
    );

    await remoteDataSource.register(userModel);
    await localDataSource.saveUser(userModel); // Optional caching
  }

  @override
  Future<User?> login(String username, String password) async {
    try {
      // Get user from API
      final userModel = await remoteDataSource.login(username, password);

      // Save to Hive (local cache)
      await localDataSource.saveUser(userModel);

      // Return domain entity
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
