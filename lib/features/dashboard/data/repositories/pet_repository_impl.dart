import 'package:petforpat/features/dashboard/data/datasources/local_datasource/pet_local_datasource.dart';
import 'package:petforpat/features/dashboard/data/datasources/remote_datasource/pet_remote_datasource.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';
import 'package:petforpat/features/dashboard/domain/repositories/pet_repository.dart';
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';

class PetRepositoryImpl implements PetRepository {
  final PetRemoteDataSource remote;
  final PetLocalDataSource local;

  PetRepositoryImpl(this.remote, this.local);

  @override
  Future<List<PetEntity>> getPets({Map<String, dynamic>? filters}) async {
    try {
      final List<PetModel> pets = await remote.fetchPets(filters: filters);
      await local.cachePetList(pets);
      return pets.map((pet) => pet.toEntity()).toList();
    } catch (_) {
      final List<PetModel> cachedPets = await local.getCachedPetList();
      return cachedPets.map((pet) => pet.toEntity()).toList();
    }
  }

  @override
  Future<void> adoptPet({required String userId, required String petId}) async {
    await remote.adoptPet(userId: userId, petId: petId);
  }
}
