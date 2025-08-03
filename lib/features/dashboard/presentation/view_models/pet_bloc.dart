import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/features/dashboard/domain/usecases/get_pets_usecase.dart';
import 'package:petforpat/features/dashboard/domain/usecases/get_pet_usecase.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_event.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/pet_state.dart';

/// Bloc for listing pets
class PetBloc extends Bloc<PetEvent, PetState> {
  final GetPetsUseCase getPetsUseCase;

  PetBloc({required this.getPetsUseCase}) : super(PetInitial()) {
    on<LoadPetsEvent>((event, emit) async {
      emit(PetLoading());
      try {
        final pets = await getPetsUseCase(
          search: event.search,
          category: event.category,
          forceRefresh: event.forceRefresh,
        );
        emit(PetLoaded(pets));
      } catch (e) {
        emit(PetError(e.toString()));
      }
    });
  }
}

/// Bloc for showing a single pet's detail
class PetDetailBloc extends Bloc<PetDetailEvent, PetDetailState> {
  final GetPetUseCase getPetUseCase;

  PetDetailBloc({required this.getPetUseCase}) : super(PetDetailInitial()) {
    on<LoadPetDetailEvent>((event, emit) async {
      emit(PetDetailLoading());
      try {
        final pet = await getPetUseCase(event.id);
        emit(PetDetailLoaded(pet));
      } catch (e) {
        emit(PetDetailError(e.toString()));
      }
    });
  }
}
