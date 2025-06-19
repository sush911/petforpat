import 'package:hive/hive.dart';
import 'package:petforpat/features/auth/data/models/user_model.dart';

abstract class UserLocalDataSource {
  Future<void> saveUser(UserModel user);
  UserModel? getUser(String username);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box<UserModel> userBox;

  UserLocalDataSourceImpl(this.userBox);

  @override
  Future<void> saveUser(UserModel user) async {
    await userBox.put(user.username, user);
  }

  @override
  UserModel? getUser(String username) {
    return userBox.get(username);
  }
}
