import 'package:hive/hive.dart';
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';

abstract class PetLocalDataSource {
  Future<void> cachePetList(List<PetModel> pets);
  Future<List<PetModel>> getCachedPetList();
}

class PetLocalDataSourceImpl implements PetLocalDataSource {
  static const String boxName = 'petsBox';

  @override
  Future<void> cachePetList(List<PetModel> pets) async {
    final box = await Hive.openBox<PetModel>(boxName);
    await box.clear();
    await box.addAll(pets);
  }

  @override
  Future<List<PetModel>> getCachedPetList() async {
    final box = await Hive.openBox<PetModel>(boxName);
    return box.values.toList();
  }
}
