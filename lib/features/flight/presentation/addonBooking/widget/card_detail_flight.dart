part of '../screen/addon_booking_screen.dart';

class CardDetailFlight extends StatelessWidget {
  const CardDetailFlight({super.key, required this.searchArguments});

  final FlightResultArguments searchArguments;

  @override
  Widget build(BuildContext context) {
    final departureSegments = searchArguments.departure.segments ?? const [];
    final firstDeparture = departureSegments.isNotEmpty ? departureSegments.first : null;

    final returnSegments = searchArguments.returnItinerary?.segments ?? const [];

    final startDate = firstDeparture?.departureTime;
    final endDate = searchArguments.isRoundTrip
        ? returnSegments.isNotEmpty
              ? returnSegments.last.arrivalTime
              : null
        : (departureSegments.isNotEmpty ? departureSegments.last.arrivalTime : null);

    return CardGeneral(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                startDate != null ? DateFormat('dd MMM yyyy').format(startDate) : '-',
                style: AppFont.reguler12,
              ),
              if (searchArguments.isRoundTrip) ...[
                width(8),
                Iconify(
                  MaterialSymbols.swap_horiz_rounded,
                  color: AppColor.secondaryColor,
                  size: 20,
                ),
                width(8),
                Text(
                  endDate != null ? DateFormat('dd MMM yyyy').format(endDate) : '-',
                  style: AppFont.reguler12,
                ),
              ],
            ],
          ),
          height(8),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(searchArguments.departureAirport.code ?? '-', style: AppFont.semibold20),
                  height(2),
                  Text(searchArguments.departureAirport.city ?? '-', style: AppFont.reguler12),
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
                        Iconify(
                          MaterialSymbols.connecting_airports_rounded,
                          color: AppColor.secondaryColor,
                          size: 24,
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
                  Text(searchArguments.arrivalAirport.code ?? '-', style: AppFont.semibold20),
                  height(2),
                  Text(searchArguments.arrivalAirport.city ?? '-', style: AppFont.reguler12),
                ],
              ),
            ],
          ),
          height(12),
          Row(
            children: [
              Iconify(Mdi.person, size: 16, color: AppColor.secondaryColor),
              width(6),
              Text("${searchArguments.amountAdult} Adult", style: AppFont.medium12),
              width(12),
              SizedBox(
                width: 1,
                height: 16,
                child: VerticalDivider(thickness: 1, color: AppColor.darkText1),
              ),
              width(12),
              Iconify(Mdi.human_child, size: 16, color: AppColor.secondaryColor),
              width(6),
              Text("${searchArguments.amountChild} Child", style: AppFont.medium12),
              width(12),
              SizedBox(
                width: 1,
                height: 16,
                child: VerticalDivider(thickness: 1, color: AppColor.darkText1),
              ),
              width(12),
              Iconify(Mdi.emoticon_baby_outline, size: 16, color: AppColor.secondaryColor),
              width(6),
              Text("${searchArguments.amountInfant} Infant", style: AppFont.medium12),
            ],
          ),
        ],
      ),
    );
  }
}
