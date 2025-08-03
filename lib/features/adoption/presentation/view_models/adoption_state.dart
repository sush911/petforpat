
import 'package:equatable/equatable.dart';

abstract class AdoptionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdoptionInitial extends AdoptionState {}

class AdoptionLoading extends AdoptionState {}

class AdoptionSuccess extends AdoptionState {}

class AdoptionError extends AdoptionState {
  final String message;

  AdoptionError(this.message);

  @override
  List<Object?> get props => [message];
}