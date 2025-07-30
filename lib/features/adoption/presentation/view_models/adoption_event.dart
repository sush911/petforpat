import 'package:equatable/equatable.dart';
import 'package:petforpat/features/adoption/domain/entities/adoption_request.dart';

abstract class AdoptionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitAdoptionEvent extends AdoptionEvent {
  final AdoptionRequest request;

  SubmitAdoptionEvent(this.request);

  @override
  List<Object?> get props => [request];
}
