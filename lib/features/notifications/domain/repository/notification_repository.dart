import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pss_app/features/notifications/domain/entities/notification_entity.dart';

import '../../../../core/error/failures.dart';

abstract interface class NotificationRepository {

  Future<Either<Failure, void>> registerDevice({
    CancelToken? cancelToken,
    String? appVersion,
    deviceId,
    fcmToken,
    platform,
  });
  Future<Either<Failure, void>> unregisterDevice({CancelToken? cancelToken, String? fcmToken});
  Future<Either<Failure, List<NotificationEntity>>> listNotifications({CancelToken? cancelToken, int? page, int? limit});
  Future<Either<Failure, List<NotificationEntity>>> readAllNotification({CancelToken? cancelToken});
  Future<Either<Failure, NotificationEntity>> readById({CancelToken? cancelToken, required int id});
  Future<Either<Failure, int>> getUnreadNotificationCount({CancelToken? cancelToken});

}
