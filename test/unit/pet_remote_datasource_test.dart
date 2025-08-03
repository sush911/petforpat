import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:petforpat/features/dashboard/data/models/pet_model.dart';
import 'package:petforpat/features/dashboard/data/datasources/remote_datasource/pet_remote_datasource.dart';

import '../mocks/mocks.mocks.dart';



void main() {
  late PetRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = PetRemoteDataSourceImpl(mockDio);
  });

  group('fetchPets', () {
    test('should return List<PetModel> when API returns a list of pets', () async {
      final mockPetList = [
        {
          'id': '1',
          'name': 'Buddy',
          'type': 'dog',
          'age': 3,
        },
      ];

      when(mockDio.get('/pets', queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
        data: mockPetList,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/pets'),
      ));

      final result = await dataSource.fetchPets();

      expect(result, isA<List<PetModel>>());
      expect(result.length, 1);
      expect(result.first.name, 'Buddy');
    });

    test('should throw Exception when API does not return a list', () async {
      when(mockDio.get('/pets', queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
        data: {'unexpected': 'format'},
        statusCode: 200,
        requestOptions: RequestOptions(path: '/pets'),
      ));

      expect(() => dataSource.fetchPets(), throwsException);
    });
  });

  group('fetchPetById', () {
    test('should return PetModel when API returns valid pet data', () async {
      final petJson = {
        'id': '123',
        'name': 'Milo',
        'type': 'cat',
        'age': 2,
      };

      when(mockDio.get('/pets/123'))
          .thenAnswer((_) async => Response(
        data: petJson,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/pets/123'),
      ));

      final result = await dataSource.fetchPetById('123');

      expect(result, isA<PetModel>());
      expect(result.name, 'Milo');
    });

    test('should throw Exception when API returns invalid data', () async {
      when(mockDio.get('/pets/123'))
          .thenAnswer((_) async => Response(
        data: ['not a map'],
        statusCode: 200,
        requestOptions: RequestOptions(path: '/pets/123'),
      ));

      expect(() => dataSource.fetchPetById('123'), throwsException);
    });
  });
}
