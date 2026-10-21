part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

/// Pull-to-refresh / first load: list page 1 + unread count.
final class NotificationRefreshed extends NotificationEvent {
  const NotificationRefreshed();
}

final class NotificationReset extends NotificationEvent {
  const NotificationReset();
}

final class NotificationLoadedMore extends NotificationEvent {
  const NotificationLoadedMore();
}

/// Badge only (e.g. on home screen), without loading the list.
final class NotificationUnreadCountRequested extends NotificationEvent {
  const NotificationUnreadCountRequested();
}

final class NotificationReadRequested extends NotificationEvent {
  final int id;
  const NotificationReadRequested(this.id);

  @override
  List<Object?> get props => [id];
}

final class NotificationReadAllRequested extends NotificationEvent {
  const NotificationReadAllRequested();
}

final class NotificationDeviceRegistered extends NotificationEvent {
  final String fcmToken;
  final String? deviceId;
  final String? appVersion;
  final String? platform;

  const NotificationDeviceRegistered({
    required this.fcmToken,
    this.deviceId,
    this.appVersion,
    this.platform,
  });

  @override
  List<Object?> get props => [fcmToken, deviceId, appVersion, platform];
}

final class NotificationDeviceUnregistered extends NotificationEvent {
  final String? fcmToken;
  const NotificationDeviceUnregistered(this.fcmToken);

  @override
  List<Object?> get props => [fcmToken];
}
