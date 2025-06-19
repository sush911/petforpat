import 'package:hive/hive.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends User {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String password;

  UserModel({required this.username, required this.password})
      : super(username: username, password: password);

  factory UserModel.fromEntity(User user) {
    return UserModel(username: user.username, password: user.password);
  }

  User toEntity() {
    return User(username: username, password: password);
  }
}
