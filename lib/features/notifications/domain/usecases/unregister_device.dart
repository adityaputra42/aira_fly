import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pss_app/features/notifications/domain/repository/notification_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

class UnregisterDevice implements UseCase<void, UnregisterDeviceParam> {
  final NotificationRepository repository;

  const UnregisterDevice(this.repository);

  @override
  Future<Either<Failure, void>> call(UnregisterDeviceParam param) {
    return repository.unregisterDevice(
      cancelToken: param.cancelToken,
      fcmToken: param.fcmToken,
    );
  }
}

class UnregisterDeviceParam {
  final CancelToken? cancelToken;

  final String? fcmToken;

  const UnregisterDeviceParam({
    this.cancelToken,
    this.fcmToken,
  });
}
