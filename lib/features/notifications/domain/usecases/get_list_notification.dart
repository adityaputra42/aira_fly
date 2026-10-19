import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pss_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:pss_app/features/notifications/domain/repository/notification_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

class GetListNotification
    implements UseCase<List<NotificationEntity>, ListNotificationParams> {
  final NotificationRepository repository;

  const GetListNotification(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
    ListNotificationParams params,
  ) {
    return repository.listNotifications(
      cancelToken: params.cancelToken,
      page: params.page,
      limit: params.limit,
    );
  }
}

class ListNotificationParams {
  final CancelToken? cancelToken;
  final int? page;
  final int? limit;

  const ListNotificationParams({this.cancelToken, this.limit, this.page});
}
