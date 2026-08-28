import '../../domain/entities/wallet_entity.dart';

/// Maps `query.BalanceView` (snake_case json tags).
class BalanceModel extends BalanceEntity {
  const BalanceModel({super.balance, super.currency});

  factory BalanceModel.fromJson(Map<String, dynamic> json) {
    return BalanceModel(
      balance: double.tryParse('${json['balance']}'),
      currency: json['currency'] as String?,
    );
  }
}

/// Maps `query.TransactionView` (snake_case json tags).
class WalletTransactionModel extends WalletTransactionEntity {
  const WalletTransactionModel({
    super.id,
    super.type,
    super.amount,
    super.balanceAfter,
    super.referenceType,
    super.referenceId,
    super.description,
    super.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] as int?,
      type: json['type'] as String?,
      amount: double.tryParse('${json['amount']}'),
      balanceAfter: double.tryParse('${json['balance_after']}'),
      referenceType: json['reference_type'] as String?,
      referenceId: json['reference_id'] as String?,
      description: json['description'] as String?,
      createdAt: json['created_at'] == null ? null : DateTime.tryParse(json['created_at']),
    );
  }
}

/// Maps `ListTransactionsResult` (snake_case json tags throughout).
class WalletTransactionListModel {
  final List<WalletTransactionModel> items;
  final int total;
  final int page;
  final int limit;

  const WalletTransactionListModel({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory WalletTransactionListModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionListModel(
      items: (json['items'] as List? ?? [])
          .map((e) => WalletTransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
    );
  }
}

/// Maps `topupResponse` from POST /wallet/topup (snake_case json tags).
class TopupModel extends TopupEntity {
  const TopupModel({
    super.topupCode,
    super.virtualAccountNo,
    super.channel,
    super.expiredAt,
    super.amount,
    super.currency,
  });

  factory TopupModel.fromJson(Map<String, dynamic> json) {
    return TopupModel(
      topupCode: json['topup_code'] as String?,
      virtualAccountNo: json['virtual_account_no'] as String?,
      channel: json['channel'] as String?,
      expiredAt: json['expired_at'] == null ? null : DateTime.tryParse(json['expired_at']),
      amount: double.tryParse('${json['amount']}'),
      currency: json['currency'] as String?,
    );
  }
}

/// Maps `query.TopupView` from GET /wallet/topup/{code} (snake_case json
/// tags; several fields are `omitempty` and may be absent).
class TopupStatusModel extends TopupStatusEntity {
  const TopupStatusModel({
    super.topupCode,
    super.status,
    super.amount,
    super.currency,
    super.virtualAccountNo,
    super.channel,
    super.expiredAt,
    super.paidAt,
  });

  factory TopupStatusModel.fromJson(Map<String, dynamic> json) {
    return TopupStatusModel(
      topupCode: json['topup_code'] as String?,
      status: json['status'] as String?,
      amount: double.tryParse('${json['amount']}'),
      currency: json['currency'] as String?,
      virtualAccountNo: json['virtual_account_no'] as String?,
      channel: json['channel'] as String?,
      expiredAt: json['expired_at'] == null ? null : DateTime.tryParse(json['expired_at']),
      paidAt: json['paid_at'] == null ? null : DateTime.tryParse(json['paid_at']),
    );
  }
}
