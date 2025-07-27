import 'package:equatable/equatable.dart';

class PetEntity extends Equatable {
  final int? hiveId;
  final String id;
  final String name;
  final String type;
  final int age;
  final String sex;
  final String breed;
  final String location;
  final String imageUrl;
  final bool adopted;
  final String ownerPhoneNumber;
  final String description;

  const PetEntity({
    this.hiveId,
    required this.id,
    required this.name,
    required this.type,
    required this.age,
    required this.sex,
    required this.breed,
    required this.location,
    required this.imageUrl,
    required this.adopted,
    required this.ownerPhoneNumber,
    required this.description,
  });

  @override
  List<Object?> get props => [
    hiveId,
    id,
    name,
    type,
    age,
    sex,
    breed,
    location,
    imageUrl,
    adopted,
    ownerPhoneNumber,
    description,
  ];
}
