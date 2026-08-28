import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/ticket_entity.dart';
import '../../domain/usecases/check_in.dart';
import '../../domain/usecases/get_boarding_pass.dart';

part 'ticket_event.dart';
part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final CheckIn checkInUseCase;
  final GetBoardingPass getBoardingPassUseCase;

  TicketBloc({required this.checkInUseCase, required this.getBoardingPassUseCase})
    : super(TicketInitial()) {
    on<CheckInRequested>(_onCheckIn);
    on<LoadBoardingPassRequested>(_onLoadBoardingPass);
  }

  Future _onCheckIn(CheckInRequested event, Emitter emit) async {
    emit(TicketLoading());

    final result = await checkInUseCase(
      CheckInParams(
        ticketNumber: event.ticketNumber,
        baggageCount: event.baggageCount,
        baggageWeightKg: event.baggageWeightKg,
      ),
    );

    result.fold(
      (failure) => emit(TicketError(failure.message)),
      (checkInResult) => emit(CheckedIn(checkInResult)),
    );
  }

  Future _onLoadBoardingPass(LoadBoardingPassRequested event, Emitter emit) async {
    emit(TicketLoading());

    final result = await getBoardingPassUseCase(
      GetBoardingPassParams(passengerId: event.passengerId, segmentId: event.segmentId),
    );

    result.fold(
      (failure) => emit(TicketError(failure.message)),
      (boardingPass) => emit(BoardingPassLoaded(boardingPass)),
    );
  }
}
