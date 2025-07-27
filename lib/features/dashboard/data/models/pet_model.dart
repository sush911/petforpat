import 'package:hive/hive.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';

part 'pet_model.g.dart';

@HiveType(typeId: 1)
class PetModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String type;

  @HiveField(3)
  int age;

  @HiveField(4)
  String sex;

  @HiveField(5)
  String breed;

  @HiveField(6)
  String location;

  @HiveField(7)
  String imageUrl;

  @HiveField(8)
  bool adopted;

  @HiveField(9)
  String ownerPhoneNumber;

  @HiveField(10)
  String description;

  PetModel({
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

  factory PetModel.fromJson(Map<String, dynamic> json) {
    String rawImageUrl = json['imageUrl'] ?? '';
    String resolvedImageUrl = rawImageUrl.startsWith('/')
        ? 'http://192.168.10.70:3001$rawImageUrl'
        : rawImageUrl;

    // 🛠 Handle MongoDB ObjectId (_id.$oid)
    String extractId(dynamic idField) {
      if (idField is Map && idField.containsKey(r'$oid')) {
        return idField[r'$oid'] ?? '';
      } else if (idField is String) {
        return idField;
      }
      return '';
    }

    return PetModel(
      id: extractId(json['_id']),
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      age: json['age'] ?? 0,
      sex: json['sex'] ?? '',
      breed: json['breed'] ?? '',
      location: json['location'] ?? '',
      imageUrl: resolvedImageUrl,
      adopted: json['adopted'] ?? false,
      ownerPhoneNumber: json['ownerPhoneNumber']?.toString() ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'age': age,
      'sex': sex,
      'breed': breed,
      'location': location,
      'imageUrl': imageUrl,
      'adopted': adopted,
      'ownerPhoneNumber': ownerPhoneNumber,
      'description': description,
    };
  }

  PetEntity toEntity({int? hiveId}) => PetEntity(
    hiveId: hiveId ?? (key as int?),
    id: id,
    name: name,
    type: type,
    age: age,
    sex: sex,
    breed: breed,
    location: location,
    imageUrl: imageUrl,
    adopted: adopted,
    ownerPhoneNumber: ownerPhoneNumber,
    description: description,
  );

  factory PetModel.fromEntity(PetEntity entity) => PetModel(
    id: entity.id,
    name: entity.name,
    type: entity.type,
    age: entity.age,
    sex: entity.sex,
    breed: entity.breed,
    location: entity.location,
    imageUrl: entity.imageUrl,
    adopted: entity.adopted,
    ownerPhoneNumber: entity.ownerPhoneNumber,
    description: entity.description,
  );
}
