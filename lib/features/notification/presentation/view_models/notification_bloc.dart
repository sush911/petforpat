
import 'package:bloc/bloc.dart';
import 'package:petforpat/features/notification/domain/usecases/get_notification_usecase.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_event.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotifications;

  NotificationBloc(this.getNotifications) : super(NotificationInitial()) {
    on<LoadNotifications>((event, emit) async {
      emit(NotificationLoading());

      try {
        final notifs = await getNotifications(event.userId);
        emit(NotificationLoaded(notifs));
      } catch (e) {
        emit(NotificationError('Failed to load notifications'));
      }
    });
  }
}
