import 'dart:io';
import 'package:petforpat/features/auth/domain/entities/user_entity.dart';
import 'package:petforpat/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<UserEntity> call(Map<String, dynamic> data, File? image) {
    return repository.updateProfile(data, image);
  }
}
