import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/ancillary_entity.dart';
import '../../../domain/usecases/ancillary/cancel_ancillary_purchase.dart';
import '../../../domain/usecases/ancillary/get_ancillary.dart';
import '../../../domain/usecases/ancillary/list_ancillaries_by_flight.dart';
import '../../../domain/usecases/ancillary/list_ancillary_catalog.dart';
import '../../../domain/usecases/ancillary/list_ancillary_categories.dart';
import '../../../domain/usecases/ancillary/list_ancillary_purchases_by_pnr.dart';
import '../../../domain/usecases/ancillary/purchase_ancillary.dart';

part 'ancillary_event.dart';
part 'ancillary_state.dart';

class AncillaryBloc extends Bloc<AncillaryEvent, AncillaryState> {
  final ListAncillaryCategories listCategoriesUseCase;
  final ListAncillaryCatalog listCatalogUseCase;
  final GetAncillary getAncillaryUseCase;
  final ListAncillariesByFlight listByFlightUseCase;
  final PurchaseAncillary purchaseAncillaryUseCase;
  final CancelAncillaryPurchase cancelPurchaseUseCase;
  final ListAncillaryPurchasesByPnr listPurchasesByPnrUseCase;

  AncillaryBloc({
    required this.listCategoriesUseCase,
    required this.listCatalogUseCase,
    required this.getAncillaryUseCase,
    required this.listByFlightUseCase,
    required this.purchaseAncillaryUseCase,
    required this.cancelPurchaseUseCase,
    required this.listPurchasesByPnrUseCase,
  }) : super(AncillaryInitial()) {
    on<LoadAncillaryCategoriesRequested>(_onLoadCategories);
    on<LoadAncillaryCatalogRequested>(_onLoadCatalog);
    on<LoadAncillaryRequested>(_onLoadAncillary);
    on<LoadAncillariesByFlightRequested>(_onLoadByFlight);
    on<PurchaseAncillaryRequested>(_onPurchase);
    on<CancelAncillaryPurchaseRequested>(_onCancelPurchase);
    on<LoadAncillaryPurchasesByPnrRequested>(_onLoadPurchasesByPnr);
  }

  Future _onLoadCategories(LoadAncillaryCategoriesRequested event, Emitter emit) async {
    emit(AncillaryLoading());
    final result = await listCategoriesUseCase(
      ListAncillaryCategoriesParams(page: event.page, limit: event.limit),
    );
    result.fold(
      (failure) => emit(AncillaryError(failure.message)),
      (categories) => emit(AncillaryCategoriesLoaded(categories)),
    );
  }

  Future _onLoadCatalog(LoadAncillaryCatalogRequested event, Emitter emit) async {
    emit(AncillaryLoading());
    final result = await listCatalogUseCase(
      ListAncillaryCatalogParams(
        categoryId: event.categoryId,
        activeOnly: event.activeOnly,
        page: event.page,
        limit: event.limit,
      ),
    );
    result.fold(
      (failure) => emit(AncillaryError(failure.message)),
      (items) => emit(AncillaryCatalogLoaded(items)),
    );
  }

  Future _onLoadAncillary(LoadAncillaryRequested event, Emitter emit) async {
    emit(AncillaryLoading());
    final result = await getAncillaryUseCase(GetAncillaryParams(id: event.id));
    result.fold(
      (failure) => emit(AncillaryError(failure.message)),
      (item) => emit(AncillaryLoaded(item)),
    );
  }

  Future _onLoadByFlight(LoadAncillariesByFlightRequested event, Emitter emit) async {
    emit(AncillaryLoading());
    final result = await listByFlightUseCase(
      ListAncillariesByFlightParams(flightId: event.flightId),
    );
    result.fold(
      (failure) => emit(AncillaryError(failure.message)),
      (items) => emit(AncillaryFlightCatalogLoaded(items)),
    );
  }

  Future _onPurchase(PurchaseAncillaryRequested event, Emitter emit) async {
    emit(AncillaryLoading());
    final result = await purchaseAncillaryUseCase(
      PurchaseAncillaryParams(
        pnrId: event.pnrId,
        passengerId: event.passengerId,
        segmentId: event.segmentId,
        ancillaryId: event.ancillaryId,
        flightId: event.flightId,
        quantity: event.quantity,
      ),
    );
    result.fold(
      (failure) => emit(AncillaryError(failure.message)),
      (purchase) => emit(AncillaryPurchased(purchase)),
    );
  }

  Future _onCancelPurchase(CancelAncillaryPurchaseRequested event, Emitter emit) async {
    emit(AncillaryLoading());
    final result = await cancelPurchaseUseCase(CancelAncillaryPurchaseParams(id: event.id));
    result.fold(
      (failure) => emit(AncillaryError(failure.message)),
      (purchase) => emit(AncillaryPurchaseCancelled(purchase)),
    );
  }

  Future _onLoadPurchasesByPnr(LoadAncillaryPurchasesByPnrRequested event, Emitter emit) async {
    emit(AncillaryLoading());
    final result = await listPurchasesByPnrUseCase(
      ListAncillaryPurchasesByPnrParams(pnrId: event.pnrId),
    );
    result.fold(
      (failure) => emit(AncillaryError(failure.message)),
      (purchases) => emit(AncillaryPurchasesByPnrLoaded(purchases)),
    );
  }
}
