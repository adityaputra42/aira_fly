import 'package:equatable/equatable.dart';

class AncillaryCategoryEntity extends Equatable {
  final int? id;
  final String? code;
  final String? name;
  final String? description;

  const AncillaryCategoryEntity({this.id, this.code, this.name, this.description});

  @override
  List<Object?> get props => [id, code, name, description];
}

/// A catalog item (an ancillary product), as returned by
/// GET /ancillaries, GET /ancillaries/{id}, and GET /ancillaries/flight/{flight_id}.
class AncillaryItemEntity extends Equatable {
  final int? id;
  final int? categoryId;
  final String? code;
  final String? name;
  final String? description;
  final bool? isActive;

  /// Null/omitted means "no price currently configured" -- this is a
  /// valid state on the backend (see CatalogItem doc), not missing data.
  final String? currentPrice;
  final String? currency;

  /// Only meaningful for [AncillaryItemEntity] returned from
  /// ListByFlight -- null there means unlimited for that flight; for
  /// plain catalog listing it reflects whatever inventory context, if
  /// any, the backend attached.
  final int? availableQuantity;

  const AncillaryItemEntity({
    this.id,
    this.categoryId,
    this.code,
    this.name,
    this.description,
    this.isActive,
    this.currentPrice,
    this.currency,
    this.availableQuantity,
  });

  @override
  List<Object?> get props => [
    id,
    categoryId,
    code,
    name,
    description,
    isActive,
    currentPrice,
    currency,
    availableQuantity,
  ];
}

/// A purchased ancillary attached to a PNR (booking_ancillaries row).
///
/// IMPORTANT business rule from the backend: purchasing an ancillary does
/// NOT charge the customer and does NOT update the PNR's total_amount.
/// [totalPrice] here is informational only -- it must be settled/charged
/// separately (see the payment feature) if your flow needs the customer
/// to actually pay for it.
class BookingAncillaryEntity extends Equatable {
  final int? id;
  final int? pnrId;
  final int? passengerId;
  final int? segmentId;
  final int? ancillaryId;
  final int? quantity;
  final double? unitPrice;
  final double? totalPrice;
  final String? status; // ACTIVE | CANCELLED
  final DateTime? purchasedAt;
  final DateTime? createdAt;
  final String? paymentStatus;
  final int? paymentId;

  const BookingAncillaryEntity({
    this.id,
    this.pnrId,
    this.passengerId,
    this.segmentId,
    this.ancillaryId,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
    this.status,
    this.purchasedAt,
    this.createdAt,
    this.paymentStatus,
    this.paymentId,
  });

  @override
  List<Object?> get props => [
    id,
    pnrId,
    passengerId,
    segmentId,
    ancillaryId,
    quantity,
    unitPrice,
    totalPrice,
    status,
    purchasedAt,
    createdAt,
    paymentStatus,
    paymentId,
  ];
}
