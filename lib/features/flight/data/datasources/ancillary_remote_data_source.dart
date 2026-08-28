import 'package:pss_app/core/network/network.dart';

import '../../../../core/constants/enpoint.dart';

abstract interface class AncillaryRemoteDataSource {
  Future<ApiResponse?> listCategories({int page, int limit});

  Future<ApiResponse?> listCatalog({int? categoryId, bool activeOnly, int page, int limit});

  Future<ApiResponse?> getAncillary(int id);

  Future<ApiResponse?> listByFlight(int flightId);

  Future<ApiResponse?> purchase(Map<String, dynamic> body);

  Future<ApiResponse?> cancelPurchase(int id);

  Future<ApiResponse?> listPurchasesByPnr(int pnrId);
}

class AncillaryRemoteDataSourceImpl implements AncillaryRemoteDataSource {
  final DioClient dio = DioClient();

  @override
  Future<ApiResponse?> listCategories({int page = 1, int limit = 10}) async {
    try {
      var response = await dio.get(
        Endpoint.getAncillariesCategory,
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

  @override
  Future<ApiResponse?> listCatalog({
    int? categoryId,
    bool activeOnly = true,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      var query = <String, dynamic>{'active_only': activeOnly, 'page': page, 'limit': limit};
      if (categoryId != null) query['category_id'] = categoryId;

      var response = await dio.get(Endpoint.getAncillariesCategory, queryParameters: query);
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> getAncillary(int id) async {
    try {
      var response = await dio.get('${Endpoint.getAncillaryById}$id');
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> listByFlight(int flightId) async {
    try {
      var response = await dio.get('${Endpoint.getAncillariesForFlight}$flightId');
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> purchase(Map<String, dynamic> body) async {
    try {
      var response = await dio.post(Endpoint.ancillariesPurchase, data: body);
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> cancelPurchase(int id) async {
    try {
      var response = await dio.post('${Endpoint.ancillariesPurchase}$id/cancel');
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> listPurchasesByPnr(int pnrId) async {
    try {
      var response = await dio.get('${Endpoint.getAncillariesPurchaseByPnr}$pnrId');
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }
}
