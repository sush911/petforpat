import 'package:dio/dio.dart';
import 'package:petforpat/features/dashboard/data/models/pet_model.dart';

abstract class PetRemoteDataSource {
  Future<List<PetModel>> fetchPets({String? search, String? category});
  Future<PetModel> fetchPetById(String id);
}

class PetRemoteDataSourceImpl implements PetRemoteDataSource {
  final Dio dio;

  PetRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PetModel>> fetchPets({String? search, String? category}) async {
    try {
      final queryParams = <String, dynamic>{
        if (search != null && search.isNotEmpty) 'search': search,
        if (category != null && category.isNotEmpty) 'type': category,
      };

      final response = await dio.get('/pets', queryParameters: queryParams);

      print("📦 fetchPets Raw Response: ${response.data.runtimeType}");

      if (response.data is List) {
        return (response.data as List)
            .map((json) => PetModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Expected a List from API but got: ${response.data.runtimeType}');
      }
    } catch (e, st) {
      print("❌ Error in fetchPets: $e");
      print("🪵 Stack Trace: $st");
      rethrow;
    }
  }

  @override
  Future<PetModel> fetchPetById(String id) async {
    try {
      final response = await dio.get('/pets/$id');

      if (response.data is Map<String, dynamic>) {
        return PetModel.fromJson(response.data);
      } else {
        throw Exception('Expected a Map for single pet but got: ${response.data.runtimeType}');
      }
    } catch (e) {
      print("❌ Error in fetchPetById: $e");
      rethrow;
    }
  }
}
