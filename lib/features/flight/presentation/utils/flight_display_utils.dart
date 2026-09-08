import 'package:intl/intl.dart';

import '../../domain/entities/itinerary_entity.dart';

class PaxCount {
  final int adult;
  final int child;
  final int infant;

  const PaxCount({required this.adult, required this.child, required this.infant});

  int get total => adult + child + infant;
}

class FareCalculator {
  const FareCalculator._();

  static ItineraryFareEntity? cheapestFare(List<ItineraryFareEntity>? fares, PaxCount pax) {
    if (fares == null || fares.isEmpty) return null;

    ItineraryFareEntity? cheapest;
    double cheapestTotal = double.infinity;

    for (final fare in fares) {
      final total = totalForFare(fare, pax);
      if (total < cheapestTotal) {
        cheapestTotal = total;
        cheapest = fare;
      }
    }

    return cheapest;
  }

  static double totalForFare(ItineraryFareEntity fare, PaxCount pax) {
    return _priceFor(fare, 'ADT') * pax.adult +
        _priceFor(fare, 'CHD') * pax.child +
        _priceFor(fare, 'INF') * pax.infant;
  }

  static double priceForType(ItineraryFareEntity fare, String passengerType) =>
      _priceFor(fare, passengerType);

  static double _priceFor(ItineraryFareEntity fare, String passengerType) {
    final raw = fare.prices?[passengerType];
    if (raw == null) return 0;
    return double.tryParse(raw) ?? 0;
  }
}

String formatIDR(num value) {
  return NumberFormat.currency(locale: "id_ID", symbol: "Rp ", decimalDigits: 0).format(value);
}

String formatFlightDuration(int? minutes) {
  if (minutes == null) return '-';
  final hours = minutes ~/ 60;
  final mins = minutes % 60;
  if (hours == 0) return '${mins}m';
  if (mins == 0) return '${hours}h';
  return '${hours}h ${mins}m';
}

/// "Non Stop", "1 Stop", "2 Stops".
String formatStops(int? stops) {
  final count = stops ?? 0;
  if (count == 0) return 'Non Stop';
  return '$count Stop${count > 1 ? 's' : ''}';
}
