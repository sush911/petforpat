import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';

class FavoriteState {
  final bool loading;
  final List<PetEntity> pets;
  final String? error;

  FavoriteState({
    this.loading = false,
    this.pets = const [],
    this.error,
  });
}
