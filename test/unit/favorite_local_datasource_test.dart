// test/unit/favorite_local_datasource_test.dart
/*
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';

import '../../lib/features/favorite/data/datasources/local_datasource/favorite_local_datasource.dart';

// Generic mock for Hive Box
class MockBox<T> extends Mock implements Box<T> {}

void main() {
  late MockBox<PetModel> mockBox;
  late FavoriteLocalDatasource datasource;

  final pet1 = PetModel(
    id: '1',
    name: 'Buddy',
    type: 'Dog',
    age: 3,
    sex: 'Male',
    breed: 'Beagle',
    location: 'NY',
    imageUrl: 'url1',
    ownerPhoneNumber: '1234567890',
    description: 'Friendly dog',
  );

  final pet2 = PetModel(
    id: '2',
    name: 'Mittens',
    type: 'Cat',
    age: 2,
    sex: 'Female',
    breed: 'Siamese',
    location: 'LA',
    imageUrl: 'url2',
    ownerPhoneNumber: '0987654321',
    description: 'Cute cat',
  );

  setUp(() {
    mockBox = MockBox<PetModel>();
    datasource = FavoriteLocalDatasource(mockBox);
  });

  test('getFavorites should return list of pets from box', () {
    when(mockBox.values).thenReturn([pet1, pet2]);

    final result = datasource.getFavorites();

    expect(result, [pet1, pet2]);
    verify(mockBox.values).called(1);
  });

  test('addFavorite should add pet to box', () async {
    when(mockBox.put(pet1.id, pet1)).thenAnswer((_) async {});

    await datasource.addFavorite(pet1);

    verify(mockBox.put(pet1.id, pet1)).called(1);
  });

  test('removeFavorite should delete pet by id', () async {
    when(mockBox.delete(pet1.id)).thenAnswer((_) async {});

    await datasource.removeFavorite(pet1.id);

    verify(mockBox.delete(pet1.id)).called(1);
  });

  test('isFavorite should check if pet exists in box', () {
    when(mockBox.containsKey(pet1.id)).thenReturn(true);

    final result = datasource.isFavorite(pet1.id);

    expect(result, true);
    verify(mockBox.containsKey(pet1.id)).called(1);
  });
} */
