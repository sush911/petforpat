import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:petforpat/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:petforpat/features/auth/data/datasources/remote_datasource/auth_remote_datasource.dart';
import 'package:petforpat/features/auth/data/models/user_model.dart';  // Import UserModel
import '../mocks/mocks.mocks.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockRemoteDataSource);
  });

  group('register', () {
    final testUserData = {
      'username': 'testuser',
      'email': 'testuser@example.com',
      'password': 'password123',
    };

    test('should call remoteDataSource.register with correct data', () async {
      when(mockRemoteDataSource.register(testUserData))
          .thenAnswer((_) async => Future.value());

      await repository.register(testUserData);

      verify(mockRemoteDataSource.register(testUserData)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('login', () {
    final testUsername = 'testuser';
    final testPassword = 'password123';
    final testToken = 'dummy_token_abc123';

    test('should call remoteDataSource.login and return token', () async {
      when(mockRemoteDataSource.login(testUsername, testPassword))
          .thenAnswer((_) async => testToken);

      final result = await repository.login(testUsername, testPassword);

      expect(result, testToken);
      verify(mockRemoteDataSource.login(testUsername, testPassword)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('updateProfile', () {
    final testData = {
      'firstName': 'Updated',
      'lastName': 'User',
      'phoneNumber': '9876543210',
      'address': '456 New St',
    };
    final File? testImage = null;

    final testUserModel = UserModel(
      id: '1',
      username: 'testuser',
      email: 'testuser@example.com',
      firstName: 'Updated',
      lastName: 'User',
      phoneNumber: '9876543210',
      address: '456 New St',
      profileImage: null,
    );

    test('should call remoteDataSource.updateProfile and return updated UserModel', () async {
      when(mockRemoteDataSource.updateProfile(testData, testImage))
          .thenAnswer((_) async => testUserModel);

      final result = await repository.updateProfile(testData, testImage);

      expect(result, testUserModel);
      verify(mockRemoteDataSource.updateProfile(testData, testImage)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('getCurrentUser', () {
    final testUserModel = UserModel(
      id: '1',
      username: 'testuser',
      email: 'testuser@example.com',
      firstName: 'Test',
      lastName: 'User',
      phoneNumber: '1234567890',
      address: '123 Test St',
      profileImage: null,
    );

    test('should call remoteDataSource.getCurrentUser and return UserModel', () async {
      when(mockRemoteDataSource.getCurrentUser())
          .thenAnswer((_) async => testUserModel);

      final result = await repository.getCurrentUser();

      expect(result, testUserModel);
      verify(mockRemoteDataSource.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('clearToken', () {
    test('should call remoteDataSource.clearToken', () async {
      when(mockRemoteDataSource.clearToken())
          .thenAnswer((_) async => Future.value());

      await repository.clearToken();

      verify(mockRemoteDataSource.clearToken()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
}
