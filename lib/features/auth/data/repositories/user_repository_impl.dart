

import 'package:petforpat/features/auth/data/datasources/local_datasource/userlocal_datasource.dart';
import 'package:petforpat/features/auth/data/models/user_model.dart';
import 'package:petforpat/features/auth/domain/entities/user.dart';
import 'package:petforpat/features/auth/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<void> register(User user) async {
    final existingUser = localDataSource.getUser(user.username);
    if (existingUser != null) {
      throw Exception('User already exists');
    }
    await localDataSource.saveUser(UserModel.fromEntity(user));
  }

  @override
  Future<User?> login(String username, String password) async {
    final userModel = localDataSource.getUser(username);
    if (userModel == null) {
      return null;
    }
    if (userModel.password == password) {
      return userModel.toEntity();
    }
    return null;
  }
}
