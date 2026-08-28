import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'airport_event.dart';
part 'airport_state.dart';

class AirportBloc extends Bloc<AirportEvent, AirportState> {
  AirportBloc() : super(AirportInitial()) {
    on<AirportEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
