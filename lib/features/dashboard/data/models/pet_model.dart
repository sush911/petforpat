// features/dashboard/data/models/pet_model.dart

import 'package:hive/hive.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';

part 'pet_model.g.dart'; // Hive codegen part

@HiveType(typeId: 0)
class PetModel extends PetEntity {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final String type;

  @HiveField(3)
  @override
  final int age;

  @HiveField(4)
  @override
  final String sex;

  @HiveField(5)
  @override
  final String breed;

  @HiveField(6)
  @override
  final String location;

  @HiveField(7)
  @override
  final String imageUrl;

  @HiveField(8)
  @override
  final String ownerPhoneNumber;

  @HiveField(9)
  @override
  final String description;

  PetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.age,
    required this.sex,
    required this.breed,
    required this.location,
    required this.imageUrl,
    required this.ownerPhoneNumber,
    required this.description,
  }) : super(
    id: id,
    name: name,
    type: type,
    age: age,
    sex: sex,
    breed: breed,
    location: location,
    imageUrl: imageUrl,
    ownerPhoneNumber: ownerPhoneNumber,
    description: description,
  );

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      age: json['age'] is int
          ? json['age']
          : int.tryParse(json['age']?.toString() ?? '') ?? 0,
      sex: json['sex']?.toString() ?? '',
      breed: json['breed']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      ownerPhoneNumber: json['ownerPhoneNumber']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'type': type,
    'age': age,
    'sex': sex,
    'breed': breed,
    'location': location,
    'imageUrl': imageUrl,
    'ownerPhoneNumber': ownerPhoneNumber,
    'description': description,
  };
}
