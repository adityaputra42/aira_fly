import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../entities/pnr_entity.dart';
import '../../repository/booking_repository.dart';

class CreatePnr implements UseCase<PnrEntity, CreatePnrParams> {
  final BookingRepository bookingRepository;

  const CreatePnr(this.bookingRepository);

  @override
  Future<Either<Failure, PnrEntity>> call(CreatePnrParams params) {
    return bookingRepository.createPnr(
      contact: params.contact,
      passengers: params.passengers,
      segments: params.segments,
      seatSelections: params.seatSelections,
      holdTtlSeconds: params.holdTtlSeconds,
    );
  }
}

class CreatePnrParams {
  final ContactInput contact;
  final List<PassengerInput> passengers;
  final List<BookingSegmentInput> segments;
  final List<SeatSelectionInput> seatSelections;
  final int holdTtlSeconds; // 0 -> backend default (10 minutes)

  const CreatePnrParams({
    required this.contact,
    required this.passengers,
    required this.segments,
    required this.seatSelections,
    this.holdTtlSeconds = 0,
  });
}
