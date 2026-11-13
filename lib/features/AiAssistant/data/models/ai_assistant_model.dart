import '../../domain/entities/ai_assistant_entity.dart';

String _str(dynamic v, [String fallback = '']) => v == null ? fallback : v.toString();
String? _strN(dynamic v) => (v == null || v.toString().isEmpty) ? null : v.toString();
int _int(dynamic v, [int fallback = 0]) => v is int ? v : (int.tryParse('$v') ?? fallback);
bool _bool(dynamic v) => v == true;
DateTime? _dt(dynamic v) => v == null ? null : DateTime.tryParse('$v');
List<String> _strList(dynamic v) => (v as List? ?? const []).map((e) => '$e').toList();
List<Map<String, dynamic>> _maps(dynamic v) =>
    (v as List? ?? const []).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();

/// Maps `dto.SegmentView`.
class AiSegmentModel extends AiSegmentEntity {
  const AiSegmentModel({
    required super.flightNumber,
    required super.from,
    required super.to,
    super.fromCity,
    super.toCity,
    super.departAt,
    super.arriveAt,
    super.departText,
    super.arriveText,
  });

  factory AiSegmentModel.fromJson(Map<String, dynamic> j) => AiSegmentModel(
    flightNumber: _str(j['flight_number']),
    from: _str(j['from']),
    to: _str(j['to']),
    fromCity: _strN(j['from_city']),
    toCity: _strN(j['to_city']),
    departAt: _dt(j['depart_at']),
    arriveAt: _dt(j['arrive_at']),
    departText: _str(j['depart_text']),
    arriveText: _str(j['arrive_text']),
  );
}

/// Maps `dto.FareView`.
class AiFareModel extends AiFareEntity {
  const AiFareModel({
    required super.fareClassId,
    super.name,
    super.seatClass,
    super.currency,
    super.total,
    super.totalText,
    super.perType,
    super.availableSeats,
    super.refundable,
    super.baggageKg,
  });

  factory AiFareModel.fromJson(Map<String, dynamic> j) => AiFareModel(
    fareClassId: _int(j['fare_class_id']),
    name: _str(j['name']),
    seatClass: _str(j['seat_class']),
    currency: _str(j['currency'], 'IDR'),
    total: _str(j['total'], '0'),
    totalText: _str(j['total_text']),
    perType: (j['per_type'] as Map? ?? const {}).map((k, v) => MapEntry('$k', '$v')),
    availableSeats: _int(j['available_seats']),
    refundable: _bool(j['refundable']),
    baggageKg: _int(j['baggage_kg']),
  );
}

class AiOfferModel extends AiOfferEntity {
  const AiOfferModel({
    required super.optionId,
    super.stops,
    super.durationMinutes,
    super.durationText,
    super.segments,
    super.fares,
  });

  factory AiOfferModel.fromJson(Map<String, dynamic> j) => AiOfferModel(
    optionId: _str(j['option_id']),
    stops: _int(j['stops']),
    durationMinutes: _int(j['duration_minutes']),
    durationText: _str(j['duration_text']),
    segments: _maps(j['segments']).map(AiSegmentModel.fromJson).toList(),
    fares: _maps(j['fares']).map(AiFareModel.fromJson).toList(),
  );
}

class AiOffersModel extends AiOffersEntity {
  const AiOffersModel({super.departure, super.returnOffers});

  factory AiOffersModel.fromJson(Map<String, dynamic> j) => AiOffersModel(
    departure: _maps(j['departure']).map(AiOfferModel.fromJson).toList(),
    returnOffers: _maps(j['return']).map(AiOfferModel.fromJson).toList(),
  );
}

class AiSeatModel extends AiSeatEntity {
  const AiSeatModel({
    required super.passengerIndex,
    required super.flightNumber,
    required super.seatNumber,
  });

  factory AiSeatModel.fromJson(Map<String, dynamic> j) => AiSeatModel(
    passengerIndex: _int(j['passenger_index']),
    flightNumber: _str(j['flight_number']),
    seatNumber: _str(j['seat_number']),
  );
}

