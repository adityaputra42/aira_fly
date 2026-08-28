import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/pnr_entity.dart';
import '../../../domain/repository/booking_repository.dart';
import '../../../domain/usecases/booking/cancel_pnr.dart';
import '../../../domain/usecases/booking/create_pnr.dart';
import '../../../domain/usecases/booking/get_pnr.dart';
import '../../../domain/usecases/booking/list_pnrs.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CreatePnr createPnrUseCase;
  final GetPnr getPnrUseCase;
  final ListPnrs listPnrsUseCase;
  final CancelPnr cancelPnrUseCase;

  BookingBloc({
    required this.createPnrUseCase,
    required this.getPnrUseCase,
    required this.listPnrsUseCase,
    required this.cancelPnrUseCase,
  }) : super(BookingInitial()) {
    on<CreatePnrRequested>(_onCreatePnrRequested);
    on<LoadPnrRequested>(_onLoadPnrRequested);
    on<LoadPnrListRequested>(_onLoadPnrListRequested);
    on<CancelPnrRequested>(_onCancelPnrRequested);
  }

  Future _onCreatePnrRequested(CreatePnrRequested event, Emitter emit) async {
    emit(BookingLoading());

    final result = await createPnrUseCase(
      CreatePnrParams(
        contact: event.contact,
        passengers: event.passengers,
        segments: event.segments,
        seatSelections: event.seatSelections,
        holdTtlSeconds: event.holdTtlSeconds,
      ),
    );

    result.fold((failure) => emit(BookingError(failure.message)), (pnr) => emit(PnrCreated(pnr)));
  }

  Future _onLoadPnrRequested(LoadPnrRequested event, Emitter emit) async {
    emit(BookingLoading());

    final result = await getPnrUseCase(GetPnrParams(id: event.id));

    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (pnr) => emit(PnrDetailLoaded(pnr)),
    );
  }

  Future _onLoadPnrListRequested(LoadPnrListRequested event, Emitter emit) async {
    emit(BookingLoading());

    final result = await listPnrsUseCase(
      ListPnrsParams(page: event.page, limit: event.limit, status: event.status),
    );

    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (pnrs) => emit(PnrListLoaded(pnrs)),
    );
  }

  Future _onCancelPnrRequested(CancelPnrRequested event, Emitter emit) async {
    emit(BookingLoading());

    final result = await cancelPnrUseCase(CancelPnrParams(id: event.id));

    result.fold((failure) => emit(BookingError(failure.message)), (_) => emit(PnrCancelled()));
  }
}
