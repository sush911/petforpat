// pet_state.dart

import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';

// Existing pet states
abstract class PetState {}

class PetInitial extends PetState {}

class PetLoading extends PetState {}

class PetLoaded extends PetState {
  final List<PetEntity> pets;

  PetLoaded(this.pets);
}

class PetError extends PetState {
  final String message;

  PetError(this.message);
}

// Add PetDetailState here:

abstract class PetDetailState {}

class PetDetailInitial extends PetDetailState {}

class PetDetailLoading extends PetDetailState {}

class PetDetailLoaded extends PetDetailState {
  final PetEntity pet;

  PetDetailLoaded(this.pet);
}

class PetDetailError extends PetDetailState {
  final String message;

  PetDetailError(this.message);
}
