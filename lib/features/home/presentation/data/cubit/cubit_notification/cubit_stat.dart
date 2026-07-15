import 'package:drever_warr/features/home/presentation/data/cubit/model/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final NotificationResponseModel data;
  NotificationSuccess(this.data);
}

class NotificationFailure extends NotificationState {
  final String errMessage;
  NotificationFailure(this.errMessage);
}

class NotificationDetailLoading extends NotificationState {}

class NotificationDetailSuccess extends NotificationState {
  final NotificationItemModel item;
  NotificationDetailSuccess(this.item);
}

class NotificationDetailFailure extends NotificationState {
  final String errMessage;
  NotificationDetailFailure(this.errMessage);
}

class NotificationDeleteSuccess extends NotificationState {
  final String deletedId;
  NotificationDeleteSuccess(this.deletedId);
}

class NotificationDeleteFailure extends NotificationState {
  final String errMessage;
  NotificationDeleteFailure(this.errMessage);
}
