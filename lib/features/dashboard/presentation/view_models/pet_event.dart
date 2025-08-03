// pet_event.dart

// Existing pet events
abstract class PetEvent {}

class LoadPetsEvent extends PetEvent {
  final String? search;
  final String? category;
  final bool forceRefresh;

  LoadPetsEvent({this.search, this.category, this.forceRefresh = false});
}

// PetDetail events

abstract class PetDetailEvent {}

class LoadPetDetailEvent extends PetDetailEvent {
  final String id;

  LoadPetDetailEvent(this.id);
}