class AiConfirmationModel extends AiConfirmationEntity {
  const AiConfirmationModel({
    required super.kind,
    required super.summaryHash,
    super.lines,
    super.total,
    super.totalText,
    super.currency,
    super.priceChanged,
    super.previousTotalText,
    super.seats,
    super.channels,
    super.validUntil,
  });

  factory AiConfirmationModel.fromJson(Map<String, dynamic> j) => AiConfirmationModel(
    kind: _str(j['kind']),
    summaryHash: _str(j['summary_hash']),
    lines: _strList(j['lines']),
    total: _str(j['total'], '0'),
    totalText: _str(j['total_text']),
    currency: _str(j['currency'], 'IDR'),
    priceChanged: _bool(j['price_changed']),
    previousTotalText: _strN(j['previous_total_text']),
    seats: _maps(j['seats']).map(AiSeatModel.fromJson).toList(),
    channels: _strList(j['channels']),
    validUntil: _dt(j['valid_until']),
  );
}

class AiBookingModel extends AiBookingEntity {
  const AiBookingModel({
    required super.pnrId,
    required super.bookingCode,
    super.total,
    super.totalText,
    super.currency,
    super.holdExpiresAt,
  });

  factory AiBookingModel.fromJson(Map<String, dynamic> j) => AiBookingModel(
    pnrId: _int(j['pnr_id']),
    bookingCode: _str(j['booking_code']),
    total: _str(j['total'], '0'),
    totalText: _str(j['total_text']),
    currency: _str(j['currency'], 'IDR'),
    holdExpiresAt: _dt(j['hold_expires_at']),
  );
}

class AiPaymentModel extends AiPaymentEntity {
  const AiPaymentModel({
    required super.paymentId,
    required super.paymentCode,
    super.virtualAccountNo,
    super.channel,
    super.amount,
    super.amountText,
    super.currency,
    super.status,
    super.expiresAt,
  });

  factory AiPaymentModel.fromJson(Map<String, dynamic> j) => AiPaymentModel(
    paymentId: _int(j['payment_id']),
    paymentCode: _str(j['payment_code']),
    virtualAccountNo: _strN(j['virtual_account_no']),
    channel: _str(j['channel']),
    amount: _str(j['amount'], '0'),
    amountText: _str(j['amount_text']),
    currency: _str(j['currency'], 'IDR'),
    status: _str(j['status'], 'PENDING'),
    expiresAt: _dt(j['expires_at']),
  );
}

/// Maps `dto.PassengerSummary`.
class AiPassengerSummaryModel extends AiPassengerSummaryEntity {
  const AiPassengerSummaryModel({
    super.total,
    super.adults,
    super.children,
    super.infants,
    super.seatsRequired,
  });

  factory AiPassengerSummaryModel.fromJson(Map<String, dynamic> j) {
    final adults = _int(j['adults']);
    final children = _int(j['children']);
    final infants = _int(j['infants']);
    return AiPassengerSummaryModel(
      adults: adults,
      children: children,
      infants: infants,
      // Fall back to the sums if the backend ever omits them.
      total: j['total'] == null ? adults + children + infants : _int(j['total']),
      seatsRequired: j['seats_required'] == null ? adults + children : _int(j['seats_required']),
    );
  }
}

/// Maps `dto.SearchView`.
class AiSearchModel extends AiSearchEntity {
  const AiSearchModel({
    required super.origin,
    required super.destination,
    required super.tripType,
    super.originCity,
    super.destinationCity,
    super.departureDate,
    super.departureDateText,
    super.returnDate,
    super.returnDateText,
    super.passengers,
    super.passengersText,
    super.maxStops,
    super.sort,
  });

