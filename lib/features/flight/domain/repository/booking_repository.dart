import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/pnr_entity.dart';

class ContactInput {
  final String fullName;
  final String? email;
  final String phone;

  const ContactInput({required this.fullName, this.email, required this.phone});

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    if (email != null) 'email': email,
    'phone': phone,
  };
}

class PassengerInput {
  final String passengerType; // ADT | CHD | INF
  final String? title;
  final String firstName;
  final String? lastName;
  final String? gender; // M | F
  final String? birthDate; // YYYY-MM-DD
  final String? nationality;
  final String? documentType;
  final String? documentNumber;
  final String? documentExpiredAt; // YYYY-MM-DD

  const PassengerInput({
    required this.passengerType,
    this.title,
    required this.firstName,
    this.lastName,
    this.gender,
    this.birthDate,
    this.nationality,
    this.documentType,
    this.documentNumber,
    this.documentExpiredAt,
  });

  Map<String, dynamic> toJson() => {
    'passenger_type': passengerType,
    if (title != null) 'title': title,
    'first_name': firstName,
    if (lastName != null) 'last_name': lastName,
    if (gender != null) 'gender': gender,
    if (birthDate != null) 'birth_date': birthDate,
    if (nationality != null) 'nationality': nationality,
    if (documentType != null) 'document_type': documentType,
    if (documentNumber != null) 'document_number': documentNumber,
    if (documentExpiredAt != null) 'document_expired_at': documentExpiredAt,
  };
}

class BookingSegmentInput {
  final int flightId;
  final int fareClassId;

  const BookingSegmentInput({required this.flightId, required this.fareClassId});

  Map<String, dynamic> toJson() => {'flight_id': flightId, 'fare_class_id': fareClassId};
}

class SeatSelectionInput {
  final int passengerIndex;
  final int segmentIndex;
  final int flightSeatId; // MUST be a flight_seats.id (see FlightSeatEntity docs)

  const SeatSelectionInput({
    required this.passengerIndex,
    required this.segmentIndex,
    required this.flightSeatId,
  });

  Map<String, dynamic> toJson() => {
    'passenger_index': passengerIndex,
    'segment_index': segmentIndex,
    'flight_seat_id': flightSeatId,
  };
}

abstract interface class BookingRepository {
  Future<Either<Failure, PnrEntity>> createPnr({
    required ContactInput contact,
    required List<PassengerInput> passengers,
    required List<BookingSegmentInput> segments,
    required List<SeatSelectionInput> seatSelections,
    int holdTtlSeconds,
  });

  /// Admin-only on the backend (`booking:pnr:view`).
  Future<Either<Failure, PnrDetailEntity>> getPnr(int id);

  /// Admin-only on the backend (`booking:pnr:view`).
  Future<Either<Failure, List<PnrSummaryEntity>>> listPnrs({
    int page,
    int limit,
    String? status,
  });

  /// Admin-only on the backend (`booking:pnr:cancel`). Only works while the
  /// PNR is still HOLD (unpaid); a BOOKED (paid) PNR cannot be cancelled
  /// this way.
  Future<Either<Failure, void>> cancelPnr(int id);
}
