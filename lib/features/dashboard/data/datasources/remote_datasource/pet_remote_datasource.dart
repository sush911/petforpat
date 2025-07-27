import 'package:dio/dio.dart';
import 'package:petforpat/features/dashboard/data/datasources/local_datasource/pet_local_datasource.dart';
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PetRemoteDataSource {
  Future<List<PetModel>> fetchPets({Map<String, dynamic>? filters});
  Future<PetModel> getPetDetail(String id);
  Future<void> adoptPet({required String userId, required String petId});
}

class PetRemoteDataSourceImpl implements PetRemoteDataSource {
  final Dio dio;
  final PetLocalDataSource local;

  PetRemoteDataSourceImpl(this.dio, this.local);

  @override
  Future<List<PetModel>> fetchPets({Map<String, dynamic>? filters}) async {
    try {
      final response = await dio.get('/pets', queryParameters: filters);

      // 🐾 Debug logs for raw API data and parsed result
      print('🐾 Raw response: ${response.data}');

      final pets = (response.data as List)
          .map<PetModel>((json) => PetModel.fromJson(json))
          .toList();

      print('✅ Parsed pets count: ${pets.length}');
      await local.cachePetList(pets);
      return pets;
    } catch (e) {
      print('⚠️ Failed to fetch from API, using local cache. Error: $e');
      return await local.getCachedPetList();
    }
  }


  @override
  Future<PetModel> getPetDetail(String id) async {
    final response = await dio.get('/pets/$id');
    return PetModel.fromJson(response.data);
  }

  @override
  Future<void> adoptPet({required String userId, required String petId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('User is not authenticated');
      }

      await dio.post(
        '/adoptions/$userId/$petId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to send adoption request: ${e.toString()}');
    }
  }
}
