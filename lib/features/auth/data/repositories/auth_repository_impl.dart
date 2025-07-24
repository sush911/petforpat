import 'dart:io';

import 'package:petforpat/features/auth/data/datasources/remote_datasource/auth_remote_datasource.dart';
import 'package:petforpat/features/auth/domain/entities/user_entity.dart';
import 'package:petforpat/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> register(Map<String, dynamic> userData) {
    return remoteDataSource.register(userData);
  }

  @override
  Future<String> login(String username, String password) {
    return remoteDataSource.login(username, password);
  }

  @override
  Future<UserEntity> updateProfile(Map<String, dynamic> data, File? image) {
    return remoteDataSource.updateProfile(data, image);
  }

  @override
  Future<UserEntity> getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }
}
