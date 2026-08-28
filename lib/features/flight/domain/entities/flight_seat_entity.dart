import 'package:equatable/equatable.dart';

/// Represents a single seat on a specific flight instance.
///
/// IMPORTANT: [id] here is `flight_seats.id`. This is the ONLY id valid
/// for `seat_selections[].flight_seat_id` when creating a PNR
/// (POST /bookings/pnrs). It is NOT the same as an aircraft layout seat id
/// (GET /flights/aircrafts/{id}/seats) -- that is a different id sequence
/// entirely and will be rejected by the booking API if used here.
class FlightSeatEntity extends Equatable {
  final int? id;
  final int? flightId;
  final String? status; // AVAILABLE | LOCKED | BOOKED | CHECKED_IN | BLOCKED
  final String? seatNumber;
  final int? rowNumber;
  final String? seatLetter;
  final int? seatClassId;
  final String? seatType;
  final bool? isExitRow;

  const FlightSeatEntity({
    this.id,
    this.flightId,
    this.status,
    this.seatNumber,
    this.rowNumber,
    this.seatLetter,
    this.seatClassId,
    this.seatType,
    this.isExitRow,
  });

  bool get isAvailable => status == 'AVAILABLE';

  @override
  List<Object?> get props => [
    id,
    flightId,
    status,
    seatNumber,
    rowNumber,
    seatLetter,
    seatClassId,
    seatType,
    isExitRow,
  ];
}
