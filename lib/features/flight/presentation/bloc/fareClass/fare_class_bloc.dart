import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/fare_class_entity.dart';
import '../../../domain/usecases/flight/get_fare_classes.dart';

part 'fare_class_event.dart';
part 'fare_class_state.dart';

class FareClassBloc extends Bloc<FareClassEvent, FareClassState> {
  final GetFareClasses getFareClassesUseCase;

  FareClassBloc({required this.getFareClassesUseCase}) : super(FareClassInitial()) {
    on<LoadFareClassesRequested>(_onLoadFareClassesRequested);
  }

  Future _onLoadFareClassesRequested(
    LoadFareClassesRequested event,
    Emitter<FareClassState> emit,
  ) async {
    final current = state;
    if (!event.forceRefresh && current is FareClassLoaded) {
      return;
    }

    emit(FareClassLoading());

    final result = await getFareClassesUseCase(
      GetFareClassesParams(page: event.page, limit: event.limit),
    );

    result.fold(
      (failure) => emit(FareClassError(failure.message)),
      (fareClasses) => emit(FareClassLoaded(fareClasses)),
    );
  }
}
