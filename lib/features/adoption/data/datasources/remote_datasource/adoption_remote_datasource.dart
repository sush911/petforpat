// features/adoption/data/datasources/remote_datasource/adoption_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:petforpat/features/adoption/data/models/adoption_request_model.dart';


abstract class AdoptionRemoteDataSource {
  Future<void> submitAdoptionRequest(AdoptionRequestModel request);
}

class AdoptionRemoteDataSourceImpl implements AdoptionRemoteDataSource {
  final Dio dio;
  AdoptionRemoteDataSourceImpl(this.dio);

  @override
  Future<void> submitAdoptionRequest(AdoptionRequestModel request) async {
    await dio.post('/adoptions', data: request.toJson());
  }
}