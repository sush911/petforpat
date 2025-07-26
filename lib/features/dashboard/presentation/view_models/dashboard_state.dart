import 'package:equatable/equatable.dart';
import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class PetsLoading extends DashboardState {}

class PetsLoaded extends DashboardState {
  final List<PetEntity> pets;

  const PetsLoaded(this.pets);

  @override
  List<Object?> get props => [pets];
}

class PetAdopted extends DashboardState {
  final String petId;

  const PetAdopted(this.petId);

  @override
  List<Object?> get props => [petId];
}

class PetsError extends DashboardState {
  final String message;

  const PetsError(this.message);

  @override
  List<Object?> get props => [message];
}
