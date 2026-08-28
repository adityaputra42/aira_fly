import '../../domain/entities/ancillary_entity.dart';

/// Maps `querydb.AncillaryCategory` (snake_case json tags).
class AncillaryCategoryModel extends AncillaryCategoryEntity {
  const AncillaryCategoryModel({super.id, super.code, super.name, super.description});

  factory AncillaryCategoryModel.fromJson(Map<String, dynamic> json) {
    return AncillaryCategoryModel(
      id: json['id'] as int?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
    );
  }
}

/// Maps `appquery.CatalogItem` -- this Go struct has NO json tags, so it
/// serializes using the raw (capitalized) field names. Used by
/// GET /ancillaries, GET /ancillaries/{id}, and GET /ancillaries/flight/{flight_id}.
class AncillaryItemModel extends AncillaryItemEntity {
  const AncillaryItemModel({
    super.id,
    super.categoryId,
    super.code,
    super.name,
    super.description,
    super.isActive,
    super.currentPrice,
    super.currency,
    super.availableQuantity,
  });

  factory AncillaryItemModel.fromJson(Map<String, dynamic> json) {
    return AncillaryItemModel(
      id: json['ID'] as int?,
      categoryId: json['CategoryID'] as int?,
      code: json['Code'] as String?,
      name: json['Name'] as String?,
      description: json['Description'] as String?,
      isActive: json['IsActive'] as bool?,
      currentPrice: json['CurrentPrice']?.toString(),
      currency: json['Currency'] as String?,
      availableQuantity: json['AvailableQuantity'] as int?,
    );
  }
}

/// Maps `commanddb.BookingAncillary` / `querydb.BookingAncillary`
/// (snake_case json tags) -- the result of a purchase, a cancel, and each
/// row of ListByPNR.
class BookingAncillaryModel extends BookingAncillaryEntity {
  const BookingAncillaryModel({
    super.id,
    super.pnrId,
    super.passengerId,
    super.segmentId,
    super.ancillaryId,
    super.quantity,
    super.unitPrice,
    super.totalPrice,
    super.status,
    super.purchasedAt,
    super.createdAt,
    super.paymentStatus,
    super.paymentId,
  });

  factory BookingAncillaryModel.fromJson(Map<String, dynamic> json) {
    return BookingAncillaryModel(
      id: json['id'] as int?,
      pnrId: json['pnr_id'] as int?,
      passengerId: json['passenger_id'] as int?,
      segmentId: json['segment_id'] as int?,
      ancillaryId: json['ancillary_id'] as int?,
      quantity: json['quantity'] as int?,
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      status: json['status'] as String?,
      purchasedAt: json['purchased_at'] == null
          ? null
          : DateTime.tryParse(json['purchased_at']),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at']),
      paymentStatus: json['payment_status'] as String?,
      paymentId: json['payment_id'] as int?,
    );
  }
}

/// Maps the `{ items, total, page, limit }` wrapper used by
/// ListCategories and ListCatalog (has snake_case json tags on the outer
/// map, since it's built inline as `map[string]any` in the handler).
class AncillaryListModel<T> {
  final List<T> items;
  final int total;
  final int page;
  final int limit;

  const AncillaryListModel({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory AncillaryListModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return AncillaryListModel(
      items: (json['items'] as List? ?? [])
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
    );
  }
}
