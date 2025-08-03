import 'package:bloc/bloc.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';
import 'package:petforpat/features/favorite/domain/usecases/get_favorites_usecase.dart';
import 'package:petforpat/features/favorite/presentation/view_models/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final GetFavoritesUseCase uc;

  FavoriteCubit(this.uc) : super(FavoriteState());

  Future<void> loadFavorites({String? category, String? search}) async {
    emit(FavoriteState(loading: true, pets: state.pets));
    try {
      final allPets = await uc();

      // Filter by category/type and search
      final filteredPets = allPets.where((pet) {
        final matchesCategory =
            category == null || category == 'All' || pet.type.toLowerCase() == category.toLowerCase();
        final matchesSearch = search == null || search.isEmpty
            || pet.name.toLowerCase().contains(search.toLowerCase());

        return matchesCategory && matchesSearch;
      }).toList();

      emit(FavoriteState(pets: filteredPets));
    } catch (e) {
      emit(FavoriteState(error: e.toString(), pets: state.pets));
    }
  }

  Future<bool> isFavorite(String id) async {
    return await uc.repo.isFavorite(id);
  }

  Future<void> toggleFavorite(PetEntity petModel) async {
    await uc.repo.toggleFavorite(petModel);

    final isCurrentlyFavorite = state.pets.any((pet) => pet.id == petModel.id);
    List<PetEntity> updatedPets;

    if (isCurrentlyFavorite) {
      updatedPets = state.pets.where((pet) => pet.id != petModel.id).toList();
    } else {
      updatedPets = List.from(state.pets)..add(petModel);
    }

    emit(FavoriteState(pets: updatedPets));
  }
}
