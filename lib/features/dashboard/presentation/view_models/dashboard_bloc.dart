import 'package:bloc/bloc.dart';
import 'package:petforpat/features/dashboard/domain/usecases/adopt_pet_usecase.dart';
import 'package:petforpat/features/dashboard/domain/usecases/get_pets_usecase.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_event.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetPetsUseCase getPets;
  final AdoptPetUseCase adoptPet;

  DashboardBloc({required this.getPets, required this.adoptPet}) : super(PetsLoading()) {
    on<FetchPets>((event, emit) async {
      emit(PetsLoading());
      try {
        final pets = await getPets(filters: event.filters ?? {});
        emit(PetsLoaded(pets));
      } catch (err) {
        emit(PetsError(err.toString()));
      }
    });

    on<AdoptRequested>((event, emit) async {
      try {
        await adoptPet(userId: event.userId, petId: event.petId);
        emit(PetAdopted(event.petId));
        add(FetchPets(filters: event.filters ?? {}));
      } catch (err) {
        emit(PetsError(err.toString()));
      }
    });

  }
}
