import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pss_app/core/error/failures.dart';
import 'package:pss_app/features/notifications/data/datasources/notification_remote_datasources.dart';
import 'package:pss_app/features/notifications/data/models/notification_model.dart';
import 'package:pss_app/features/notifications/domain/entities/notification_entity.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/connection_checker.dart';
import '../../domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  const NotificationRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, int>> getUnreadNotificationCount({CancelToken? cancelToken}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.getUnreadNotificationCount();
      if (response == null) {
        return left(Failure('Failed to load country list'));
      }
var data = response.data['unread_count'];
      return right(data as int);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> listNotifications({
    CancelToken? cancelToken,
    int? page,
    int? limit,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.listNotifications(
        cancelToken: cancelToken,
        page: page,
        limit: limit,
      );
      if (response == null) {
        return left(Failure('Failed to load country list'));
      }

      final items = notificationModelFromJson(response.data['items']);
      return right(items);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> readAllNotification({
    CancelToken? cancelToken,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.readAllNotification(cancelToken: cancelToken);
      if (response == null) {
        return left(Failure('Failed to load country list'));
      }

      return right([]);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> readById({
    CancelToken? cancelToken,
    required int id,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.readById(cancelToken: cancelToken, id: id);
      if (response == null) {
        return left(Failure('Failed to load country list'));
      }

      final item = NotificationModel.fromJson(response.data);
      return right(item);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerDevice({
    CancelToken? cancelToken,
    String? appVersion,
    deviceId,
    fcmToken,
    platform,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.registerDevice(
        cancelToken: cancelToken,
        appVersion: appVersion,
        deviceId: deviceId,
        fcmToken: fcmToken,
        platform: platform,
      );
      if (response == null) {
        return left(Failure('Failed to load country list'));
      }

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unregisterDevice({
    CancelToken? cancelToken,
    String? fcmToken,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }

      final response = await remoteDataSource.unregisterDevice(
        cancelToken: cancelToken,
        fcmToken: fcmToken,
      );
      if (response == null) {
        return left(Failure('Failed to load country list'));
      }

      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
