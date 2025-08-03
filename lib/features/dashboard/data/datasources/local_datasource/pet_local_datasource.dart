import 'package:hive/hive.dart';
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';

class PetLocalDatasource {
  final Box<PetModel> petBox;
  PetLocalDatasource(this.petBox);

  List<PetModel> getCachedPets() => petBox.values.toList();

  Future<void> cachePets(List<PetModel> pets) async {
    await petBox.clear();

    final Map<String, PetModel> petsMap = {
      for (var pet in pets) pet.id: pet,
    };

    await petBox.putAll(petsMap);
  }
}
