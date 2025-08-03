import 'package:flutter_test/flutter_test.dart';
import 'package:petforpat/features/auth/data/models/user_model.dart';
import 'package:petforpat/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserModel', () {
    const tUserJson = {
      '_id': '123',
      'username': 'testuser',
      'email': 'test@example.com',
      'firstName': 'Test',
      'lastName': 'User',
      'phoneNumber': 1234567890,  // testing as int
      'address': '123 Street',
      'profileImage': 'https://example.com/image.jpg',
    };

    final tUserModel = UserModel(
      id: '123',
      username: 'testuser',
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'User',
      phoneNumber: '1234567890',
      address: '123 Street',
      profileImage: 'https://example.com/image.jpg',
    );

    test('should be a subclass of UserEntity', () {
      expect(tUserModel, isA<UserEntity>());
    });

    test('fromJson should return valid UserModel', () {
      final result = UserModel.fromJson(tUserJson);
      expect(result, equals(tUserModel));
    });

    test('should parse null profileImage correctly', () {
      final json = Map<String, dynamic>.from(tUserJson);
      json['profileImage'] = null;

      final result = UserModel.fromJson(json);
      expect(result.profileImage, isNull);
    });
  });
}
