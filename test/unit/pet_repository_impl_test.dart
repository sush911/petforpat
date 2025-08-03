import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';
import 'package:petforpat/features/dashboard/data/repositories/pet_repository_impl.dart';
import 'package:petforpat/features/dashboard/data/datasources/remote_datasource/pet_remote_datasource.dart';
import 'package:petforpat/features/dashboard/data/datasources/local_datasource/pet_local_datasource.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';

import '../mocks/mocks.mocks.dart'; // Make sure you have generated mocks

void main() {
  late PetRepositoryImpl repository;
  late MockPetRemoteDataSource mockRemoteDataSource;
  late MockPetLocalDatasource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockPetRemoteDataSource();
    mockLocalDataSource = MockPetLocalDatasource();
    repository = PetRepositoryImpl(mockRemoteDataSource, mockLocalDataSource);
  });

  final testPetModel = PetModel(
    id: '1',
    name: 'Fluffy',
    type: 'Dog',
    age: 3,
    sex: 'Male',
    breed: 'Poodle',
    location: '123 Pet St',
    imageUrl: 'http://image.url/fluffy.jpg',
    ownerPhoneNumber: '1234567890',
    description: 'Friendly dog',
  );

  group('getPets', () {
    test('returns pets from remote and caches them when forceRefresh=false', () async {
      // Arrange
      when(mockRemoteDataSource.fetchPets(search: null, category: null))
          .thenAnswer((_) async => [testPetModel]);
      when(mockLocalDataSource.cachePets(any)).thenAnswer((_) async {});

      // Act
      final result = await repository.getPets();

      // Assert
      expect(result, [testPetModel]);
      verify(mockRemoteDataSource.fetchPets(search: null, category: null)).called(1);
      verify(mockLocalDataSource.cachePets(any)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('returns cached pets when remote throws and cache is not empty', () async {
      // Arrange
      when(mockRemoteDataSource.fetchPets(search: null, category: null))
          .thenThrow(Exception('Remote error'));
      when(mockLocalDataSource.getCachedPets())
          .thenReturn([testPetModel]);

      // Act
      final result = await repository.getPets();

      // Assert
      expect(result, [testPetModel]);
      verify(mockRemoteDataSource.fetchPets(search: null, category: null)).called(1);
      verify(mockLocalDataSource.getCachedPets()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('rethrows error when remote throws and cache is empty', () async {
      // Arrange
      when(mockRemoteDataSource.fetchPets(search: null, category: null))
          .thenThrow(Exception('Remote error'));
      when(mockLocalDataSource.getCachedPets()).thenReturn([]);

      // Act & Assert
      expect(() => repository.getPets(), throwsException);
      verify(mockRemoteDataSource.fetchPets(search: null, category: null)).called(1);
      verify(mockLocalDataSource.getCachedPets()).called(1);
    });

    test('forceRefresh=true fetches from remote and caches results', () async {
      // Arrange
      when(mockRemoteDataSource.fetchPets(search: 'cat', category: 'cat'))
          .thenAnswer((_) async => [testPetModel]);
      when(mockLocalDataSource.cachePets(any)).thenAnswer((_) async {});

      // Act
      final result = await repository.getPets(search: 'cat', category: 'cat', forceRefresh: true);

      // Assert
      expect(result, [testPetModel]);
      verify(mockRemoteDataSource.fetchPets(search: 'cat', category: 'cat')).called(1);
      verify(mockLocalDataSource.cachePets(any)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('getPetById', () {
    test('returns pet when remote fetch is successful', () async {
      // Arrange
      when(mockRemoteDataSource.fetchPetById('1'))
          .thenAnswer((_) async => testPetModel);

      // Act
      final result = await repository.getPetById('1');

      // Assert
      expect(result, testPetModel);
      verify(mockRemoteDataSource.fetchPetById('1')).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('throws "Pet not found" exception on 404 Dio error', () async {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      when(mockRemoteDataSource.fetchPetById('1'))
          .thenThrow(dioException);

      // Act & Assert
      expect(() => repository.getPetById('1'), throwsA(predicate((e) => e.toString().contains('Pet not found'))));
      verify(mockRemoteDataSource.fetchPetById('1')).called(1);
    });

    test('throws network error with message on other Dio errors', () async {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 500,
          data: {'message': 'Server error'},
          requestOptions: RequestOptions(path: ''),
        ),
      );

      when(mockRemoteDataSource.fetchPetById('1'))
          .thenThrow(dioException);

      // Act & Assert
      expect(() => repository.getPetById('1'), throwsA(predicate((e) => e.toString().contains('Network error: Server error'))));
      verify(mockRemoteDataSource.fetchPetById('1')).called(1);
    });

    test('throws unexpected error on generic exception', () async {
      // Arrange
      when(mockRemoteDataSource.fetchPetById('1'))
          .thenThrow(Exception('Some error'));

      // Act & Assert
      expect(() => repository.getPetById('1'), throwsA(predicate((e) => e.toString().contains('Unexpected error'))));
      verify(mockRemoteDataSource.fetchPetById('1')).called(1);
    });
  });
}
