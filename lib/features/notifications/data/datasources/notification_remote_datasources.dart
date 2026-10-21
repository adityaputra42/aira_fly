import 'package:dio/dio.dart';

import '../../../../core/constants/enpoint.dart';
import '../../../../core/network/network.dart';

abstract interface class NotificationRemoteDataSource {
  Future<ApiResponse?> registerDevice({
    CancelToken? cancelToken,
    String? appVersion,
    deviceId,
    fcmToken,
    platform,
  });
  Future<ApiResponse?> unregisterDevice({CancelToken? cancelToken, String? fcmToken});
  Future<ApiResponse?> listNotifications({CancelToken? cancelToken, int? page, int? limit});
  Future<ApiResponse?> readAllNotification({CancelToken? cancelToken});
  Future<ApiResponse?> readById({CancelToken? cancelToken, required int id});
  Future<ApiResponse?> getUnreadNotificationCount({CancelToken? cancelToken});
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final DioClient dio = DioClient();

  @override
  Future<ApiResponse?> getUnreadNotificationCount({CancelToken? cancelToken}) async {
    try {
      var response = await dio.get(Endpoint.notificationsUnreadCount);
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> listNotifications({CancelToken? cancelToken, int? page, int? limit}) async {
    try {
      var response = await dio.get(
        Endpoint.notifications,
        queryParameters: {"page": page, "limit": limit},
      );
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> readAllNotification({CancelToken? cancelToken}) async {
    try {
      var response = await dio.post(Endpoint.notificationsReadAll, data: {});
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> readById({CancelToken? cancelToken, required int id}) async {
    try {
      var response = await dio.patch("${Endpoint.notifications}/$id/${Endpoint.readNotifById}");
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> registerDevice({
    CancelToken? cancelToken,
    String? appVersion,
    deviceId,
    fcmToken,
    platform,
  }) async {
    try {
      var param = {
        "app_version": appVersion,
        "device_id": deviceId,
        "fcm_token": fcmToken,
        "platform": platform,
      };
      var response = await dio.post(Endpoint.registerDevice, data: param);
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> unregisterDevice({CancelToken? cancelToken, String? fcmToken}) async {
    try {
      var response = await dio.post(Endpoint.unregisterDevice, data: {"fcm_token": fcmToken});
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }
}
