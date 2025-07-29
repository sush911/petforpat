// features/dashboard/domain/entities/pet_entity.dart
class PetEntity {
  final String id;
  final String name;
  final String type;
  final int age;
  final String sex;
  final String breed;
  final String location;
  final String imageUrl;
  final String ownerPhoneNumber;
  final String description;

  PetEntity({
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
  });
}
