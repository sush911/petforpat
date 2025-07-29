import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';
import 'package:petforpat/features/dashboard/domain/repositories/pet_repository.dart';

class GetPetUseCase {
  final PetRepository repository;

  GetPetUseCase(this.repository);

  Future<PetEntity> call(String id) {
    return repository.getPetById(id);
  }
}
