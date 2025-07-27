// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PetModelAdapter extends TypeAdapter<PetModel> {
  @override
  final int typeId = 1;

  @override
  PetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PetModel(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      age: fields[3] as int,
      sex: fields[4] as String,
      breed: fields[5] as String,
      location: fields[6] as String,
      imageUrl: fields[7] as String,
      adopted: fields[8] as bool,
      ownerPhoneNumber: fields[9] as String,
      description: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PetModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.age)
      ..writeByte(4)
      ..write(obj.sex)
      ..writeByte(5)
      ..write(obj.breed)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.adopted)
      ..writeByte(9)
      ..write(obj.ownerPhoneNumber)
      ..writeByte(10)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
