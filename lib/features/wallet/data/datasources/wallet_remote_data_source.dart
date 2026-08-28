import 'package:pss_app/core/network/network.dart';

import '../../../../core/constants/enpoint.dart';

abstract interface class WalletRemoteDataSource {
  Future<ApiResponse?> getBalance();

  Future<ApiResponse?> listTransactions({int page, int limit});

  Future<ApiResponse?> topup({required double amount, String? channel});

  Future<ApiResponse?> getTopup(String code);
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final DioClient dio = DioClient();

  @override
  Future<ApiResponse?> getBalance() async {
    try {
      var response = await dio.get(Endpoint.walletBalance);
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> listTransactions({int page = 1, int limit = 10}) async {
    try {
      var response = await dio.get(
        Endpoint.walletTransaction,
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
  Future<ApiResponse?> topup({required double amount, String? channel}) async {
    try {
      var body = <String, dynamic>{'amount': amount};
      if (channel != null && channel.isNotEmpty) body['channel'] = channel;

      var response = await dio.post(Endpoint.walletTopup, data: body);
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> getTopup(String code) async {
    try {
      var response = await dio.get('${Endpoint.walletTopup}$code');
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }
}
