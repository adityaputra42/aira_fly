part of '../screen/flight_result_screen.dart';

class PriceDetail extends StatelessWidget {
  const PriceDetail({super.key, required this.pax, required this.departureFare, this.returnFare});

  final PaxCount pax;
  final ItineraryFareEntity? departureFare;

  final ItineraryFareEntity? returnFare;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    double total = 0;

    void addFareRows(String legLabel, ItineraryFareEntity? fare) {
      if (fare == null) return;

      if (pax.adult > 0) {
        final price = FareCalculator.priceForType(fare, 'ADT') * pax.adult;
        total += price;
        rows.add(_row(context, "$legLabel Adult ${pax.adult}x", price));
      }
      if (pax.child > 0) {
        final price = FareCalculator.priceForType(fare, 'CHD') * pax.child;
        total += price;
        rows.add(_row(context, "$legLabel Child ${pax.child}x", price));
      }
      if (pax.infant > 0) {
        final price = FareCalculator.priceForType(fare, 'INF') * pax.infant;
        total += price;
        rows.add(_row(context, "$legLabel Infant ${pax.infant}x", price));
      }
    }

    addFareRows(returnFare != null ? "Departure" : "Fare", departureFare);
    if (returnFare != null) addFareRows("Return", returnFare);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CardGeneral(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price Detail", style: AppFont.medium14),
            height(12),
            if (rows.isEmpty)
              Text(
                "Price unavailable for this itinerary.",
                style: AppFont.reguler14.copyWith(color: Theme.of(context).hintColor),
              )
            else ...[
              for (final row in rows) ...[row, height(8)],
              SizedBox(height: 1, child: Divider(thickness: 1, color: Theme.of(context).hintColor)),
              height(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: AppFont.reguler14.copyWith(color: Theme.of(context).hintColor),
                  ),
                  Text(
                    formatIDR(total),
                    style: AppFont.medium14.copyWith(color: AppColor.greenColor),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppFont.reguler14.copyWith(color: Theme.of(context).hintColor)),
        Text(formatIDR(price), style: AppFont.medium14),
      ],
    );
  }
}
