// domain/usecases/get_favorites_usecase.dart
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';
import '../repositories/favorite_repository.dart';

class GetFavoritesUseCase {
  final FavoriteRepository repo;
  GetFavoritesUseCase(this.repo);

  Future<List<PetEntity>> call() => repo.fetchFavorites();
}
