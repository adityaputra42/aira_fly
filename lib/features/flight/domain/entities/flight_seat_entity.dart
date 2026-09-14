import 'package:equatable/equatable.dart';

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
