import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';

abstract final class AiState {
  static const completed = 'completed';
  static const failed = 'failed';
  static const cancelled = 'cancelled';
  static const collectingPassengerData = 'collecting_passenger_data';
  static const awaitingBookingConfirmation = 'awaiting_booking_confirmation';
  static const awaitingPaymentConfirmation = 'awaiting_payment_confirmation';
  static const paymentPending = 'payment_pending';

  static bool isTerminal(String s) => s == completed || s == failed || s == cancelled;
}

abstract final class AiAction {
  static const sendMessage = 'send_message';
  static const selectFlight = 'select_flight';
  static const submitPassengers = 'submit_passengers';
  static const confirmBooking = 'confirm_booking';
  static const confirmPayment = 'confirm_payment';
  static const refreshPayment = 'refresh_payment';
  static const startNew = 'start_new_conversation';
}

enum AiInputType {
  text('text'),
  voiceTranscript('voice_transcript');

  final String wire;

  const AiInputType(this.wire);
}

class AiSegmentEntity extends Equatable {
  final String flightNumber;
  final String from;
  final String to;
  final String? fromCity;
  final String? toCity;
  final DateTime? departAt;
  final DateTime? arriveAt;
  final String departText;
  final String arriveText;

  const AiSegmentEntity({
    required this.flightNumber,
    required this.from,
    required this.to,
    this.fromCity,
    this.toCity,
    this.departAt,
    this.arriveAt,
    this.departText = '',
    this.arriveText = '',
  });

  @override
  List<Object?> get props => [flightNumber, from, to, departAt, arriveAt];
}

class AiFareEntity extends Equatable {
  final int fareClassId;
  final String name;
  final String seatClass;
  final String currency;
  final String total;
  final String totalText;
  final Map<String, String> perType;
  final int availableSeats;
  final bool refundable;
  final int baggageKg;

  const AiFareEntity({
    required this.fareClassId,
    this.name = '',
    this.seatClass = '',
    this.currency = 'IDR',
    this.total = '0',
    this.totalText = '',
    this.perType = const {},
    this.availableSeats = 0,
    this.refundable = false,
    this.baggageKg = 0,
  });

  @override
  List<Object?> get props => [fareClassId, name, seatClass, total, availableSeats];
}

class AiOfferEntity extends Equatable {
  final String optionId;
  final int stops;
  final int durationMinutes;
  final String durationText;
  final List<AiSegmentEntity> segments;
  final List<AiFareEntity> fares;

  const AiOfferEntity({
    required this.optionId,
    this.stops = 0,
    this.durationMinutes = 0,
    this.durationText = '',
    this.segments = const [],
    this.fares = const [],
  });

  @override
  List<Object?> get props => [optionId, segments, fares];
}

class AiOffersEntity extends Equatable {
  final List<AiOfferEntity> departure;
  final List<AiOfferEntity> returnOffers;

  const AiOffersEntity({this.departure = const [], this.returnOffers = const []});

  bool get isEmpty => departure.isEmpty && returnOffers.isEmpty;

  @override
  List<Object?> get props => [departure, returnOffers];
}

class AiSeatEntity extends Equatable {
  final int passengerIndex;
  final String flightNumber;
  final String seatNumber;

  const AiSeatEntity({
    required this.passengerIndex,
    required this.flightNumber,
    required this.seatNumber,
  });

  @override
  List<Object?> get props => [passengerIndex, flightNumber, seatNumber];
}

class AiConfirmationEntity extends Equatable {
  final String kind; // BOOKING | PAYMENT
  final String summaryHash;
  final List<String> lines;
  final String total;
  final String totalText;
  final String currency;
  final bool priceChanged;
  final String? previousTotalText;
  final List<AiSeatEntity> seats;
  final List<String> channels; // PAYMENT only
  final DateTime? validUntil;

