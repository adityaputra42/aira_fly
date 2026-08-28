import '../../domain/entities/pnr_entity.dart';

/// Maps POST /bookings/pnrs response.
/// Backend struct `command.CreatePNRResult` has NO json tags, so Go
/// serializes it using the raw (capitalized) field names.
class PnrModel extends PnrEntity {
  const PnrModel({
    super.pnrId,
    super.bookingCode,
    super.status,
    super.expiresAt,
    super.totalAmount,
    super.currency,
  });

  factory PnrModel.fromJson(Map<String, dynamic> json) {
    return PnrModel(
      pnrId: json['PNRID'] as int?,
      bookingCode: json['BookingCode'] as String?,
      status: json['Status'] as String?,
      expiresAt: json['ExpiresAt'] == null
          ? null
          : DateTime.tryParse(json['ExpiresAt']),
      totalAmount: (json['TotalAmount'] as num?)?.toDouble(),
      currency: json['Currency'] as String?,
    );
  }
}

/// Maps GET /bookings/pnrs/{id} response.
/// Backend struct `bookingcontract.PNRInfo` also has NO json tags -- same
/// capitalized-key situation as [PnrModel] above. This is an admin-only
/// endpoint on the backend (`booking:pnr:view` permission required).
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
  });

  factory PnrDetailModel.fromJson(Map<String, dynamic> json) {
    return PnrDetailModel(
      id: json['ID'] as int?,
      bookingCode: json['BookingCode'] as String?,
      status: json['Status'] as String?,
      paymentStatus: json['PaymentStatus'] as String?,
      totalAmount: double.tryParse('${json['TotalAmount']}'),
      currency: json['Currency'] as String?,
      holdExpiresAt: json['HoldExpiresAt'] == null
          ? null
          : DateTime.tryParse(json['HoldExpiresAt']),
      contactName: json['ContactName'] as String?,
      contactEmail: json['ContactEmail'] as String?,
      contactPhone: json['ContactPhone'] as String?,
      createdBy: json['CreatedBy'] as int?,
    );
  }
}

/// Maps one item of GET /bookings/pnrs (admin list, `booking:pnr:view`).
/// Backend struct `query.PNRSummary` DOES have snake_case json tags.
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
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at']),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.tryParse(json['expires_at']),
    );
  }
}

/// Maps the `ListPNRsResult` wrapper `{ items, total, page, limit }`
/// (this outer wrapper DOES have snake_case json tags, unlike the two
/// models above).
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
