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
    // Convert entity to UserModel (with username)
    final userModel = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: user.username,
      username: user.username, // ✅ Fixed: username added
      email: user.email,
      password: user.password,
      token: '', // No token on register
    );

    await remoteDataSource.register(userModel);        // API call
    await localDataSource.saveUser(userModel);         // Optional: cache
  }

  @override
  Future<User?> login(String username, String password) async {
    try {
      final userModel = await remoteDataSource.login(username, password);
      await localDataSource.saveUser(userModel);        // Cache locally
      return userModel.toEntity();                      // Convert to domain
    } catch (e) {
      rethrow;
    }
  }
}
