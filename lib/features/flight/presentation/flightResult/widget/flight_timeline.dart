part of '../screen/flight_result_screen.dart';

class FlightTimeline extends StatelessWidget {
  const FlightTimeline({super.key, required this.segments});

  final List<SegmentEntity> segments;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CardGeneral(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: segments.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    "No segment details available",
                    style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                  ),
                )
              : Column(
                  children: [
                    for (var i = 0; i < segments.length; i++) ...[
                      CardTimeline(segment: segments[i]),
                      if (i != segments.length - 1) ...[
                        height(12),
                        _LayoverBanner(arrival: segments[i], departure: segments[i + 1]),
                        height(12),
                      ],
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

/// Shown between two segments on a connecting itinerary (stops > 0).
/// There was no concept of multiple segments in the original hardcoded
/// version -- it just showed the same single CardTimeline twice.
class _LayoverBanner extends StatelessWidget {
  const _LayoverBanner({required this.arrival, required this.departure});

  final SegmentEntity arrival;
  final SegmentEntity departure;

  @override
  Widget build(BuildContext context) {
    final layoverMinutes = (arrival.arrivalTime != null && departure.departureTime != null)
        ? departure.departureTime!.difference(arrival.arrivalTime!).inMinutes
        : null;

    return CardGeneral(
      background: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
      useShadow: false,
      radius: 4,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        "Layover ${formatFlightDuration(layoverMinutes)} in "
        "${arrival.arrivalAirportCode ?? '-'}",
        style: AppFont.reguler12.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}

class CardTimeline extends StatelessWidget {
  const CardTimeline({super.key, required this.segment});

  final SegmentEntity segment;

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == 4;
    }

    final durationMinutes = (segment.departureTime != null && segment.arrivalTime != null)
        ? segment.arrivalTime!.difference(segment.departureTime!).inMinutes
        : null;

    return Column(
      children: [
        Row(
          children: [
            // No airline logo field exists on SegmentEntity -- a
            // generic plane icon replaces the hardcoded airline image.
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColor.secondaryColor.withValues(alpha: 0.1),
              ),
              child: Center(child: Iconify(Bx.bxs_plane, color: AppColor.secondaryColor, size: 20)),
            ),
            width(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(segment.departureAirportCode ?? '-', style: AppFont.medium12),
                      width(8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      width(8),
                      Text(segment.arrivalAirportCode ?? '-', style: AppFont.medium12),
                    ],
                  ),
                  height(2),
                  Text(
                    '${segment.departureAirportName ?? '-'} to ${segment.arrivalAirportName ?? '-'}',
                    style: AppFont.reguler10.copyWith(color: Theme.of(context).hintColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: Theme.of(context).hintColor,
                    ),
                    // Was `height(2)` in the original -- a vertical
                    // spacer used inside a horizontal Row, which does
                    // nothing (Row ignores a child's height-only
                    // SizedBox for layout spacing). `width(4)` is what
                    // this was almost certainly meant to be.
                    width(4),
                    Text(
                      segment.departureTime != null
                          ? DateFormat("dd MMM yyyy").format(segment.departureTime!)
                          : '-',
                      style: AppFont.medium12,
                    ),
                  ],
                ),
                Text(
                  segment.flightNumber ?? '-',
                  style: AppFont.reguler10.copyWith(color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ],
        ),
        height(16),
        FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0.04,
            color: Theme.of(context).hintColor,
            indicatorTheme: const IndicatorThemeData(size: 10, position: 0.5),
            connectorTheme: const ConnectorThemeData(thickness: 2.5),
          ),
          builder: TimelineTileBuilder.connected(
            itemCount: 5,
            indicatorBuilder: (_, index) {
              return DotIndicator(
                size: isEdgeIndex(index) || index == 2 ? 0 : null,
                color: isEdgeIndex(index) ? null : AppColor.secondaryColor,
                border: Border.all(color: AppColor.secondaryColor, width: 0.5),
              );
            },
            contentsBuilder: (context, index) {
              if (index == 1) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16, left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '${segment.departureAirportName ?? '-'} (${segment.departureAirportCode ?? '-'})',
                              style: AppFont.medium12,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            segment.departureTime != null
                                ? DateFormat("HH:mm").format(segment.departureTime!)
                                : '--:--',
                            style: AppFont.reguler12,
                          ),
                        ],
                      ),
                      // Terminal info removed -- SegmentEntity has no
                      // terminal field, unlike the hardcoded
                      // "Terminal 3" this replaced.
                    ],
                  ),
                );
              }
              if (index == 2) {
                return CardGeneral(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  background: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  useShadow: false,
                  radius: 4,
                  child: Text(
                    "Duration: ${formatFlightDuration(durationMinutes)}",
                    style: AppFont.reguler12.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              }
              if (index == 3) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16, left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '${segment.arrivalAirportName ?? '-'} (${segment.arrivalAirportCode ?? '-'})',
                              style: AppFont.medium14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            segment.arrivalTime != null
                                ? DateFormat("HH:mm").format(segment.arrivalTime!)
                                : '--:--',
                            style: AppFont.reguler14,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return null;
            },
            connectorBuilder: (_, index, type) {
              if (isEdgeIndex(index) || index == 3) {
                return null;
              }

              return Connector.solidLine(
                color: Theme.of(context).canvasColor,
                space: 2.5,
                thickness: 2.5,
              );
            },
          ),
        ),
        height(16),
        generateDashedDivider(context.w(0.84), dashColor: Theme.of(context).canvasColor),
      ],
    );
  }
}
