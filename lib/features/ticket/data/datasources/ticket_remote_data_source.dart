import 'package:pss_app/core/network/network.dart';

import '../../../../core/constants/enpoint.dart';

abstract interface class TicketRemoteDataSource {
  Future<ApiResponse?> checkIn({
    required String ticketNumber,
    int? baggageCount,
    String? baggageWeightKg,
  });

  Future<ApiResponse?> getBoardingPass({required int passengerId, required int segmentId});
}

class TicketRemoteDataSourceImpl implements TicketRemoteDataSource {
  final DioClient dio = DioClient();

  @override
  Future<ApiResponse?> checkIn({
    required String ticketNumber,
    int? baggageCount,
    String? baggageWeightKg,
  }) async {
    try {
      var body = <String, dynamic>{'ticket_number': ticketNumber};
      if (baggageCount != null) body['baggage_count'] = baggageCount;
      if (baggageWeightKg != null && baggageWeightKg.isNotEmpty) {
        body['baggage_weight_kg'] = baggageWeightKg;
      }

      var response = await dio.post(Endpoint.checkin, data: body);
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> getBoardingPass({required int passengerId, required int segmentId}) async {
    try {
      var response = await dio.get(
        Endpoint.boardingPass,
        queryParameters: {'passenger_id': passengerId, 'segment_id': segmentId},
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
