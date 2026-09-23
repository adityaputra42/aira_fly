import '../../domain/entities/pnr_entity.dart';

class PassengerDetailModel extends PassengerDetailEntity {
  const PassengerDetailModel({
    super.id,
    super.passengerType,
    super.title,
    super.firstName,
    super.lastName,
    super.gender,
    super.birthDate,
    super.nationality,
    super.documentType,
    super.documentNumber,
    super.documentExpiredAt,
  });

  factory PassengerDetailModel.fromJson(Map<String, dynamic> json) {
    return PassengerDetailModel(
      id: json['id'] as int?,
      passengerType: json['passenger_type'] as String?,
      title: json['title'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birth_date'] == null ? null : DateTime.tryParse(json['birth_date']),
      nationality: json['nationality'] as String?,
      documentType: json['document_type'] as String?,
      documentNumber: json['document_number'] as String?,
      documentExpiredAt: json['document_expired_at'] == null
          ? null
          : DateTime.tryParse(json['document_expired_at']),
    );
  }
}

class SegmentDetailModel extends SegmentDetailEntity {
  const SegmentDetailModel({
    super.id,
    super.flightId,
    super.fareClassId,
    super.status,
    super.flightNumber,
    super.departureTime,
    super.arrivalTime,
    super.flightStatus,
  });

  factory SegmentDetailModel.fromJson(Map<String, dynamic> json) {
    return SegmentDetailModel(
      id: json['id'] as int?,
      flightId: json['flight_id'] as int?,
      fareClassId: json['fare_class_id'] as int?,
      status: json['status'] as String?,
      flightNumber: json['flight_number'] as String?,
      departureTime: json['departure_time'] == null
          ? null
          : DateTime.tryParse(json['departure_time']),
      arrivalTime: json['arrival_time'] == null ? null : DateTime.tryParse(json['arrival_time']),
      flightStatus: json['flight_status'] as String?,
    );
  }
}

class SeatDetailModel extends SeatDetailEntity {
  const SeatDetailModel({super.passengerId, super.segmentId, super.flightSeatId, super.seatNumber});

  factory SeatDetailModel.fromJson(Map<String, dynamic> json) {
    return SeatDetailModel(
      passengerId: json['passenger_id'] as int?,
      segmentId: json['segment_id'] as int?,
      flightSeatId: json['flight_seat_id'] as int?,
      seatNumber: json['seat_number'] as String?,
    );
  }
}

class PnrAncillaryDetailModel extends PnrAncillaryDetailEntity {
  const PnrAncillaryDetailModel({
    super.id,
    super.passengerId,
    super.segmentId,
    super.ancillaryCode,
    super.ancillaryName,
    super.quantity,
    super.unitPrice,
    super.totalPrice,
    super.status,
    super.paymentStatus,
  });

  factory PnrAncillaryDetailModel.fromJson(Map<String, dynamic> json) {
    return PnrAncillaryDetailModel(
      id: json['id'] as int?,
      passengerId: json['passenger_id'] as int?,
      segmentId: json['segment_id'] as int?,
      ancillaryCode: json['ancillary_code'] as String?,
      ancillaryName: json['ancillary_name'] as String?,
      quantity: json['quantity'] as int?,
      unitPrice: double.tryParse('${json['unit_price']}'),
      totalPrice: double.tryParse('${json['total_price']}'),
      status: json['status'] as String?,
      paymentStatus: json['payment_status'] as String?,
    );
  }
}

class PnrDetailModel extends PnrDetailEntity {
  const PnrDetailModel({
    super.id,
    super.bookingCode,
    super.status,
    super.paymentStatus,
    super.totalAmount,
    super.currency,
    super.holdExpiresAt,
    super.contactName,
    super.contactEmail,
    super.contactPhone,
    super.createdBy,
    super.passengers,
    super.segments,
    super.seats,
    super.ancillaries,
  });

  factory PnrDetailModel.fromJson(Map<String, dynamic> json) {
    return PnrDetailModel(
      id: json['id'] as int?,
      bookingCode: json['booking_code'] as String?,
      status: json['status'] as String?,
      paymentStatus: json['payment_status'] as String?,
      totalAmount: double.tryParse('${json['total_amount']}'),
      currency: json['currency'] as String?,
      holdExpiresAt: json['hold_expires_at'] == null
          ? null
          : DateTime.tryParse(json['hold_expires_at']),
      contactName: json['contact_name'] as String?,
      contactEmail: json['contact_email'] as String?,
      contactPhone: json['contact_phone'] as String?,
      createdBy: json['created_by'] as int?,
      passengers: (json['passengers'] as List? ?? [])
          .map((e) => PassengerDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      segments: (json['segments'] as List? ?? [])
          .map((e) => SegmentDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      seats: (json['seats'] as List? ?? [])
          .map((e) => SeatDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      ancillaries: (json['ancillaries'] as List? ?? [])
          .map((e) => PnrAncillaryDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PnrSummaryModel extends PnrSummaryEntity {
  const PnrSummaryModel({
    super.id,
    super.bookingCode,
    super.status,
    super.paymentStatus,
    super.totalAmount,
    super.currency,
    super.createdAt,
    super.expiresAt,
  });

  factory PnrSummaryModel.fromJson(Map<String, dynamic> json) {
    return PnrSummaryModel(
      id: json['id'] as int?,
      bookingCode: json['booking_code'] as String?,
      status: json['status'] as String?,
      paymentStatus: json['payment_status'] as String?,
      totalAmount: double.tryParse('${json['total_amount']}'),
      currency: json['currency'] as String?,
      createdAt: json['created_at'] == null ? null : DateTime.tryParse(json['created_at']),
      expiresAt: json['expires_at'] == null ? null : DateTime.tryParse(json['expires_at']),
    );
  }
}

class PnrListModel {
  final List<PnrSummaryModel> items;
  final int total;
  final int page;
  final int limit;

  const PnrListModel({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PnrListModel.fromJson(Map<String, dynamic> json) {
    return PnrListModel(
      items: (json['items'] as List? ?? [])
          .map((e) => PnrSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
    );
  }
}
