import 'package:drever_warr/features/home/preasntaion/data/cubit/cubit_notification/cubit_stat.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/repo/repo_notification/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository notificationRepository;

  NotificationCubit(this.notificationRepository) : super(NotificationInitial());

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    var result = await notificationRepository.getNotifications();
    result.fold(
      (failure) => emit(NotificationFailure(failure.errMassage)),
      (data) => emit(NotificationSuccess(data)),
    );
  }

  Future<void> fetchNotificationById(String id) async {
    emit(NotificationDetailLoading());
    var result = await notificationRepository.getNotificationById(id);
    result.fold(
      (failure) => emit(NotificationDetailFailure(failure.errMassage)),
      (item) => emit(NotificationDetailSuccess(item)),
    );
  }

  Future<void> deleteNotification(String id) async {
    var result = await notificationRepository.deleteNotification(id);
    result.fold(
      (failure) => emit(NotificationDeleteFailure(failure.errMassage)),
      (_) => emit(NotificationDeleteSuccess(id)),
    );
  }
}
