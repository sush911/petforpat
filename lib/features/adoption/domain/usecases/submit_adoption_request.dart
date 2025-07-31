
// domain/usecases/submit_adoption_request.dart

import 'package:petforpat/features/adoption/domain/entities/adoption_request.dart';
import 'package:petforpat/features/adoption/domain/repositories/adoption_repository.dart';

class SubmitAdoptionRequestUseCase {
  final AdoptionRepository repository;
  SubmitAdoptionRequestUseCase(this.repository);

  Future<void> call(AdoptionRequest request) async {
    await repository.submitRequest(request);
  }
}
