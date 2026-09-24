import 'package:pss_app/core/network/network.dart';

import '../../../../core/constants/enpoint.dart';

abstract interface class SeatClassRemoteDataSource {
  Future<ApiResponse?> getSeatClasses({int page = 1, int limit = 200});
}

class SeatClassRemoteDataSourceImpl implements SeatClassRemoteDataSource {
  final DioClient dio = DioClient();

  @override
  Future<ApiResponse?> getSeatClasses({int page = 1, int limit = 200}) async {
    try {
      var response = await dio.get(
        Endpoint.getSearClasses,
        queryParameters: {'page': page, 'limit': limit},
      );
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }
}
