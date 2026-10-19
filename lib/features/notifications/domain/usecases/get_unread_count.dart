
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/notification_repository.dart';

class GetUnreadCount
    implements UseCase<int, CancelToken?> {
  final NotificationRepository repository;

  const GetUnreadCount(this.repository);

  @override
  Future<Either<Failure, int>> call(
    CancelToken? cancelToken
      ) {
    return repository.getUnreadNotificationCount(
      cancelToken: cancelToken,

    );
  }
}
