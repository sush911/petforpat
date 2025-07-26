import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class FetchPets extends DashboardEvent {
  final Map<String, dynamic>? filters;

  const FetchPets({this.filters});

  @override
  List<Object?> get props => [filters];
}

class AdoptRequested extends DashboardEvent {
  final String userId;
  final String petId;
  final Map<String, dynamic>? filters;

  const AdoptRequested({
    required this.userId,
    required this.petId,
    this.filters,
  });

  @override
  List<Object?> get props => [userId, petId, filters];
}
