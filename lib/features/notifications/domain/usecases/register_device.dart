import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pss_app/features/notifications/domain/repository/notification_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

class RegisterDevice implements UseCase<void, RegisterDeviceParam> {
  final NotificationRepository repository;

  const RegisterDevice(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterDeviceParam param) {
    return repository.registerDevice(
      cancelToken: param.cancelToken,
      appVersion: param.appVersion,
      deviceId: param.deviceId,
      fcmToken: param.fcmToken,
      platform: param.platform,
    );
  }
}

class RegisterDeviceParam {
  final CancelToken? cancelToken;
  final String? appVersion;
  final String? deviceId;
  final String? fcmToken;
  final String? platform;

  const RegisterDeviceParam({
    this.cancelToken,
    this.appVersion,
    this.deviceId,
    this.fcmToken,
    this.platform,
  });
}
