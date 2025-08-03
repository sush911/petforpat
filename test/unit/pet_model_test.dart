// test/features/dashboard/data/models/pet_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';

void main() {
  final petJson = {
    '_id': '123',
    'name': 'Buddy',
    'type': 'Dog',
    'age': 5,
    'sex': 'Male',
    'breed': 'Golden Retriever',
    'location': 'Park Street',
    'imageUrl': 'http://example.com/buddy.jpg',
    'ownerPhoneNumber': '1234567890',
    'description': 'Friendly dog',
  };

  final petEntity = PetEntity(
    id: '456',
    name: 'Luna',
    type: 'Cat',
    age: 3,
    sex: 'Female',
    breed: 'Siamese',
    location: 'Main Street',
    imageUrl: 'http://example.com/luna.jpg',
    ownerPhoneNumber: '0987654321',
    description: 'Lovely cat',
  );

  group('PetModel', () {
    test('fromJson should return valid PetModel', () {
      final petModel = PetModel.fromJson(petJson);

      expect(petModel.id, '123');
      expect(petModel.name, 'Buddy');
      expect(petModel.type, 'Dog');
      expect(petModel.age, 5);
      expect(petModel.sex, 'Male');
      expect(petModel.breed, 'Golden Retriever');
      expect(petModel.location, 'Park Street');
      expect(petModel.imageUrl, 'http://example.com/buddy.jpg');
      expect(petModel.ownerPhoneNumber, '1234567890');
      expect(petModel.description, 'Friendly dog');
    });

    test('toJson should return correct map', () {
      final petModel = PetModel.fromJson(petJson);
      final json = petModel.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['_id'], '123');
      expect(json['name'], 'Buddy');
      expect(json['type'], 'Dog');
      expect(json['age'], 5);
      expect(json['sex'], 'Male');
      expect(json['breed'], 'Golden Retriever');
      expect(json['location'], 'Park Street');
      expect(json['imageUrl'], 'http://example.com/buddy.jpg');
      expect(json['ownerPhoneNumber'], '1234567890');
      expect(json['description'], 'Friendly dog');
    });

    test('fromEntity should convert PetEntity to PetModel', () {
      final petModel = PetModel.fromEntity(petEntity);

      expect(petModel.id, petEntity.id);
      expect(petModel.name, petEntity.name);
      expect(petModel.type, petEntity.type);
      expect(petModel.age, petEntity.age);
      expect(petModel.sex, petEntity.sex);
      expect(petModel.breed, petEntity.breed);
      expect(petModel.location, petEntity.location);
      expect(petModel.imageUrl, petEntity.imageUrl);
      expect(petModel.ownerPhoneNumber, petEntity.ownerPhoneNumber);
      expect(petModel.description, petEntity.description);
    });

    test('fromJson should handle missing or null fields gracefully', () {
      final incompleteJson = <String, dynamic>{};
      final petModel = PetModel.fromJson(incompleteJson);

      expect(petModel.id, '');
      expect(petModel.name, '');
      expect(petModel.type, '');
      expect(petModel.age, 0);
      expect(petModel.sex, '');
      expect(petModel.breed, '');
      expect(petModel.location, '');
      expect(petModel.imageUrl, '');
      expect(petModel.ownerPhoneNumber, '');
      expect(petModel.description, '');
    });
  });
}