  const AiConfirmationEntity({
    required this.kind,
    required this.summaryHash,
    this.lines = const [],
    this.total = '0',
    this.totalText = '',
    this.currency = 'IDR',
    this.priceChanged = false,
    this.previousTotalText,
    this.seats = const [],
    this.channels = const [],
    this.validUntil,
  });

  bool get isBooking => kind == 'BOOKING';

  bool get isPayment => kind == 'PAYMENT';

  @override
  List<Object?> get props => [kind, summaryHash, totalText, priceChanged, channels];
}

class AiBookingEntity extends Equatable {
  final int pnrId;
  final String bookingCode;
  final String total;
  final String totalText;
  final String currency;
  final DateTime? holdExpiresAt;

  const AiBookingEntity({
    required this.pnrId,
    required this.bookingCode,
    this.total = '0',
    this.totalText = '',
    this.currency = 'IDR',
    this.holdExpiresAt,
  });

  @override
  List<Object?> get props => [pnrId, bookingCode, totalText];
}

class AiPaymentEntity extends Equatable {
  final int paymentId;
  final String paymentCode;
  final String? virtualAccountNo;
  final String channel;
  final String amount;
  final String amountText;
  final String currency;
  final String status; // PENDING | PAID | FAILED | EXPIRED | REFUNDED
  final DateTime? expiresAt;

  const AiPaymentEntity({
    required this.paymentId,
    required this.paymentCode,
    this.virtualAccountNo,
    this.channel = '',
    this.amount = '0',
    this.amountText = '',
    this.currency = 'IDR',
    this.status = 'PENDING',
    this.expiresAt,
  });

  bool get isPaid => status == 'PAID';

  bool get isPending => status == 'PENDING';

  @override
  List<Object?> get props => [paymentId, paymentCode, status, virtualAccountNo];
}

abstract final class AiPaymentChannel {
  static const balance = 'BALANCE';

  static bool isWallet(String channel) => channel == balance;

  static String label(String channel) {
    if (isWallet(channel)) return 'Saldo dompet';
    var s = channel.replaceFirst('VIRTUAL_ACCOUNT_', '').replaceFirst('BANK_', '');
    s = s.replaceAll('_', ' ').toLowerCase();
    return s.isEmpty ? channel : s[0].toUpperCase() + s.substring(1);
  }
}

class AiPassengerSummaryEntity extends Equatable {
  final int total;
  final int adults;
  final int children;
  final int infants;
  final int seatsRequired;

  const AiPassengerSummaryEntity({
    this.total = 0,
    this.adults = 0,
    this.children = 0,
    this.infants = 0,
    this.seatsRequired = 0,
  });

  bool get hasChildren => children > 0;
  bool get hasInfants => infants > 0;

  List<({String type, String label})> get slots => [
    for (var i = 1; i <= adults; i++) (type: 'ADT', label: 'Adult $i'),
    for (var i = 1; i <= children; i++) (type: 'CHD', label: 'Child $i'),
    for (var i = 1; i <= infants; i++) (type: 'INF', label: 'Infant $i'),
  ];

  @override
  List<Object?> get props => [total, adults, children, infants, seatsRequired];
}

class AiSearchEntity extends Equatable {
  static const oneWay = 'one_way';
  static const roundTrip = 'round_trip';

  final String origin; // IATA, e.g. CGK
  final String? originCity;
  final String destination; // IATA, e.g. DPS
  final String? destinationCity;
  final String tripType; // one_way | round_trip
  final DateTime? departureDate;
  final String departureDateText; // "24 Des 2026"
  final DateTime? returnDate; // only for round_trip
  final String? returnDateText;
  final AiPassengerSummaryEntity passengers;
  final String passengersText; // "2 dewasa, 1 anak, 1 bayi"
  final int maxStops; // 0 = direct only, 1 = allow one connection
  final String sort; // cheapest | earliest | fastest

