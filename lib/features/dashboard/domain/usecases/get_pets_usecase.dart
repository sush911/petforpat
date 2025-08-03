import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';
import 'package:petforpat/features/dashboard/domain/repositories/pet_repository.dart';

class GetPetsUseCase {
  final PetRepository repository;

  GetPetsUseCase(this.repository);

  Future<List<PetEntity>> call({
    String? search,
    String? category,
    bool forceRefresh = false,
  }) {
    return repository.getPets(
      search: search,
      category: category,
      forceRefresh: forceRefresh,
    );
  }
}
