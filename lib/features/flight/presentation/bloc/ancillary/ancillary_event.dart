part of 'ancillary_bloc.dart';

sealed class AncillaryEvent extends Equatable {
  const AncillaryEvent();

  @override
  List<Object?> get props => [];
}

class LoadAncillaryCategoriesRequested extends AncillaryEvent {
  final int page;
  final int limit;

  const LoadAncillaryCategoriesRequested({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class LoadAncillaryCatalogRequested extends AncillaryEvent {
  final int? categoryId;
  final bool activeOnly;
  final int page;
  final int limit;

  const LoadAncillaryCatalogRequested({
    this.categoryId,
    this.activeOnly = true,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [categoryId, activeOnly, page, limit];
}

class LoadAncillaryRequested extends AncillaryEvent {
  final int id;

  const LoadAncillaryRequested({required this.id});

  @override
  List<Object?> get props => [id];
}

class LoadAncillariesByFlightRequested extends AncillaryEvent {
  final int flightId;

  const LoadAncillariesByFlightRequested({required this.flightId});

  @override
  List<Object?> get props => [flightId];
}

class PurchaseAncillaryRequested extends AncillaryEvent {
  final int pnrId;
  final int? passengerId;
  final int? segmentId;
  final int ancillaryId;
  final int? flightId;
  final int quantity;

  const PurchaseAncillaryRequested({
    required this.pnrId,
    this.passengerId,
    this.segmentId,
    required this.ancillaryId,
    this.flightId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [pnrId, passengerId, segmentId, ancillaryId, flightId, quantity];
}

class CancelAncillaryPurchaseRequested extends AncillaryEvent {
  final int id;

  const CancelAncillaryPurchaseRequested({required this.id});

  @override
  List<Object?> get props => [id];
}

class LoadAncillaryPurchasesByPnrRequested extends AncillaryEvent {
  final int pnrId;

  const LoadAncillaryPurchasesByPnrRequested({required this.pnrId});

  @override
  List<Object?> get props => [pnrId];
}
