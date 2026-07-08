import '../models/notification_models.dart';

abstract class NotificationsRemoteDataSource {
  Future<NotificationFeed> getNotifications();
}
