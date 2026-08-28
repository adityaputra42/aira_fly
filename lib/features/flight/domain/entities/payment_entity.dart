import 'package:equatable/equatable.dart';

/// Result of POST /payments (createPaymentResponse, snake_case tags).
///
/// Business rules worth knowing when wiring this up:
/// - Creating a payment settles whatever is CURRENTLY unpaid for the PNR:
///   the flight-fare total (if unpaid) PLUS any ACTIVE, unpaid ancillary
///   charges, bundled into one payment.
/// - `paymentMethod` defaults to "DOKU_VA" (works for guests too; returns
///   a virtual account number/channel to show the customer) or can be
///   "BALANCE" (requires login, and only for the caller's own PNR --
///   settles instantly against wallet balance, no virtual account).
/// - For "BALANCE", [virtualAccountNo] will be empty and the payment is
///   already PAID; for "DOKU_VA" it starts PENDING until DOKU notifies us.
class PaymentEntity extends Equatable {
  final int? paymentId;
  final String? paymentCode;
  final String? virtualAccountNo;
  final String? channel;
  final DateTime? expiredAt;
  final double? amount;
  final String? currency;
  final double? ticketPortion;
  final double? ancillaryPortion;

  const PaymentEntity({
    this.paymentId,
    this.paymentCode,
    this.virtualAccountNo,
    this.channel,
    this.expiredAt,
    this.amount,
    this.currency,
    this.ticketPortion,
    this.ancillaryPortion,
  });

  @override
  List<Object?> get props => [
    paymentId,
    paymentCode,
    virtualAccountNo,
    channel,
    expiredAt,
    amount,
    currency,
    ticketPortion,
    ancillaryPortion,
  ];
}

/// GET /payments/{id} and GET /payments/pnr/{pnr_id} shape (`PaymentView`).
class PaymentViewEntity extends Equatable {
  final int? id;
  final String? paymentCode;
  final int? pnrId;
  final double? amount;
  final String? currency;
  final String? method; // DOKU_VA | BALANCE
  final String? status; // PENDING | PAID | FAILED | EXPIRED | REFUNDED
  final DateTime? expiredAt;
  final DateTime? paidAt;

  const PaymentViewEntity({
    this.id,
    this.paymentCode,
    this.pnrId,
    this.amount,
    this.currency,
    this.method,
    this.status,
    this.expiredAt,
    this.paidAt,
  });

  @override
  List<Object?> get props => [
    id,
    paymentCode,
    pnrId,
    amount,
    currency,
    method,
    status,
    expiredAt,
    paidAt,
  ];
}
