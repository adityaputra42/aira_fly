import 'package:pss_app/features/notifications/domain/entities/notification_entity.dart';

List<NotificationModel> notificationModelFromJson(dynamic str) =>
    List<NotificationModel>.from((str).map((x) => NotificationModel.fromJson(x)));

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    super.body,
    super.createdAt,
    super.data,
    super.id,
    super.isRead,
    super.readAt,
    super.title,
    super.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    body: json["body"],
    createdAt: json["created_at"],
    data: json['data'],
    id: json["id"],
    isRead: json["is_read"],
    readAt: json["read_at"],
    title: json["title"],
    type: json["type"],
  );
}
