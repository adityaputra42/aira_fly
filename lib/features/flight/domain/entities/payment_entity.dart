import 'package:equatable/equatable.dart';

import 'pnr_entity.dart';

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

class CreatePaymentResponseEntity extends Equatable {
  final PaymentEntity payment;
  final PnrDetailEntity? pnr;

  const CreatePaymentResponseEntity({required this.payment, this.pnr});

  @override
  List<Object?> get props => [payment, pnr];
}

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
