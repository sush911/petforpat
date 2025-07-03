import 'package:hive/hive.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String? token;   // nullable

  @HiveField(5)
  final String? password; // nullable

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.token,
    this.password,
  });

  /// Convert domain entity (User) to UserModel
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      username: user.username,
      email: user.email,
      token: user.token,
      password: null, // Password isn't stored in the domain model
    );
  }

  /// Convert UserModel to domain entity (User)
  User toEntity() {
    return User(
      id: id,
      name: name,
      username: username,
      email: email,
      token: token ?? '',
    );
  }

  /// Parse UserModel from backend JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      token: json['token'],
      password: null, // Not expected from backend
    );
  }

  /// Convert UserModel to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
