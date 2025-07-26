import 'package:petforpat/features/dashboard/domain/repositories/pet_repository.dart';

class AdoptPetUseCase {
  final PetRepository repository;

  AdoptPetUseCase(this.repository);

  Future<void> call({required String userId, required String petId}) async {
    await repository.adoptPet(userId: userId, petId: petId);
  }
}
