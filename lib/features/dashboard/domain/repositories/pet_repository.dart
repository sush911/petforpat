import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';

abstract class PetRepository {
  Future<List<PetEntity>> getPets({Map<String, dynamic>? filters});
  Future<void> adoptPet({required String userId, required String petId});
}
