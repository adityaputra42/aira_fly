part of '../screen/flight_selecting_screen.dart';

class CardFlightSelecting extends StatelessWidget {
  const CardFlightSelecting({
    super.key,
    required this.itinerary,
    required this.pax,
    required this.onTap,
  });

  final ItineraryEntity itinerary;
  final PaxCount pax;
  final VoidCallback onTap;

  String _formatTime(DateTime? dt) => dt == null ? '--:--' : DateFormat('HH:mm').format(dt);
  String _formatDate(DateTime? dt) =>
      dt == null ? '-' : DateFormat('EEE, dd MMM yyyy').format(dt);

  @override
  Widget build(BuildContext context) {
    final segments = itinerary.segments ?? const <SegmentEntity>[];
    final firstSegment = segments.isNotEmpty ? segments.first : null;
    final lastSegment = segments.isNotEmpty ? segments.last : null;
    final fare = FareCalculator.cheapestFare(itinerary.fares, pax);
    final total = fare != null ? FareCalculator.totalForFare(fare, pax) : null;

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ClipPath(
            clipper: TicketTopClipper(radius: 10),
            child: CardGeneral(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColor.secondaryColor.withValues(alpha: 0.1),
                        ),
                        child: Center(
                          child: Iconify(Bx.bxs_plane, color: AppColor.secondaryColor, size: 20),
                        ),
                      ),
                      width(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(firstSegment?.flightNumber ?? '-', style: AppFont.semibold14),
                            height(2),
                            Text(
                              formatStops(itinerary.stops),
                              style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.schedule_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      width(8),
                      Text(formatFlightDuration(itinerary.durationMinutes), style: AppFont.reguler12),
                    ],
                  ),
                  height(16),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_formatTime(firstSegment?.departureTime), style: AppFont.medium32),
                          Text(
                            _formatDate(firstSegment?.departureTime),
                            style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            generateDashedDivider(
                              context.w(0.1),
                              dashColor: AppColor.secondaryColor,
                            ),
                            width(4),
                            Transform.rotate(
                              angle: -math.pi / 0.66,
                              child: Iconify(
                                Bx.bxs_plane,
                                color: AppColor.secondaryColor,
                                size: 24,
                              ),
                            ),
                            width(4),
                            generateDashedDivider(
                              context.w(0.1),
                              dashColor: AppColor.secondaryColor,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(_formatTime(lastSegment?.arrivalTime), style: AppFont.medium32),
                          Text(
                            _formatDate(lastSegment?.arrivalTime),
                            style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  height(16),
                  generateDashedDivider(context.w(0.82)),
                ],
              ),
            ),
          ),
          ClipPath(
            clipper: TicketBottomClipper(radius: 10),
            child: CardGeneral(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.connecting_airports, size: 16, color: Theme.of(context).hintColor),
                      width(4),
                      Text(
                        '${firstSegment?.departureAirportCode ?? '-'} - ${lastSegment?.arrivalAirportCode ?? '-'}',
                        style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        total != null ? formatIDR(total) : 'Price unavailable',
                        style: AppFont.semibold16.copyWith(color: AppColor.greenColor),
                      ),
                      if (total != null)
                        Text(
                          " total",
                          style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
