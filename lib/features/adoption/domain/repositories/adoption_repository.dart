// domain/repositories/adoption_repository.dart

import 'package:petforpat/features/adoption/domain/entities/adoption_request.dart';

abstract class AdoptionRepository {
  Future<void> submitRequest(AdoptionRequest request);
}
