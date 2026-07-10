import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/model/notification_model.dart';

abstract class NotificationRepository {
  Future<Either<Failur, NotificationResponseModel>> getNotifications();
  Future<Either<Failur, NotificationItemModel>> getNotificationById(String id);
  Future<Either<Failur, void>> deleteNotification(String id);
}
