// auth_repository_impl.dart

import 'dart:io';
import 'package:petforpat/features/auth/data/datasources/remote_datasource/auth_remote_datasource.dart';
import 'package:petforpat/features/auth/domain/entities/user_entity.dart';
import 'package:petforpat/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> register(Map<String, dynamic> userData) async {
    await remoteDataSource.register(userData);
  }

  @override
  Future<String> login(String username, String password) async {
    return await remoteDataSource.login(username, password);
  }

  @override
  Future<UserEntity> updateProfile(Map<String, dynamic> data, File? image) async {
    return await remoteDataSource.updateProfile(data, image);
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }
}