  factory AiSearchModel.fromJson(Map<String, dynamic> j) => AiSearchModel(
    origin: _str(j['origin']),
    originCity: _strN(j['origin_city']),
    destination: _str(j['destination']),
    destinationCity: _strN(j['destination_city']),
    tripType: _str(j['trip_type'], AiSearchEntity.oneWay),
    departureDate: _dt(j['departure_date']),
    departureDateText: _str(j['departure_date_text']),
    returnDate: _dt(j['return_date']),
    returnDateText: _strN(j['return_date_text']),
    passengers: j['passengers'] is Map
        ? AiPassengerSummaryModel.fromJson(Map<String, dynamic>.from(j['passengers'] as Map))
        : const AiPassengerSummaryEntity(),
    passengersText: _str(j['passengers_text']),
    maxStops: j['max_stops'] == null ? 1 : _int(j['max_stops'], 1),
    sort: _str(j['sort'], 'cheapest'),
  );
}

class AiTurnModel extends AiTurnEntity {
  const AiTurnModel({
    required super.conversationId,
    required super.state,
    super.message,
    super.speakable,
    super.search,
    super.offers,
    super.selectedFareClassId,
    super.selectedOffers,
    super.confirmation,
    super.booking,
    super.payment,
    super.actions,
    super.fallbackToForm,
    super.requestId,
  });

  static bool looksLikeTurn(dynamic j) =>
      j is Map && j.containsKey('conversation_id') && j.containsKey('state');

  factory AiTurnModel.fromJson(Map<String, dynamic> j) => AiTurnModel(
    conversationId: _str(j['conversation_id']),
    state: _str(j['state']),
    message: _str(j['message']),
    speakable: _str(j['speakable']),
    search: j['search'] is Map
        ? AiSearchModel.fromJson(Map<String, dynamic>.from(j['search'] as Map))
        : null,
    offers: j['offers'] is Map
        ? AiOffersModel.fromJson(Map<String, dynamic>.from(j['offers'] as Map))
        : null,
    selectedFareClassId: j['selected_fare_class_id'] == null
        ? null
        : _int(j['selected_fare_class_id']),
    selectedOffers: _strList(j['selected_offers']),
    confirmation: j['confirmation'] is Map
        ? AiConfirmationModel.fromJson(Map<String, dynamic>.from(j['confirmation'] as Map))
        : null,
    booking: j['booking'] is Map
        ? AiBookingModel.fromJson(Map<String, dynamic>.from(j['booking'] as Map))
        : null,
    payment: j['payment'] is Map
        ? AiPaymentModel.fromJson(Map<String, dynamic>.from(j['payment'] as Map))
        : null,
    actions: _strList(j['actions']),
    fallbackToForm: _bool(j['fallback_to_form']),
    requestId: _strN(j['request_id']),
  );
}

class AiConversationModel extends AiConversationEntity {
  const AiConversationModel({required super.turn, super.messages, super.expiresAt});

  factory AiConversationModel.fromJson(Map<String, dynamic> j) => AiConversationModel(
    turn: AiTurnModel.fromJson(j),
    messages: _maps(j['messages'])
        .map(
          (m) => AiHistoryMessageEntity(
            role: _str(m['role']),
            content: _str(m['content']),
            createdAt: _dt(m['created_at']) ?? DateTime.now(),
          ),
        )
        .toList(),
    expiresAt: _dt(j['expires_at']),
  );
}

abstract final class AiPassengerRequest {
  static Map<String, dynamic> body({
    required AiContactEntity contact,
    required List<AiPassengerEntity> passengers,
  }) => {
    'contact': {
      'full_name': contact.fullName.trim(),
      'email': contact.email.trim(),
      'phone': contact.phone.trim(),
    },
    'passengers': passengers.map(_passenger).toList(),
  };

  static Map<String, dynamic> _passenger(AiPassengerEntity p) {
    final m = <String, dynamic>{
      'passenger_type': p.passengerType,
      'first_name': p.firstName.trim(),
      'last_name': p.lastName.trim(),
    };
    void put(String k, dynamic v) {
      if (v != null && v.trim().isNotEmpty) m[k] = v.trim();
    }

    put('title', p.title);
    put('gender', p.gender);
    put('birth_date', p.birthDate);
    put('nationality', p.nationality);
    put('document_type', p.documentType);
    put('document_number', p.documentNumber);
    put('document_expired_at', p.documentExpiredAt);
    put('associated_adult_index', p.associatedAdultIndex);
    return m;
  }
}
