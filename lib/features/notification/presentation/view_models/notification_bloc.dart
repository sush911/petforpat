import 'package:bloc/bloc.dart';
import 'package:petforpat/features/notification/domain/usecases/get_notification_usecase.dart';
import 'package:petforpat/features/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_event.dart';
import 'package:petforpat/features/notification/presentation/view_models/notification_state.dart';
import 'package:petforpat/features/notification/data/models/notification_model.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotifications;
  final DeleteNotificationUseCase deleteNotification;

  NotificationBloc(this.getNotifications, this.deleteNotification) : super(NotificationInitial()) {
    on<LoadNotifications>((event, emit) async {
      emit(NotificationLoading());

      try {
        final notifs = await getNotifications(event.userId);
        emit(NotificationLoaded(notifs));
      } catch (e) {
        emit(NotificationError('Failed to load notifications'));
      }
    });

    on<NewNotificationReceived>((event, emit) {
      if (state is NotificationLoaded) {
        final current = (state as NotificationLoaded).notifications;
        final updated = [event.notification.toEntity(), ...current];
        emit(NotificationLoaded(updated));
      }
    });

    on<DeleteNotification>((event, emit) async {
      if (state is NotificationLoaded) {
        try {
          await deleteNotification(event.notificationId);
          final current = (state as NotificationLoaded).notifications;
          final updated = current.where((n) => n.id != event.notificationId).toList();
          emit(NotificationLoaded(updated));
        } catch (e) {
          emit(NotificationError('Failed to delete notification'));
        }
      }
    });
  }
}
