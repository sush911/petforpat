import 'dart:io';
import 'package:petforpat/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> register(Map<String, dynamic> data);
  Future<String> login(String username, String password);
  Future<UserEntity> updateProfile(Map<String, dynamic> data, File? image);
  Future<UserEntity> getCurrentUser(); // ✅ Add this method
}
