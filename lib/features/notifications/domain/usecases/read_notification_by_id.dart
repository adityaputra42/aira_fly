import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pss_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:pss_app/features/notifications/domain/repository/notification_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

class ReadNotificationById
    implements UseCase<NotificationEntity, ReadNotificationByIdParam> {
  final NotificationRepository repository;

  const ReadNotificationById(this.repository);

  @override
  Future<Either<Failure, NotificationEntity>> call(
      ReadNotificationByIdParam param,
      ) {
    return repository.readById(
      cancelToken: param.cancelToken,
      id: param.id,
    );
  }
}

class ReadNotificationByIdParam {
  final CancelToken? cancelToken;
  final int id;

  const ReadNotificationByIdParam({this.cancelToken, required this.id});
}
