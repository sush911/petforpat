import 'package:dio/dio.dart';
import 'package:petforpat/features/dashboard/data/datasources/remote_datasource/pet_remote_datasource.dart';
import 'package:petforpat/features/dashboard/data/datasources/local_datasource/pet_local_datasource.dart';
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';
import 'package:petforpat/features/dashboard/domain/repositories/pet_repository.dart';

class PetRepositoryImpl implements PetRepository {
  final PetRemoteDataSource remoteDataSource;
  final PetLocalDatasource localDataSource;

  PetRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<PetEntity>> getPets({
    String? search,
    String? category,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      try {
        // Try fetching fresh pets from API first
        final pets = await remoteDataSource.fetchPets(
          search: search,
          category: category,
        );

        // Cache fresh pets
        final petsToCache = pets.map((pet) {
          if (pet is PetModel) {
            return pet;
          } else {
            return PetModel(
              id: pet.id,
              name: pet.name,
              type: pet.type,
              age: pet.age,
              sex: pet.sex,
              breed: pet.breed,
              location: pet.location,
              imageUrl: pet.imageUrl,
              ownerPhoneNumber: pet.ownerPhoneNumber,
              description: pet.description,
            );
          }
        }).toList();

        await localDataSource.cachePets(petsToCache);
        return pets;
      } catch (_) {
        // If API fails, fallback to cache
        final cachedPets = localDataSource.getCachedPets();
        if (cachedPets.isNotEmpty) {
          return cachedPets;
        }
        rethrow; // If no cache, rethrow error
      }
    } else {
      // If forceRefresh is true, ignore cache and fetch fresh pets
      final pets = await remoteDataSource.fetchPets(
        search: search,
        category: category,
      );
      final petsToCache = pets.map((pet) {
        if (pet is PetModel) {
          return pet;
        } else {
          return PetModel(
            id: pet.id,
            name: pet.name,
            type: pet.type,
            age: pet.age,
            sex: pet.sex,
            breed: pet.breed,
            location: pet.location,
            imageUrl: pet.imageUrl,
            ownerPhoneNumber: pet.ownerPhoneNumber,
            description: pet.description,
          );
        }
      }).toList();
      await localDataSource.cachePets(petsToCache);
      return pets;
    }
  }

  @override
  Future<PetEntity> getPetById(String id) async {
    try {
      // Always fetch latest detail from server
      return await remoteDataSource.fetchPetById(id);
    } on DioException catch (dioError) {
      if (dioError.response?.statusCode == 404) {
        throw Exception('Pet not found');
      }

      final message = dioError.response?.data['message'] as String? ??
          dioError.message ??
          'An unknown error occurred';
      throw Exception('Network error: $message');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
