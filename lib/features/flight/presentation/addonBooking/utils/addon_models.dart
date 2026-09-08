import '../../../../flight/domain/entities/ancillary_entity.dart';
import '../../../domain/entities/flight_seat_entity.dart';
import '../../../domain/entities/itinerary_entity.dart';
import '../../../domain/repository/booking_repository.dart';
import '../../flightResult/screen/flight_result_screen.dart';
import '../../paxBooking/screen/pax_booking_screen.dart';

class AddonLeg {
  final String label;
  final int flightId;
  final ItineraryEntity itinerary;

  const AddonLeg({required this.label, required this.flightId, required this.itinerary});
}

List<AddonLeg> buildAddonLegs(FlightResultArguments args) {
  final legs = <AddonLeg>[];

  final departureSegments = args.departure.segments ?? const [];
  if (departureSegments.isNotEmpty && departureSegments.first.flightId != null) {
    legs.add(
      AddonLeg(
        label: "Departure Flight",
        flightId: departureSegments.first.flightId!,
        itinerary: args.departure,
      ),
    );
  }

  if (args.returnItinerary != null) {
    final returnSegments = args.returnItinerary!.segments ?? const [];
    if (returnSegments.isNotEmpty && returnSegments.first.flightId != null) {
      legs.add(
        AddonLeg(
          label: "Return Flight",
          flightId: returnSegments.first.flightId!,
          itinerary: args.returnItinerary!,
        ),
      );
    }
  }

  return legs;
}

enum AncillaryKind { baggage, meal }

class SelectedAncillary {
  final AncillaryItemEntity item;
  final int flightId;
  final int passengerIndex;

  const SelectedAncillary({
    required this.item,
    required this.flightId,
    required this.passengerIndex,
  });
}

class SelectedSeat {
  final FlightSeatEntity seat;
  final int flightId;
  final int passengerIndex;

  const SelectedSeat({required this.seat, required this.flightId, required this.passengerIndex});
}

double sumAncillaryPrices(List<SelectedAncillary> selections) {
  double total = 0;
  for (final selection in selections) {
    total += double.tryParse(selection.item.currentPrice ?? '') ?? 0;
  }
  return total;
}

class AncillaryPickerArguments {
  final AncillaryKind kind;
  final AddonLeg leg;
  final List<PassengerInput> passengers;

  final List<SelectedAncillary> currentSelections;

  const AncillaryPickerArguments({
    required this.kind,
    required this.leg,
    required this.passengers,
    required this.currentSelections,
  });
}

class SeatPickerArguments {
  final AddonLeg leg;
  final List<PassengerInput> passengers;

  final List<SelectedSeat> currentSelections;

  const SeatPickerArguments({
    required this.leg,
    required this.passengers,
    required this.currentSelections,
  });
}

class AncillaryHubArguments {
  final PaxBookingResult paxBookingResult;
  final List<SelectedAncillary> currentSelections;

  const AncillaryHubArguments({required this.paxBookingResult, required this.currentSelections});
}

class SeatHubArguments {
  final PaxBookingResult paxBookingResult;
  final List<SelectedSeat> currentSelections;

  const SeatHubArguments({required this.paxBookingResult, required this.currentSelections});
}

class AddonBookingResult {
  final PaxBookingResult paxBookingResult;
  final List<SelectedAncillary> baggage;
  final List<SelectedAncillary> meals;
  final List<SelectedSeat> seats;

  const AddonBookingResult({
    required this.paxBookingResult,
    required this.baggage,
    required this.meals,
    required this.seats,
  });
}
