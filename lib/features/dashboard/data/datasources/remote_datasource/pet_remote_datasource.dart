import 'package:dio/dio.dart';
import 'package:petforpat/app/shared_pref/shared_preferences.dart';
import 'package:petforpat/features/dashboard/data/datasources/local_datasource/pet_local_datasource.dart';
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';

/// Abstract contract for remote data operations related to pets.
abstract class PetRemoteDataSource {
  Future<List<PetModel>> fetchPets({Map<String, dynamic>? filters});
  Future<PetModel> getPetDetail(String id);
  Future<void> adoptPet({required String userId, required String petId});
}

/// Implementation of PetRemoteDataSource using Dio for API communication.
class PetRemoteDataSourceImpl implements PetRemoteDataSource {
  final Dio dio;
  final PetLocalDataSource local;
  final SharedPrefsHelper prefsHelper = SharedPrefsHelper(); // ✅ initialize helper

  PetRemoteDataSourceImpl(this.dio, this.local);

  @override
  Future<List<PetModel>> fetchPets({Map<String, dynamic>? filters}) async {
    try {
      final response = await dio.get('/pets', queryParameters: filters);

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
      final token = await prefsHelper.getToken();

      if (token == null) {
        throw Exception('User is not authenticated');
      }

      final response = await dio.post(
        '/adoptions/$petId',
        data: {
          'userId': userId, // ✅ send userId in request body
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('✅ Adoption successful: ${response.statusCode}');
    } catch (e) {
      print('❌ Failed to adopt pet: $e');
      throw Exception('Failed to send adoption request: ${e.toString()}');
    }
  }
}
