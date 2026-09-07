part of '../screen/flight_result_screen.dart';

class CardInfoFlight extends StatelessWidget {
  const CardInfoFlight({
    super.key,
    this.itinerary,
    this.originAirport,
    this.destinationAirport,
    this.isReturn = false,
  });

  final ItineraryEntity? itinerary;
  final AirportEntity? originAirport;
  final AirportEntity? destinationAirport;
  final bool isReturn;

  String _formatDateTime(DateTime? dt) =>
      dt == null ? '-' : DateFormat("dd MMM yyyy, HH:mm").format(dt);

  @override
  Widget build(BuildContext context) {
    final segments = itinerary?.segments ?? const <SegmentEntity>[];
    final first = segments.isNotEmpty ? segments.first : null;
    final last = segments.isNotEmpty ? segments.last : null;

    final hasRealData = itinerary != null && originAirport != null && destinationAirport != null;

    final departureTimeText = hasRealData
        ? _formatDateTime(first?.departureTime)
        : DateFormat(
            "dd MMM yyyy, HH:mm",
          ).format(isReturn ? DateTime.now().add(Duration(days: 5)) : DateTime.now());
    final arrivalTimeText = hasRealData
        ? _formatDateTime(last?.arrivalTime)
        : DateFormat("dd MMM yyyy, HH:mm").format(
            isReturn
                ? DateTime.now().add(Duration(days: 5, hours: 2, minutes: 45))
                : DateTime.now().add(Duration(hours: 2, minutes: 45)),
          );
    final originCode = hasRealData ? (originAirport!.code ?? '-') : (isReturn ? "DPS" : "CGK");
    final originCity = hasRealData
        ? (originAirport!.city ?? '-')
        : (isReturn ? "Denpasar" : "Jakarta");
    final destinationCode = hasRealData
        ? (destinationAirport!.code ?? '-')
        : (isReturn ? "CGK" : "DPS");
    final destinationCity = hasRealData
        ? (destinationAirport!.city ?? '-')
        : (isReturn ? "Jakarta" : "Denpasar");

    return CardGeneral(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Iconify(Mdi.airplane_takeoff, size: 16, color: AppColor.secondaryColor),
                  width(4),
                  Text(
                    departureTimeText,
                    style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
              Row(
                children: [
                  Iconify(Mdi.airplane_landing, size: 16, color: AppColor.secondaryColor),
                  width(4),
                  Text(
                    arrivalTimeText,
                    style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            ],
          ),
          height(8),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(originCode, style: AppFont.semibold20),
                  height(2),
                  Text(
                    originCity,
                    style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        generateDashedDivider(context.w(0.2), dashColor: AppColor.secondaryColor),
                        width(8),
                        Transform.rotate(
                          angle: -math.pi / 0.66,
                          child: Iconify(Bx.bxs_plane, color: AppColor.secondaryColor, size: 24),
                        ),
                        width(8),
                        generateDashedDivider(context.w(0.2), dashColor: AppColor.secondaryColor),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(destinationCode, style: AppFont.semibold20),
                  height(2),
                  Text(
                    destinationCity,
                    style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
