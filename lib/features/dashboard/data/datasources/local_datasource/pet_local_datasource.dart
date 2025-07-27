import 'package:hive/hive.dart';
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';

abstract class PetLocalDataSource {
  Future<void> cachePetList(List<PetModel> pets);
  Future<List<PetModel>> getCachedPetList();
}

class PetLocalDataSourceImpl implements PetLocalDataSource {
  static const String boxName = 'petsBox';

  Future<Box<PetModel>> _openBox() async {
    return await Hive.openBox<PetModel>(boxName);
  }

  @override
  Future<void> cachePetList(List<PetModel> pets) async {
    final box = await _openBox();
    await box.clear();
    await box.addAll(pets);
    // Optionally:
    // await box.close();
  }

  @override
  Future<List<PetModel>> getCachedPetList() async {
    final box = await _openBox();
    final pets = box.values.toList();
    // Optionally:
    // await box.close();
    return pets;
  }
}
