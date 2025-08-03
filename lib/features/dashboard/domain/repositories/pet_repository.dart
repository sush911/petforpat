import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';

abstract class PetRepository {
  Future<List<PetEntity>> getPets({String? search, String? category, bool forceRefresh = false});
  Future<PetEntity> getPetById(String id);
}
