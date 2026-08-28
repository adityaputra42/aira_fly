import '../../domain/entities/flight_seat_entity.dart';

/// Maps GET /flights/instances/{id}/seats item shape
/// (`ListFlightSeatsWithLayoutByFlightIDRow`, snake_case json tags).
class FlightSeatModel extends FlightSeatEntity {
  const FlightSeatModel({
    super.id,
    super.flightId,
    super.status,
    super.seatNumber,
    super.rowNumber,
    super.seatLetter,
    super.seatClassId,
    super.seatType,
    super.isExitRow,
  });

  factory FlightSeatModel.fromJson(Map<String, dynamic> json) {
    return FlightSeatModel(
      id: json['id'] as int?,
      flightId: json['flight_id'] as int?,
      status: json['status'] as String?,
      seatNumber: json['seat_number'] as String?,
      rowNumber: json['row_number'] as int?,
      seatLetter: json['seat_letter'] as String?,
      seatClassId: json['seat_class_id'] as int?,
      seatType: json['seat_type'] as String?,
      isExitRow: json['is_exit_row'] as bool?,
    );
  }
}
