
// data/repositories/adoption_repository_impl.dart

import 'package:petforpat/features/adoption/data/datasources/remote_datasource/adoption_remote_datasource.dart';
import 'package:petforpat/features/adoption/data/models/adoption_request_model.dart';
import 'package:petforpat/features/adoption/domain/entities/adoption_request.dart';
import 'package:petforpat/features/adoption/domain/repositories/adoption_repository.dart';

class AdoptionRepositoryImpl implements AdoptionRepository {
  final AdoptionRemoteDataSource remoteDataSource;
  AdoptionRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> submitRequest(AdoptionRequest request) async {
    final model = AdoptionRequestModel(
      petId: request.petId,
      petName: request.petName,
      petType: request.petType,
      fullName: request.fullName,
      citizenshipNumber: request.citizenshipNumber,
      phoneNumber: request.phoneNumber,
      email: request.email,
      homeAddress: request.homeAddress,
      reason: request.reason,
    );
    await remoteDataSource.submitAdoptionRequest(model);
  }
}
