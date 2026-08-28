import '../../domain/entities/payment_entity.dart';

/// Maps `createPaymentResponse` from POST /payments (snake_case json tags).
class PaymentModel extends PaymentEntity {
  const PaymentModel({
    super.paymentId,
    super.paymentCode,
    super.virtualAccountNo,
    super.channel,
    super.expiredAt,
    super.amount,
    super.currency,
    super.ticketPortion,
    super.ancillaryPortion,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      paymentId: json['payment_id'] as int?,
      paymentCode: json['payment_code'] as String?,
      virtualAccountNo: json['virtual_account_no'] as String?,
      channel: json['channel'] as String?,
      expiredAt: json['expired_at'] == null ? null : DateTime.tryParse(json['expired_at']),
      amount: double.tryParse('${json['amount']}'),
      currency: json['currency'] as String?,
      ticketPortion: double.tryParse('${json['ticket_portion']}'),
      ancillaryPortion: double.tryParse('${json['ancillary_portion']}'),
    );
  }
}

/// Maps `appquery.PaymentView` -- this Go struct has NO json tags, so it
/// serializes using the raw (capitalized) field names. Used by
/// GET /payments/{id}, GET /payments/pnr/{pnr_id}, and each item inside
/// GET /payments (admin list).
class PaymentViewModel extends PaymentViewEntity {
  const PaymentViewModel({
    super.id,
    super.paymentCode,
    super.pnrId,
    super.amount,
    super.currency,
    super.method,
    super.status,
    super.expiredAt,
    super.paidAt,
  });

  factory PaymentViewModel.fromJson(Map<String, dynamic> json) {
    return PaymentViewModel(
      id: json['ID'] as int?,
      paymentCode: json['PaymentCode'] as String?,
      pnrId: json['PNRID'] as int?,
      amount: double.tryParse('${json['Amount']}'),
      currency: json['Currency'] as String?,
      method: json['Method'] as String?,
      status: json['Status'] as String?,
      expiredAt: json['ExpiredAt'] == null ? null : DateTime.tryParse(json['ExpiredAt']),
      paidAt: json['PaidAt'] == null ? null : DateTime.tryParse(json['PaidAt']),
    );
  }
}

/// Maps `ListPaymentsResult` (outer wrapper has snake_case tags; nested
/// `items` are [PaymentViewModel], which use capitalized keys -- see above).
class PaymentListModel {
  final List<PaymentViewModel> items;
  final int total;
  final int page;
  final int limit;

  const PaymentListModel({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PaymentListModel.fromJson(Map<String, dynamic> json) {
    return PaymentListModel(
      items: (json['items'] as List? ?? [])
          .map((e) => PaymentViewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
    );
  }
}
