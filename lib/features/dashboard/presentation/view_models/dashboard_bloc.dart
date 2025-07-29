
import 'package:bloc/bloc.dart';
import 'package:petforpat/features/dashboard/domain/usecases/get_pet_usecase.dart';
import 'package:petforpat/features/dashboard/domain/usecases/get_pets_usecase.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_event.dart';
import 'package:petforpat/features/dashboard/presentation/view_models/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetPetsUseCase getPetsUseCase;

  DashboardBloc(this.getPetsUseCase) : super(DashboardInitial()) {
    on<LoadPetsEvent>(_onLoadPets);
  }

  Future<void> _onLoadPets(
      LoadPetsEvent event,
      Emitter<DashboardState> emit,
      ) async {
    emit(DashboardLoading());
    try {
      final pets = await getPetsUseCase.call(
        search: event.search,
        category: event.category,
        forceRefresh: event.forceRefresh,
      );
      emit(DashboardLoaded(pets));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
