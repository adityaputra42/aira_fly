part of 'notification_bloc.dart';

enum NotificationStatus { initial, loading, success, failure }

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<NotificationEntity> items;
  final int unreadCount;
  final int page;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String? errorMessage;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.items = const [],
    this.unreadCount = 0,
    this.page = 1,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationEntity>? items,
    int? unreadCount,
    int? page,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
  }) => NotificationState(
    status: status ?? this.status,
    items: items ?? this.items,
    unreadCount: unreadCount ?? this.unreadCount,
    page: page ?? this.page,
    hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
  );

  @override
  List<Object?> get props =>
      [status, items, unreadCount, page, hasReachedMax, isLoadingMore, errorMessage];
}
