
// domain/usecases/submit_adoption_request.dart
import '../entities/adoption_request.dart';
import '../repositories/adoption_repository.dart';

class SubmitAdoptionRequestUseCase {
  final AdoptionRepository repository;
  SubmitAdoptionRequestUseCase(this.repository);

  Future<void> call(AdoptionRequest request) async {
    await repository.submitRequest(request);
  }
}
