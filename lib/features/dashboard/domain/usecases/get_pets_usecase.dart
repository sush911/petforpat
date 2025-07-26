import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';
import 'package:petforpat/features/dashboard/domain/repositories/pet_repository.dart';

class GetPetsUseCase {
  final PetRepository repo;
  GetPetsUseCase(this.repo);

  Future<List<PetEntity>> call({Map<String, dynamic>? filters}) {
    return repo.getPets(filters: filters);
  }
}
