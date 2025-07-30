import 'package:bloc/bloc.dart';
import 'package:petforpat/features/adoption/domain/usecases/submit_adoption_request.dart';
import 'package:petforpat/features/adoption/presentation/view_models/adoption_event.dart';
import 'package:petforpat/features/adoption/presentation/view_models/adoption_state.dart';

class AdoptionBloc extends Bloc<AdoptionEvent, AdoptionState> {
  final SubmitAdoptionRequestUseCase useCase;

  AdoptionBloc(this.useCase) : super(AdoptionInitial()) {
    on<SubmitAdoptionEvent>((event, emit) async {
      emit(AdoptionLoading());
      try {
        await useCase(event.request);
        emit(AdoptionSuccess());
      } catch (e) {
        emit(AdoptionError(e.toString()));
      }
    });
  }
}
