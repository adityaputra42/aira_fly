import '../../domain/entities/ticket_entity.dart';

/// Maps `checkInResponse` from POST /checkin (snake_case json tags).
class CheckInResultModel extends CheckInResultEntity {
  const CheckInResultModel({
    super.checkinId,
    super.boardingPassNumber,
    super.passengerName,
    super.bookingCode,
    super.flightNumber,
    super.seatNumber,
    super.departureTime,
    super.boardingTime,
    super.gate,
  });

  factory CheckInResultModel.fromJson(Map<String, dynamic> json) {
    return CheckInResultModel(
      checkinId: json['checkin_id'] as int?,
      boardingPassNumber: json['boarding_pass_number'] as String?,
      passengerName: json['passenger_name'] as String?,
      bookingCode: json['booking_code'] as String?,
      flightNumber: json['flight_number'] as String?,
      seatNumber: json['seat_number'] as String?,
      departureTime: json['departure_time'] == null
          ? null
          : DateTime.tryParse(json['departure_time']),
      boardingTime: json['boarding_time'] == null
          ? null
          : DateTime.tryParse(json['boarding_time']),
      gate: json['gate'] as String?,
    );
  }
}

/// Maps `appquery.BoardingPassView` from GET /checkin/boarding-pass.
/// This Go struct has NO json tags, so it serializes using the raw
/// (capitalized) field names -- unlike checkInResponse above.
class BoardingPassModel extends BoardingPassEntity {
  const BoardingPassModel({
    super.checkinId,
    super.boardingPassNumber,
    super.boardingGroup,
    super.gate,
    super.boardingTime,
    super.status,
    super.baggageCount,
    super.checkedInAt,
  });

  factory BoardingPassModel.fromJson(Map<String, dynamic> json) {
    return BoardingPassModel(
      checkinId: json['CheckinID'] as int?,
      boardingPassNumber: json['BoardingPassNumber'] as String?,
      boardingGroup: json['BoardingGroup'] as String?,
      gate: json['Gate'] as String?,
      boardingTime: json['BoardingTime'] == null
          ? null
          : DateTime.tryParse(json['BoardingTime']),
      status: json['Status'] as String?,
      baggageCount: json['BaggageCount'] as int?,
      checkedInAt: json['CheckedInAt'] == null
          ? null
          : DateTime.tryParse(json['CheckedInAt']),
    );
  }
}
