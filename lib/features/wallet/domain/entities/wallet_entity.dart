import 'package:equatable/equatable.dart';

/// GET /wallet/balance -- always the caller's own wallet.
class BalanceEntity extends Equatable {
  final double? balance;
  final String? currency;

  const BalanceEntity({this.balance, this.currency});

  @override
  List<Object?> get props => [balance, currency];
}

/// One row of GET /wallet/transactions (the wallet ledger).
class WalletTransactionEntity extends Equatable {
  final int? id;
  final String? type; // e.g. CREDIT_TOPUP, DEBIT_PAYMENT
  final double? amount;
  final double? balanceAfter;
  final String? referenceType;
  final String? referenceId;
  final String? description;
  final DateTime? createdAt;

  const WalletTransactionEntity({
    this.id,
    this.type,
    this.amount,
    this.balanceAfter,
    this.referenceType,
    this.referenceId,
    this.description,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    amount,
    balanceAfter,
    referenceType,
    referenceId,
    description,
    createdAt,
  ];
}

/// Result of POST /wallet/topup.
///
/// IMPORTANT: the wallet balance is only credited once DOKU's payment
/// notification arrives -- it is NOT credited immediately when this call
/// succeeds. Poll GetTopup(topupCode) or refresh GetBalance after the
/// customer completes payment on their bank app.
class TopupEntity extends Equatable {
  final String? topupCode;
  final String? virtualAccountNo;
  final String? channel;
  final DateTime? expiredAt;
  final double? amount;
  final String? currency;

  const TopupEntity({
    this.topupCode,
    this.virtualAccountNo,
    this.channel,
    this.expiredAt,
    this.amount,
    this.currency,
  });

  @override
  List<Object?> get props => [topupCode, virtualAccountNo, channel, expiredAt, amount, currency];
}

/// GET /wallet/topup/{code} -- current status of a topup request.
class TopupStatusEntity extends Equatable {
  final String? topupCode;
  final String? status; // PENDING | PAID | FAILED | EXPIRED
  final double? amount;
  final String? currency;
  final String? virtualAccountNo;
  final String? channel;
  final DateTime? expiredAt;
  final DateTime? paidAt;

  const TopupStatusEntity({
    this.topupCode,
    this.status,
    this.amount,
    this.currency,
    this.virtualAccountNo,
    this.channel,
    this.expiredAt,
    this.paidAt,
  });

  @override
  List<Object?> get props => [
    topupCode,
    status,
    amount,
    currency,
    virtualAccountNo,
    channel,
    expiredAt,
    paidAt,
  ];
}
