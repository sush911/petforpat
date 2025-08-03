import 'package:flutter_test/flutter_test.dart';
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';
import 'package:petforpat/features/dashboard/data/datasources/local_datasource/pet_local_datasource.dart';

import '../mocks/mocks.dart';



void main() {
  late MockBox mockBox;  // Note: no generic here, it's fixed in mocks.dart
  late PetLocalDatasource datasource;

  setUp(() {
    mockBox = MockBox();
    datasource = PetLocalDatasource(mockBox);
  });

  final pet1 = PetModel(
    id: '1',
    name: 'Buddy',
    type: 'Dog',
    age: 3,
    sex: 'Male',
    breed: 'Golden Retriever',
    location: 'Park Lane',
    imageUrl: 'https://example.com/buddy.jpg',
    ownerPhoneNumber: '1234567890',
    description: 'Friendly dog',
  );

  final pet2 = PetModel(
    id: '2',
    name: 'Luna',
    type: 'Cat',
    age: 2,
    sex: 'Female',
    breed: 'Siamese',
    location: 'Sunset Blvd',
    imageUrl: 'https://example.com/luna.jpg',
    ownerPhoneNumber: '0987654321',
    description: 'Loves to cuddle',
  );

}
