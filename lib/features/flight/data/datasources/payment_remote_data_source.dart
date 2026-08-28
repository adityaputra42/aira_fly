import 'package:pss_app/core/network/network.dart';

import '../../../../core/constants/enpoint.dart';

abstract interface class PaymentRemoteDataSource {
  Future<ApiResponse?> createPayment({required int pnrId, String? channel, String? paymentMethod});

  Future<ApiResponse?> getPayment(int id);

  Future<ApiResponse?> getPaymentByPnr(int pnrId);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final DioClient dio = DioClient();

  @override
  Future<ApiResponse?> createPayment({
    required int pnrId,
    String? channel,
    String? paymentMethod,
  }) async {
    try {
      var body = <String, dynamic>{'pnr_id': pnrId};
      if (channel != null && channel.isNotEmpty) body['channel'] = channel;
      if (paymentMethod != null && paymentMethod.isNotEmpty) {
        body['payment_method'] = paymentMethod;
      }

      var response = await dio.post(Endpoint.payment, data: body);
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> getPayment(int id) async {
    try {
      var response = await dio.get('${Endpoint.payment}$id');
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> getPaymentByPnr(int pnrId) async {
    try {
      var response = await dio.get('${Endpoint.paymentPnr}$pnrId');
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }
}
