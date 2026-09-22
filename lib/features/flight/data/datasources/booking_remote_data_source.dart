import 'package:pss_app/core/network/network.dart';

import '../../../../core/constants/enpoint.dart';

abstract interface class BookingRemoteDataSource {
  Future<ApiResponse?> createPnr(Map<String, dynamic> body);

  Future<ApiResponse?> getPnr(int id);

  Future<ApiResponse?> listPnrs({int page, int limit, String? status});

  /// GET /bookings/pnrs/mine -- login required. Always scoped to the
  /// caller's own bookings (resolved server-side from the auth token,
  /// never from a parameter), unlike [listPnrs] which is the admin-only
  /// "everyone's bookings" endpoint.
  Future<ApiResponse?> listMyPnrs({int page, int limit, String? status});

  /// GET /bookings/pnrs/mine/{code} -- public, no login required. See
  /// the doc comment on BookingRepository.getPnrByBookingCode for a
  /// real gap between what this endpoint's backend doc claims
  /// ("restricted to the authenticated caller, guest bookings excluded")
  /// and what it actually enforces (nothing -- the ownership check is
  /// commented out server-side). Don't remove that warning when editing
  /// this file; it's there so nobody "cleans up" the caller-facing UI
  /// assuming a safety net that isn't there yet.
  Future<ApiResponse?> getPnrByBookingCode(String bookingCode);

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
      // NOTE: was '${Endpoint.pnr}$id' -- Endpoint.pnr has no trailing
      // slash, so that built "bookings/pnrs5" instead of
      // "bookings/pnrs/5" and would have 404'd against the real API the
      // moment this admin path was actually exercised. Fixed here.
      var response = await dio.get('${Endpoint.pnr}/$id');
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
  Future<ApiResponse?> listMyPnrs({int page = 1, int limit = 10, String? status}) async {
    try {
      var query = <String, dynamic>{'page': page, 'limit': limit};
      if (status != null && status.isNotEmpty) query['status'] = status;
      var response = await dio.get('${Endpoint.pnr}/mine', queryParameters: query);
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> getPnrByBookingCode(String bookingCode) async {
    try {
      var response = await dio.get('${Endpoint.pnr}/mine/$bookingCode');
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
      var response = await dio.post('${Endpoint.pnr}/$id/cancel');
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }
}
