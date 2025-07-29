// domain/repositories/favorite_repository.dart

import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';

abstract class FavoriteRepository {
  Future<void> toggleFavorite(PetEntity pet);
  Future<List<PetEntity>> fetchFavorites();
  Future<bool> isFavorite(String id);
}
