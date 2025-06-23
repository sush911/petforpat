// user_model.dart
import 'package:hive/hive.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? username;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? password;

  @HiveField(4)
  final String? token;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.token,
  });

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      username: user.username,
      email: user.email,
      password: user.password,
      token: user.token,
    );
  }

  User toEntity() {
    return User(
      id: id ?? '',
      username: username ?? '',
      email: email ?? '',
      password: password ?? '',
      token: token ?? '',
    );
  }
}
