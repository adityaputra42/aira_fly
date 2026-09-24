import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/seat_class_entity.dart';
import '../../../domain/usecases/flight/get_seat_classes.dart';

part 'seat_class_event.dart';
part 'seat_class_state.dart';

class SeatClassBloc extends Bloc<SeatClassEvent, SeatClassState> {
  final GetSeatClasses getSeatClassesUseCase;
  SeatClassBloc({required this.getSeatClassesUseCase}) : super(SeatClassInitial()) {
    on<LoadSeatClassesRequested>(_onLoadSeatClassesRequested);
  }

  Future _onLoadSeatClassesRequested(
    LoadSeatClassesRequested event,
    Emitter<SeatClassState> emit,
  ) async {
    final current = state;
    if (!event.forceRefresh && current is SeatClassLoaded) {
      return;
    }

    emit(SeatClassLoading());

    final result = await getSeatClassesUseCase(
      GetSeatClassesParams(page: event.page, limit: event.limit),
    );

    result.fold(
      (failure) => emit(SeatClassError(failure.message)),
      (seatClasses) => emit(SeatClassLoaded(seatClasses)),
    );
  }
}
