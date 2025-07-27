import 'package:petforpat/features/dashboard/data/datasources/local_datasource/pet_local_datasource.dart';
import 'package:petforpat/features/dashboard/data/datasources/remote_datasource/pet_remote_datasource.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';
import 'package:petforpat/features/dashboard/domain/repositories/pet_repository.dart';

class PetRepositoryImpl implements PetRepository {
  final PetRemoteDataSource remote;
  final PetLocalDataSource local;

  PetRepositoryImpl(this.remote, this.local);

  @override
  Future<List<PetEntity>> getPets({Map<String, dynamic>? filters}) async {
    try {
      final pets = await remote.fetchPets(filters: filters);
      print("🟢 Repository: Remote pets fetched: ${pets.length}");
      await local.cachePetList(pets);
      return pets.map((p) => p.toEntity()).toList();
    } catch (e, stack) {
      print("🔴 Repository: Remote fetch failed: $e");
      print(stack);
      final cached = await local.getCachedPetList();
      print("📦 Repository: Fallback cached pets: ${cached.length}");
      return cached.map((p) => p.toEntity()).toList();
    }
  }

  @override
  Future<void> adoptPet({required String userId, required String petId}) async {
    await remote.adoptPet(userId: userId, petId: petId);
  }
}
