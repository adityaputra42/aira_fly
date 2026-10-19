import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String? body;
  final String? createdAt;
  final Map<String, dynamic>? data;
  final int? id;
  final bool? isRead;
  final String? readAt;
  final String? title;
  final String? type;

  const NotificationEntity({
    this.body,
    this.createdAt,
    this.data,
    this.id,
    this.isRead,
    this.readAt,
    this.title,
    this.type,
  });

  @override
  List<Object?> get props => [body, createdAt, data, id, isRead, readAt, title, type];
}
