// data/datasources/local_datasource/favorite_local_datasource.dart
import 'package:hive/hive.dart';
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';

class FavoriteLocalDatasource {
  final Box<PetModel> box;
  FavoriteLocalDatasource(this.box);

  List<PetModel> getFavorites() => box.values.toList();
  Future<void> addFavorite(PetModel pet) => box.put(pet.id, pet);
  Future<void> removeFavorite(String id) => box.delete(id);
  bool isFavorite(String id) => box.containsKey(id);
}
