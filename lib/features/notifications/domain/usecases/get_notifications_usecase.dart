import '../../data/datasource/notifications_remote_datasource.dart';
import '../../data/models/notification_models.dart';

class GetNotificationsUseCase {
  final NotificationsRemoteDataSource remoteDataSource;

  const GetNotificationsUseCase({required this.remoteDataSource});

  Future<NotificationFeed> call() {
    return remoteDataSource.getNotifications();
  }
}
