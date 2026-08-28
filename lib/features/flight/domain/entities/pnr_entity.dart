import 'package:equatable/equatable.dart';

/// Result of creating a PNR (POST /bookings/pnrs).
class PnrEntity extends Equatable {
  final int? pnrId;
  final String? bookingCode;
  final String? status; // HOLD, BOOKED, CANCELLED, EXPIRED
  final DateTime? expiresAt;
  final double? totalAmount;
  final String? currency;

  const PnrEntity({
    this.pnrId,
    this.bookingCode,
    this.status,
    this.expiresAt,
    this.totalAmount,
    this.currency,
  });

  @override
  List<Object?> get props => [
    pnrId,
    bookingCode,
    status,
    expiresAt,
    totalAmount,
    currency,
  ];
}

/// Full PNR detail (GET /bookings/pnrs/{id}).
/// NOTE: this admin endpoint requires the `booking:pnr:view` permission on
/// the backend -- a normal customer token cannot call it for their own
/// booking. Use PaymentRepository.getPaymentByPnr for a self-service,
/// ownership-checked way to look up a PNR's payment status instead.
class PnrDetailEntity extends Equatable {
  final int? id;
  final String? bookingCode;
  final String? status;
  final String? paymentStatus;
  final double? totalAmount;
  final String? currency;
  final DateTime? holdExpiresAt;
  final String? contactName;
  final String? contactEmail;
  final String? contactPhone;
  final int? createdBy;

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
  ];
}

/// Row shape for GET /bookings/pnrs (admin list, `booking:pnr:view`).
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
