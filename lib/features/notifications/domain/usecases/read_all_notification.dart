
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/notification_entity.dart';
import '../repository/notification_repository.dart';

class ReadAllNotification
    implements UseCase<List<NotificationEntity>, CancelToken?> {
  final NotificationRepository repository;

  const ReadAllNotification(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
      CancelToken? cancelToken,
      ) {
    return repository.readAllNotification(
      cancelToken: cancelToken,

    );
  }
}
