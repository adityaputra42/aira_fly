part of '../screen/booking_detail_screen.dart';

class CardTicketBookingDetail extends StatelessWidget {
  const CardTicketBookingDetail({
    super.key,
    required this.legLabel,
    required this.itinerary,
    this.bookingCode,
    required this.paxLabel,
    this.seatsLabel,
    this.baggageLabel,
    this.mealsLabel,
  });

  final String legLabel;
  final ItineraryEntity itinerary;
  final String? bookingCode;
  final String paxLabel;
  final String? seatsLabel;
  final String? baggageLabel;
  final String? mealsLabel;

  @override
  Widget build(BuildContext context) {
    final segments = itinerary.segments ?? const <SegmentEntity>[];
    final first = segments.isNotEmpty ? segments.first : null;
    final last = segments.isNotEmpty ? segments.last : null;
    final flightNumberLabel = segments.isEmpty
        ? '-'
        : segments.length == 1
        ? (first?.flightNumber ?? '-')
        : '${first?.flightNumber ?? '-'} +${segments.length - 1}';

    return Column(
      children: [
        ClipPath(
          clipper: TicketTopClipper(),
          child: CardGeneral(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            radius: 12,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    color: AppColor.secondaryColor.withValues(alpha: 0.15),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(legLabel, style: AppFont.medium14),
                                height(2),
                                Text(
                                  flightNumberLabel,
                                  style: AppFont.reguler12.copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Booking Code",
                                style: AppFont.reguler12.copyWith(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              height(2),
                              Text(bookingCode ?? "-", style: AppFont.medium14),
                            ],
                          ),
                        ],
                      ),
                      height(16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(first?.departureAirportCode ?? '-', style: AppFont.semibold16),
                                height(2),
                                Text(
                                  first?.departureAirportName ?? '-',
                                  style: AppFont.reguler12.copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                generateDashedDivider(
                                  context.w(0.075),
                                  dashColor: AppColor.secondaryColor,
                                ),
                                width(4),
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColor.secondaryColor.withValues(alpha: 0.15),
                                  ),
                                  child: Transform.rotate(
                                    angle: -math.pi / 0.66,
                                    child: Iconify(
                                      Bx.bxs_plane,
                                      color: AppColor.secondaryColor,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                width(4),
                                generateDashedDivider(
                                  context.w(0.075),
                                  dashColor: AppColor.secondaryColor,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(last?.arrivalAirportCode ?? '-', style: AppFont.semibold16),
                                height(2),
                                Text(
                                  last?.arrivalAirportName ?? '-',
                                  style: AppFont.reguler12.copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Departure", style: AppFont.reguler12),
                          height(2),
                          Text(
                            first?.departureTime == null
                                ? '-'
                                : DateFormat("HH:mm").format(first!.departureTime!),
                            style: AppFont.medium16,
                          ),
                          height(2),
                          Text(
                            first?.departureTime == null
                                ? '-'
                                : DateFormat("dd MMM yyyy").format(first!.departureTime!),
                            style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Duration",
                            style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                          ),
                          height(2),
                          Text(
                            formatFlightDuration(itinerary.durationMinutes),
                            style: AppFont.medium14,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Arrival", style: AppFont.reguler12),
                          height(2),
                          Text(
                            last?.arrivalTime == null
                                ? '-'
                                : DateFormat("HH:mm").format(last!.arrivalTime!),
                            style: AppFont.medium16,
                          ),
                          height(2),
                          Text(
                            last?.arrivalTime == null
                                ? '-'
                                : DateFormat("dd MMM yyyy").format(last!.arrivalTime!),
                            style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                height(16),
                generateDashedDivider(context.w(0.8)),
              ],
            ),
          ),
        ),
        ClipPath(
          clipper: TicketBottomClipper(),
          child: CardGeneral(
            radius: 8,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CardItemTicket(
                  title1: 'Passengers',
                  value1: paxLabel,
                  title2: 'Stops',
                  value2: formatStops(itinerary.stops),
                ),
                if (seatsLabel != null || baggageLabel != null)
                  CardItemTicket(
                    title1: "Seats",
                    value1: seatsLabel ?? "Not selected",
                    title2: "Baggage",
                    value2: baggageLabel ?? "None added",
                  ),
                if (mealsLabel != null)
                  CardItemTicket(title1: "Meals", value1: mealsLabel!, title2: "", value2: ""),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CardItemTicket extends StatelessWidget {
  const CardItemTicket({
    super.key,
    required this.title1,
    required this.value1,
    required this.title2,
    required this.value2,
  });
  final String title1;
  final String value1;
  final String title2;
  final String value2;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title1, style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor)),
                height(2),
                Text(value1, style: AppFont.medium14),
              ],
            ),
          ),
          if (title2.isNotEmpty)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title2,
                    style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                  ),
                  height(2),
                  Text(value2, style: AppFont.medium14),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
