import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/model/notification_model.dart';

abstract class NotificationRepository {
  Future<Either<Failure, NotificationResponseModel>> getNotifications();
  Future<Either<Failure, NotificationItemModel>> getNotificationById(String id);
  Future<Either<Failure, void>> deleteNotification(String id);
}
