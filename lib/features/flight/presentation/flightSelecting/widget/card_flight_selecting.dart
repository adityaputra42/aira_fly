part of '../screen/flight_selecting_screen.dart';

class CardFlightSelecting extends StatefulWidget {
  const CardFlightSelecting({
    super.key,
    required this.itinerary,
    required this.pax,
    required this.onFareSelected,
    this.fareClassLabels,
    this.initiallyExpanded = false,
  });

  final ItineraryEntity itinerary;
  final PaxCount pax;

  final void Function(ItineraryFareEntity fare) onFareSelected;

  final Map<int, String>? fareClassLabels;
  final bool initiallyExpanded;

  @override
  State<CardFlightSelecting> createState() => _CardFlightSelectingState();
}

class _CardFlightSelectingState extends State<CardFlightSelecting> {
  late bool _expanded = widget.initiallyExpanded;
  ItineraryFareEntity? _selectedFare;

  String _formatTime(DateTime? dt) => dt == null ? '--:--' : DateFormat('HH:mm').format(dt);
  String _formatDate(DateTime? dt) => dt == null ? '-' : DateFormat('EEE, dd MMM yyyy').format(dt);

  String _fareClassLabel(int? id) {
    if (id == null) return 'Kelas -';
    return widget.fareClassLabels?[id] ?? 'Kelas #$id';
  }

  void _selectFare(ItineraryFareEntity fare) {
    setState(() => _selectedFare = fare);
    widget.onFareSelected(fare);
  }

  @override
  Widget build(BuildContext context) {
    final itinerary = widget.itinerary;
    final pax = widget.pax;

    final segments = itinerary.segments ?? const <SegmentEntity>[];
    final firstSegment = segments.isNotEmpty ? segments.first : null;
    final lastSegment = segments.isNotEmpty ? segments.last : null;

    final fares = itinerary.fares ?? const <ItineraryFareEntity>[];
    final cheapestFare = FareCalculator.cheapestFare(itinerary.fares, pax);
    final displayFare = _selectedFare ?? cheapestFare;
    final displayTotal = displayFare != null ? FareCalculator.totalForFare(displayFare, pax) : null;

    final hasMultipleFares = fares.length > 1;

    return Column(
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
                    widget.width(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(firstSegment?.flightNumber ?? '-', style: AppFont.semibold14),
                          widget.height(2),
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
                    widget.width(8),
                    Text(formatFlightDuration(itinerary.durationMinutes), style: AppFont.reguler12),
                  ],
                ),
                widget.height(16),
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
                          generateDashedDivider(context.w(0.1), dashColor: AppColor.secondaryColor),
                          widget.width(4),
                          Transform.rotate(
                            angle: -math.pi / 0.66,
                            child: Iconify(Bx.bxs_plane, color: AppColor.secondaryColor, size: 24),
                          ),
                          widget.width(4),
                          generateDashedDivider(context.w(0.1), dashColor: AppColor.secondaryColor),
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
                widget.height(16),
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
            child: Column(
              children: [
                InkWell(
                  onTap: hasMultipleFares
                      ? () => setState(() => _expanded = !_expanded)
                      : (cheapestFare != null ? () => _selectFare(cheapestFare) : null),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.connecting_airports,
                            size: 16,
                            color: Theme.of(context).hintColor,
                          ),
                          widget.width(4),
                          Text(
                            '${firstSegment?.departureAirportCode ?? '-'} - ${lastSegment?.arrivalAirportCode ?? '-'}',
                            style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                          ),
                          if (_selectedFare != null) ...[
                            widget.width(6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColor.secondaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _fareClassLabel(_selectedFare!.fareClassId),
                                style: AppFont.reguler12.copyWith(color: AppColor.secondaryColor),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            displayTotal != null ? formatIDR(displayTotal) : 'Price unavailable',
                            style: AppFont.semibold16.copyWith(color: AppColor.greenColor),
                          ),
                          if (displayTotal != null)
                            Text(
                              hasMultipleFares && _selectedFare == null ? " mulai" : " total",
                              style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                            ),
                          if (hasMultipleFares) ...[
                            widget.width(4),
                            AnimatedRotation(
                              turns: _expanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (hasMultipleFares)
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: _expanded
                        ? Column(
                            children: [
                              widget.height(12),
                              generateDashedDivider(context.w(0.82)),
                              widget.height(8),
                              ...fares.map(
                                (fare) => _FareOptionTile(
                                  label: _fareClassLabel(fare.fareClassId),
                                  fare: fare,
                                  pax: pax,
                                  isSelected: _selectedFare?.fareClassId == fare.fareClassId,
                                  onSelected: () => _selectFare(fare),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FareOptionTile extends StatelessWidget {
  const _FareOptionTile({
    required this.label,
    required this.fare,
    required this.pax,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final ItineraryFareEntity fare;
  final PaxCount pax;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final total = FareCalculator.totalForFare(fare, pax);
    final seatsLeft = fare.availableSeats;
    final isSoldOut = seatsLeft != null && seatsLeft <= 0;

    return InkWell(
      onTap: isSoldOut ? null : onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.secondaryColor.withValues(alpha: 0.08) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
              color: isSoldOut
                  ? Theme.of(context).hintColor
                  : (isSelected ? AppColor.secondaryColor : Theme.of(context).hintColor),
            ),
            width(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppFont.semibold14.copyWith(
                      color: isSoldOut ? Theme.of(context).hintColor : null,
                    ),
                  ),
                  if (seatsLeft != null)
                    Text(
                      isSoldOut ? 'Habis' : 'Sisa $seatsLeft kursi',
                      style: AppFont.reguler12.copyWith(
                        color: isSoldOut ? AppColor.redColor : Theme.of(context).hintColor,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              formatIDR(total),
              style: AppFont.semibold14.copyWith(
                color: isSoldOut ? Theme.of(context).hintColor : AppColor.greenColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
