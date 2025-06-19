import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String token;

  @HiveField(1)
  final String email;

  const UserModel({required this.token, required this.email});
}
