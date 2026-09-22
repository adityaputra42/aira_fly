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
  Future<Either<Failure, PnrDetailEntity>> createPnr({
    required ContactInput contact,
    required List<PassengerInput> passengers,
    required List<BookingSegmentInput> segments,
    required List<SeatSelectionInput> seatSelections,
    int holdTtlSeconds,
  });

  /// Admin-only (`booking:pnr:view` permission).
  Future<Either<Failure, PnrDetailEntity>> getPnr(int id);

  /// Admin-only (`booking:pnr:view` permission) -- everyone's bookings.
  Future<Either<Failure, List<PnrSummaryEntity>>> listPnrs({int page, int limit, String? status});

  /// Self-service booking history -- login required, always the caller's
  /// own bookings only (server resolves ownership from the auth token).
  /// Use this for the app's "Ticket History" tab when the user is logged
  /// in, NOT [listPnrs].
  Future<Either<Failure, List<PnrSummaryEntity>>> listMyPnrs({int page, int limit, String? status});

  /// Self-service lookup by booking code -- no login required. Intended
  /// for a guest "enter your booking code" search flow.
  ///
  /// SECURITY GAP (checked directly against the backend on 2026-09-18):
  /// the route this hits (`GET /bookings/pnrs/mine/{code}`) has NO auth
  /// middleware, and the handler's ownership check
  /// (`if info.CreatedBy == nil || *info.CreatedBy != userID`) is
  /// commented out in
  /// internal/booking/application/query/pnr_detail_query_service.go.
  /// The backend's own swagger doc for this endpoint claims it's
  /// "restricted to the authenticated caller" and that guest bookings
  /// "can never be returned here" -- neither is currently true. In
  /// practice this means ANYONE who knows or guesses a booking code can
  /// pull full passenger PII (names, emails, phone, document numbers)
  /// through this call today, logged in or not, their booking or not.
  /// This needs a backend fix (restore the ownership check, and/or
  /// require a second factor like contact email for guest lookups, plus
  /// rate limiting on this route) before relying on "not logged in ->
  /// can't see other people's bookings" as an actual guarantee anywhere
  /// in the UI built on top of this method.
  Future<Either<Failure, PnrDetailEntity>> getPnrByBookingCode(String bookingCode);

  Future<Either<Failure, void>> cancelPnr(int id);
}
