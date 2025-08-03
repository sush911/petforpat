// data/repositories/favorite_repository_impl.dart

import 'package:hive/hive.dart';
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';
import 'package:petforpat/features/favorite/domain/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final Box<PetModel> box;

  FavoriteRepositoryImpl(this.box);

  @override
  Future<void> toggleFavorite(PetEntity pet) async {
    final key = pet.id;
    if (box.containsKey(key)) {
      await box.delete(key);
    } else {
      final model = PetModel.fromEntity(pet);
      await box.put(key, model);
    }
  }

  @override
  Future<List<PetEntity>> fetchFavorites() async {
    return box.values.toList().reversed.toList(); // newest first
  }

  @override
  Future<bool> isFavorite(String id) async {
    return box.values.any((item) => item.id == id);
  }
}



