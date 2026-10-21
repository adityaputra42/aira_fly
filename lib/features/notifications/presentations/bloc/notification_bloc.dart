import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pss_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:pss_app/features/notifications/domain/usecases/get_list_notification.dart';
import 'package:pss_app/features/notifications/domain/usecases/get_unread_count.dart';
import 'package:pss_app/features/notifications/domain/usecases/read_all_notification.dart';
import 'package:pss_app/features/notifications/domain/usecases/read_notification_by_id.dart';
import 'package:pss_app/features/notifications/domain/usecases/register_device.dart';
import 'package:pss_app/features/notifications/domain/usecases/unregister_device.dart';

import '../utils/notification_helper.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  static const int _pageSize = 20;

  final GetListNotification _getList;
  final GetUnreadCount _getUnreadCount;
  final ReadAllNotification _readAll;
  final ReadNotificationById _readById;
  final RegisterDevice _registerDevice;
  final UnregisterDevice _unregisterDevice;
  final NotificationHelper _helper;

  StreamSubscription<dynamic>? _pushSub;

  NotificationBloc({
    required this._getList,
    required this._getUnreadCount,
    required this._readAll,
    required this._readById,
    required this._registerDevice,
    required this._unregisterDevice,
    required this._helper,
  }) : super(const NotificationState()) {
    on<NotificationRefreshed>(_onRefreshed);
    on<NotificationLoadedMore>(_onLoadedMore);
    on<NotificationUnreadCountRequested>(_onUnreadCount);
    on<NotificationReadRequested>(_onRead);
    on<NotificationReadAllRequested>(_onReadAll);
    on<NotificationDeviceRegistered>(_onDeviceRegistered);
    on<NotificationDeviceUnregistered>(_onDeviceUnregistered);
    on<NotificationReset>((_, emit) => emit(const NotificationState()));

    // Push masuk saat app foreground -> segarkan list & badge.
    _pushSub = _helper.onMessageStream.listen((_) => add(const NotificationRefreshed()));
  }

  Future<void> _onRefreshed(NotificationRefreshed event, Emitter<NotificationState> emit) async {
    final silent = state.items.isNotEmpty;
    if (!silent) emit(state.copyWith(status: NotificationStatus.loading, clearError: true));

    final result = await _getList(const ListNotificationParams(page: 1, limit: _pageSize));
    result.fold(
      (f) => emit(
        state.copyWith(
          status: silent ? state.status : NotificationStatus.failure,
          errorMessage: f.message,
        ),
      ),
      (items) => emit(
        state.copyWith(
          status: NotificationStatus.success,
          items: items,
          page: 1,
          hasReachedMax: items.length < _pageSize,
          clearError: true,
        ),
      ),
    );

    await _fetchUnread(emit);
  }

  Future<void> _onLoadedMore(NotificationLoadedMore event, Emitter<NotificationState> emit) async {
    if (state.isLoadingMore || state.hasReachedMax || state.status != NotificationStatus.success) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.page + 1;
    final result = await _getList(ListNotificationParams(page: nextPage, limit: _pageSize));
    result.fold(
      (f) => emit(state.copyWith(isLoadingMore: false, errorMessage: f.message)),
      (items) => emit(
        state.copyWith(
          isLoadingMore: false,
          items: [...state.items, ...items],
          page: nextPage,
          hasReachedMax: items.length < _pageSize,
        ),
      ),
    );
  }

  Future<void> _onUnreadCount(
    NotificationUnreadCountRequested event,
    Emitter<NotificationState> emit,
  ) => _fetchUnread(emit);

  Future<void> _fetchUnread(Emitter<NotificationState> emit) async {
    final result = await _getUnreadCount(null);
    result.fold((_) {}, (count) => emit(state.copyWith(unreadCount: count)));
  }

  Future<void> _onRead(NotificationReadRequested event, Emitter<NotificationState> emit) async {
    final idx = state.items.indexWhere((e) => e.id == event.id);
    if (idx != -1 && state.items[idx].isRead == true) return;

    // Optimistic update.
    final previous = state;
    if (idx != -1) {
      final updated = [...state.items];
      updated[idx] = updated[idx].copyWith(isRead: true);
      emit(
        state.copyWith(
          items: updated,
          unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
        ),
      );
    }

    final result = await _readById(ReadNotificationByIdParam(id: event.id));
    result.fold((f) => emit(previous.copyWith(errorMessage: f.message)), (_) {});
  }

  Future<void> _onReadAll(
    NotificationReadAllRequested event,
    Emitter<NotificationState> emit,
  ) async {
    if (state.unreadCount == 0 && state.items.every((e) => e.isRead == true)) return;

    final previous = state;
    emit(
      state.copyWith(
        items: state.items.map((e) => e.copyWith(isRead: true)).toList(),
        unreadCount: 0,
      ),
    );

    final result = await _readAll(null);
    result.fold((f) => emit(previous.copyWith(errorMessage: f.message)), (_) {});
  }

  Future<void> _onDeviceRegistered(
    NotificationDeviceRegistered event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _registerDevice(
      RegisterDeviceParam(
        fcmToken: event.fcmToken,
        deviceId: event.deviceId,
        appVersion: event.appVersion,
        platform: event.platform,
      ),
    );
    result.fold((f) => addError(f.message), (_) {});
  }

  Future<void> _onDeviceUnregistered(
    NotificationDeviceUnregistered event,
    Emitter<NotificationState> emit,
  ) async {
    await _unregisterDevice(UnregisterDeviceParam(fcmToken: event.fcmToken));
    emit(const NotificationState()); // reset state saat logout
  }

  @override
  Future<void> close() async {
    await _pushSub?.cancel();
    return super.close();
  }
}
