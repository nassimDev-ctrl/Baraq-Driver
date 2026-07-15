import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/api_service.dart';
import 'package:drever_warr/core/service/failure.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/model/notification_model.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/repo/repo_notification/repo.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final ApiService apiService;

  NotificationRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, NotificationResponseModel>> getNotifications() async {
    try {
      var response = await apiService.get(
        endpoint: 'notifications/user',
        needToken: true,
      );

      final data = NotificationResponseModel.fromJson(response.data);
      return right(data);
    } catch (e) {
      return left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, NotificationItemModel>> getNotificationById(String id) async {
    try {
      var response = await apiService.get(
        endpoint: 'notifications/$id',
        needToken: true,
      );

      final item = NotificationItemModel.fromJson(response.data['notification']);
      return right(item);
    } catch (e) {
      return left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String id) async {
    try {
      await apiService.delete(
        'notifications/delete/$id',
        needToken: true,
      );
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString(), 500));
    }
  }
}