  const AiSearchEntity({
    required this.origin,
    required this.destination,
    required this.tripType,
    this.originCity,
    this.destinationCity,
    this.departureDate,
    this.departureDateText = '',
    this.returnDate,
    this.returnDateText,
    this.passengers = const AiPassengerSummaryEntity(),
    this.passengersText = '',
    this.maxStops = 1,
    this.sort = 'cheapest',
  });

  bool get isRoundTrip => tripType == roundTrip;
  bool get isDirectOnly => maxStops == 0;

  @override
  List<Object?> get props => [
    origin,
    originCity,
    destination,
    destinationCity,
    tripType,
    departureDate,
    returnDate,
    passengers,
    maxStops,
    sort,
  ];
}

class AiTurnEntity extends Equatable {
  final String conversationId;
  final String state;
  final String message;
  final String speakable;
  final AiSearchEntity? search;
  final AiOffersEntity? offers;
  final int? selectedFareClassId;
  final List<String> selectedOffers;
  final AiConfirmationEntity? confirmation;
  final AiBookingEntity? booking;
  final AiPaymentEntity? payment;
  final List<String> actions;
  final bool fallbackToForm;
  final String? requestId;

  const AiTurnEntity({
    required this.conversationId,
    required this.state,
    this.message = '',
    this.speakable = '',
    this.search,
    this.offers,
    this.selectedFareClassId,
    this.selectedOffers = const [],
    this.confirmation,
    this.booking,
    this.payment,
    this.actions = const [],
    this.fallbackToForm = false,
    this.requestId,
  });

  bool can(String action) => actions.contains(action);

  bool get isTerminal => AiState.isTerminal(state);

  @override
  List<Object?> get props => [
    conversationId,
    state,
    message,
    search,
    offers,
    confirmation,
    booking,
    payment,
    actions,
    fallbackToForm,
    requestId,
  ];
}

class AiHistoryMessageEntity extends Equatable {
  final String role; // user | assistant
  final String content;
  final DateTime createdAt;

  const AiHistoryMessageEntity({
    required this.role,
    required this.content,
    required this.createdAt,
  });

  bool get isUser => role == 'user';

  @override
  List<Object?> get props => [role, content, createdAt];
}

class AiConversationEntity extends Equatable {
  final AiTurnEntity turn;
  final List<AiHistoryMessageEntity> messages;
  final DateTime? expiresAt;

  const AiConversationEntity({required this.turn, this.messages = const [], this.expiresAt});

  @override
  List<Object?> get props => [turn, messages, expiresAt];
}

class AiContactEntity extends Equatable {
  final String fullName;
  final String email;
  final String phone;

  const AiContactEntity({required this.fullName, required this.email, required this.phone});

  @override
  List<Object?> get props => [fullName, email, phone];
}

class AiPassengerEntity extends Equatable {
  final String passengerType; // ADT | CHD | INF
  final String? title;
  final String firstName;
  final String lastName;
  final String? gender;
  final String? birthDate; // YYYY-MM-DD
  final String? nationality;
  final String? documentType;
  final String? documentNumber;
  final String? documentExpiredAt;
  final int? associatedAdultIndex;

  const AiPassengerEntity({
    required this.passengerType,
    required this.firstName,
    required this.lastName,
    this.title,
    this.gender,
    this.birthDate,
    this.nationality,
    this.documentType,
    this.documentNumber,
    this.documentExpiredAt,
    this.associatedAdultIndex
  });

  @override
  List<Object?> get props =>
      [
        passengerType,
        firstName,
        lastName,
        birthDate,
        documentNumber,
        associatedAdultIndex
      ];
}

class AiFailure extends Failure {
  final int? statusCode;
  final int? retryAfterSeconds;
  final bool retryable;
  final bool fallbackToForm;
  final bool conversationGone;
  final AiTurnEntity? turn;
  AiFailure(
    super.message, {
    this.statusCode,
    this.retryAfterSeconds,
    this.retryable = false,
    this.fallbackToForm = false,
    this.conversationGone = false,
    this.turn,
  });
}
