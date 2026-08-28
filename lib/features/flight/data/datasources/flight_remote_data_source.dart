import 'package:pss_app/core/network/network.dart';

import '../../../../core/constants/enpoint.dart';

abstract interface class FlightRemoteDataSource {
  Future<ApiResponse?> getAirports({int page = 1, int limit = 20});

  Future<ApiResponse?> searchFlights({
    required int departureAirportId,
    required int arrivalAirportId,
    required String date,
    String tripType = 'one_way',
    String? returnDate,
    int? maxStops,
    required int totalPax,
    int? seatClassId,
    int page = 1,
    int limit = 10,
  });

  Future<ApiResponse?> getFlightSeats(int flightId);
}

class FlightRemoteDataSourceImpl implements FlightRemoteDataSource {
  final DioClient dio = DioClient();

  @override
  Future<ApiResponse?> getAirports({int page = 1, int limit = 20}) async {
    try {
      var response = await dio.get(
        Endpoint.getAirport,
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
  Future<ApiResponse?> searchFlights({
    required int departureAirportId,
    required int arrivalAirportId,
    required String date,
    String tripType = 'one_way',
    String? returnDate,
    int? maxStops,
    required int totalPax,
    int? seatClassId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      var query = <String, dynamic>{
        'departure_airport_id': departureAirportId,
        'arrival_airport_id': arrivalAirportId,
        'date': date,
        'trip_type': tripType,
        'total_pax': totalPax,
        'page': page,
        'limit': limit,
      };
      if (returnDate != null) query['return_date'] = returnDate;
      if (maxStops != null) query['max_stops'] = maxStops;
      if (seatClassId != null) query['seat_class_id'] = seatClassId;

      var response = await dio.get(Endpoint.flightSearch, queryParameters: query);
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> getFlightSeats(int flightId) async {
    try {
      var response = await dio.get('${Endpoint.flightInstances}$flightId/seats');
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }
}
