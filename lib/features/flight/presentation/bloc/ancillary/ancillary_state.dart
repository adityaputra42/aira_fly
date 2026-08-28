part of 'ancillary_bloc.dart';

sealed class AncillaryState extends Equatable {
  const AncillaryState();

  @override
  List<Object?> get props => [];
}

final class AncillaryInitial extends AncillaryState {}

class AncillaryLoading extends AncillaryState {}

class AncillaryCategoriesLoaded extends AncillaryState {
  final List<AncillaryCategoryEntity> categories;

  const AncillaryCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class AncillaryCatalogLoaded extends AncillaryState {
  final List<AncillaryItemEntity> items;

  const AncillaryCatalogLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class AncillaryLoaded extends AncillaryState {
  final AncillaryItemEntity item;

  const AncillaryLoaded(this.item);

  @override
  List<Object?> get props => [item];
}

class AncillaryFlightCatalogLoaded extends AncillaryState {
  final List<AncillaryItemEntity> items;

  const AncillaryFlightCatalogLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class AncillaryPurchased extends AncillaryState {
  final BookingAncillaryEntity purchase;

  const AncillaryPurchased(this.purchase);

  @override
  List<Object?> get props => [purchase];
}

class AncillaryPurchaseCancelled extends AncillaryState {
  final BookingAncillaryEntity purchase;

  const AncillaryPurchaseCancelled(this.purchase);

  @override
  List<Object?> get props => [purchase];
}

class AncillaryPurchasesByPnrLoaded extends AncillaryState {
  final List<BookingAncillaryEntity> purchases;

  const AncillaryPurchasesByPnrLoaded(this.purchases);

  @override
  List<Object?> get props => [purchases];
}

class AncillaryError extends AncillaryState {
  final String message;

  const AncillaryError(this.message);

  @override
  List<Object?> get props => [message];
}
