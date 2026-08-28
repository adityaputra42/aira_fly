import 'package:pss_app/core/network/network.dart';

import '../../../../core/constants/enpoint.dart';

abstract interface class BookingRemoteDataSource {
  Future<ApiResponse?> createPnr(Map<String, dynamic> body);

  Future<ApiResponse?> getPnr(int id);

  Future<ApiResponse?> listPnrs({int page, int limit, String? status});

  Future<ApiResponse?> cancelPnr(int id);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final DioClient dio = DioClient();

  @override
  Future<ApiResponse?> createPnr(Map<String, dynamic> body) async {
    try {
      var response = await dio.post(Endpoint.pnr, data: body);
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> getPnr(int id) async {
    try {
      var response = await dio.get('${Endpoint.pnr}$id');
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> listPnrs({int page = 1, int limit = 10, String? status}) async {
    try {
      var query = <String, dynamic>{'page': page, 'limit': limit};
      if (status != null && status.isNotEmpty) query['status'] = status;
      var response = await dio.get(Endpoint.pnr, queryParameters: query);
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> cancelPnr(int id) async {
    try {
      var response = await dio.post('${Endpoint.pnr}$id/cancel');
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }
}
