import 'package:equatable/equatable.dart';

/// Result of POST /checkin -- a newly issued boarding pass.
class CheckInResultEntity extends Equatable {
  final int? checkinId;
  final String? boardingPassNumber;
  final String? passengerName;
  final String? bookingCode;
  final String? flightNumber;
  final String? seatNumber;
  final DateTime? departureTime;
  final DateTime? boardingTime;

  /// Always empty for now -- the backend does not track gate assignment
  /// yet (see CheckInHandler.Create's doc comment).
  final String? gate;

  const CheckInResultEntity({
    this.checkinId,
    this.boardingPassNumber,
    this.passengerName,
    this.bookingCode,
    this.flightNumber,
    this.seatNumber,
    this.departureTime,
    this.boardingTime,
    this.gate,
  });

  @override
  List<Object?> get props => [
    checkinId,
    boardingPassNumber,
    passengerName,
    bookingCode,
    flightNumber,
    seatNumber,
    departureTime,
    boardingTime,
    gate,
  ];
}

/// GET /checkin/boarding-pass?passenger_id=&segment_id= result.
class BoardingPassEntity extends Equatable {
  final int? checkinId;
  final String? boardingPassNumber;
  final String? boardingGroup;
  final String? gate;
  final DateTime? boardingTime;
  final String? status;
  final int? baggageCount;
  final DateTime? checkedInAt;

  const BoardingPassEntity({
    this.checkinId,
    this.boardingPassNumber,
    this.boardingGroup,
    this.gate,
    this.boardingTime,
    this.status,
    this.baggageCount,
    this.checkedInAt,
  });

  @override
  List<Object?> get props => [
    checkinId,
    boardingPassNumber,
    boardingGroup,
    gate,
    boardingTime,
    status,
    baggageCount,
    checkedInAt,
  ];
}
