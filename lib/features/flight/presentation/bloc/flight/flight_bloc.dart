import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/airport_entity.dart';
import '../../../domain/entities/flight_seat_entity.dart';
import '../../../domain/entities/itinerary_entity.dart';
import '../../../domain/usecases/flight/get_airports.dart';
import '../../../domain/usecases/flight/get_flight_seats.dart';
import '../../../domain/usecases/flight/search_flights.dart';

part 'flight_event.dart';
part 'flight_state.dart';

class FlightBloc extends Bloc<FlightEvent, FlightState> {
  final GetAirports getAirportsUseCase;
  final SearchFlights searchFlightsUseCase;
  final GetFlightSeats getFlightSeatsUseCase;

  FlightBloc({
    required this.getAirportsUseCase,
    required this.searchFlightsUseCase,
    required this.getFlightSeatsUseCase,
  }) : super(FlightInitial()) {
    on<LoadAirportsRequested>(_onLoadAirportsRequested);
    on<SearchFlightsRequested>(_onSearchFlightsRequested);
    on<LoadFlightSeatsRequested>(_onLoadFlightSeatsRequested);
  }

  Future _onLoadAirportsRequested(LoadAirportsRequested event, Emitter emit) async {
    emit(AirportsLoading());

    final result = await getAirportsUseCase(
      GetAirportsParams(page: event.page, limit: event.limit),
    );

    result.fold(
      (failure) => emit(FlightError(failure.message)),
      (airports) => emit(AirportsLoaded(airports)),
    );
  }

  Future _onSearchFlightsRequested(SearchFlightsRequested event, Emitter emit) async {
    emit(FlightSearchLoading());

    final result = await searchFlightsUseCase(
      SearchFlightsParams(
        departureAirportId: event.departureAirportId,
        arrivalAirportId: event.arrivalAirportId,
        date: event.date,
        tripType: event.tripType,
        returnDate: event.returnDate,
        maxStops: event.maxStops,
        totalPax: event.totalPax,
        seatClassId: event.seatClassId,
        page: event.page,
        limit: event.limit,
      ),
    );

    result.fold(
      (failure) => emit(FlightError(failure.message)),
      (searchResult) => emit(FlightSearchLoaded(searchResult)),
    );
  }

  Future _onLoadFlightSeatsRequested(LoadFlightSeatsRequested event, Emitter emit) async {
    emit(FlightSeatsLoading());

    final result = await getFlightSeatsUseCase(GetFlightSeatsParams(flightId: event.flightId));

    result.fold(
      (failure) => emit(FlightError(failure.message)),
      (seats) => emit(FlightSeatsLoaded(seats)),
    );
  }
}
