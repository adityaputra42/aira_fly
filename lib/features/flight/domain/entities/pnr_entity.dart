import 'package:equatable/equatable.dart';

/// One passenger inside a PNRDetail (createBooking, GetMineByBookingCode).
class PassengerDetailEntity extends Equatable {
  final int? id;
  final String? passengerType; // ADT | CHD | INF
  final String? title;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final DateTime? birthDate;
  final String? nationality;
  final String? documentType;
  final String? documentNumber;
  final DateTime? documentExpiredAt;

  const PassengerDetailEntity({
    this.id,
    this.passengerType,
    this.title,
    this.firstName,
    this.lastName,
    this.gender,
    this.birthDate,
    this.nationality,
    this.documentType,
    this.documentNumber,
    this.documentExpiredAt,
  });

  @override
  List<Object?> get props => [
    id,
    passengerType,
    title,
    firstName,
    lastName,
    gender,
    birthDate,
    nationality,
    documentType,
    documentNumber,
    documentExpiredAt,
  ];
}

class SegmentDetailEntity extends Equatable {
  final int? id;
  final int? flightId;
  final int? fareClassId;
  final String? status; // segment status: BOOKED, ...
  final String? flightNumber;
  final DateTime? departureTime;
  final DateTime? arrivalTime;
  final String? flightStatus; // the flight's own status: SCHEDULED, ... -- distinct from `status`

  const SegmentDetailEntity({
    this.id,
    this.flightId,
    this.fareClassId,
    this.status,
    this.flightNumber,
    this.departureTime,
    this.arrivalTime,
    this.flightStatus,
  });

  @override
  List<Object?> get props => [
    id,
    flightId,
    fareClassId,
    status,
    flightNumber,
    departureTime,
    arrivalTime,
    flightStatus,
  ];
}

/// One assigned seat inside a PNRDetail.
class SeatDetailEntity extends Equatable {
  final int? passengerId;
  final int? segmentId;
  final int? flightSeatId;
  final String? seatNumber;

  const SeatDetailEntity({this.passengerId, this.segmentId, this.flightSeatId, this.seatNumber});

  @override
  List<Object?> get props => [passengerId, segmentId, flightSeatId, seatNumber];
}

class PnrAncillaryDetailEntity extends Equatable {
  final int? id;
  final int? passengerId; // null if the add-on applies to the whole PNR
  final int? segmentId; // null if the add-on isn't tied to one segment
  final String? ancillaryCode;
  final String? ancillaryName;
  final int? quantity;
  final double? unitPrice;
  final double? totalPrice;
  final String? status; // ACTIVE, CANCELLED, USED
  final String? paymentStatus;

  const PnrAncillaryDetailEntity({
    this.id,
    this.passengerId,
    this.segmentId,
    this.ancillaryCode,
    this.ancillaryName,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
    this.status,
    this.paymentStatus,
  });

  @override
  List<Object?> get props => [
    id,
    passengerId,
    segmentId,
    ancillaryCode,
    ancillaryName,
    quantity,
    unitPrice,
    totalPrice,
    status,
    paymentStatus,
  ];
}

class PnrDetailEntity extends Equatable {
  final int? id;
  final String? bookingCode;
  final String? status; // HOLD, BOOKED, CANCELLED, EXPIRED
  final String? paymentStatus; // UNPAID, PENDING, PAID, FAILED, EXPIRED, REFUNDED
  final double? totalAmount;
  final String? currency;
  final DateTime? holdExpiresAt; // null if the PNR isn't (or is no longer) in HOLD
  final String? contactName;
  final String? contactEmail;
  final String? contactPhone;
  final int? createdBy; // null for a guest booking
  final List<PassengerDetailEntity> passengers;
  final List<SegmentDetailEntity> segments;
  final List<SeatDetailEntity> seats;
  final List<PnrAncillaryDetailEntity> ancillaries;

  const PnrDetailEntity({
    this.id,
    this.bookingCode,
    this.status,
    this.paymentStatus,
    this.totalAmount,
    this.currency,
    this.holdExpiresAt,
    this.contactName,
    this.contactEmail,
    this.contactPhone,
    this.createdBy,
    this.passengers = const [],
    this.segments = const [],
    this.seats = const [],
    this.ancillaries = const [],
  });

  @override
  List<Object?> get props => [
    id,
    bookingCode,
    status,
    paymentStatus,
    totalAmount,
    currency,
    holdExpiresAt,
    contactName,
    contactEmail,
    contactPhone,
    createdBy,
    passengers,
    segments,
    seats,
    ancillaries,
  ];
}

class PnrSummaryEntity extends Equatable {
  final int? id;
  final String? bookingCode;
  final String? status;
  final String? paymentStatus;
  final double? totalAmount;
  final String? currency;
  final DateTime? createdAt;
  final DateTime? expiresAt;

  const PnrSummaryEntity({
    this.id,
    this.bookingCode,
    this.status,
    this.paymentStatus,
    this.totalAmount,
    this.currency,
    this.createdAt,
    this.expiresAt,
  });

  @override
  List<Object?> get props => [
    id,
    bookingCode,
    status,
    paymentStatus,
    totalAmount,
    currency,
    createdAt,
    expiresAt,
  ];
}
