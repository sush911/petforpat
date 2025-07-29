// features/dashboard/presentation/view_models/dashboard_state.dart



import 'package:petforpat/features/dashboard/domain/entities/pet_entity.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<PetEntity> pets;
  DashboardLoaded(this.pets);
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
