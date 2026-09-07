import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/utils/widget_helper.dart';
import 'package:pss_app/features/flight/domain/entities/airport_entity.dart';
import 'package:pss_app/features/flight/domain/entities/itinerary_entity.dart';
import 'package:pss_app/features/flight/presentation/utils/flight_display_utils.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../../../../app/routes/route_names.dart';
import '../../../../../core/utils/dashed_divider.dart';
import '../../../../../core/utils/size_extension.dart';

part '../widget/widget_appbar_result.dart';
part '../widget/card_info_flight.dart';
part '../widget/price_detail.dart';
part '../widget/flight_timeline.dart';

class FlightResultArguments {
  final ItineraryEntity departure;
  final ItineraryEntity? returnItinerary; // null for one-way
  final AirportEntity departureAirport;
  final AirportEntity arrivalAirport;
  final String tripType; // 'one_way' | 'round_trip'
  final int amountAdult;
  final int amountChild;
  final int amountInfant;

  const FlightResultArguments({
    required this.departure,
    this.returnItinerary,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.tripType,
    required this.amountAdult,
    required this.amountChild,
    required this.amountInfant,
  });

  bool get isRoundTrip => tripType == 'round_trip';

  PaxCount get pax => PaxCount(adult: amountAdult, child: amountChild, infant: amountInfant);
}

class FlightResultScreen extends StatelessWidget {
  const FlightResultScreen({super.key, required this.arguments});

  final FlightResultArguments arguments;

  @override
  Widget build(BuildContext context) {
    final tabCount = arguments.isRoundTrip ? 3 : 2;
    final departureFare = FareCalculator.cheapestFare(arguments.departure.fares, arguments.pax);
    final returnFare = arguments.returnItinerary != null
        ? FareCalculator.cheapestFare(arguments.returnItinerary!.fares, arguments.pax)
        : null;

    final total =
        (departureFare != null ? FareCalculator.totalForFare(departureFare, arguments.pax) : 0) +
        (returnFare != null ? FareCalculator.totalForFare(returnFare, arguments.pax) : 0);

    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "Flight Result",
        height: 132,
        color: AppColor.primaryColor,
        titleColor: AppColor.darkText1,
        bottomWidet: WidgetAppBarResult(arguments: arguments),
      ),
      body: SafeArea(
        top: false,
        child: DefaultTabController(
          length: tabCount,
          child: Column(
            children: [
              height(8),
              CardGeneral(
                margin: EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                height: 42,
                padding: EdgeInsets.all(2),
                child: TabBar(
                  physics: const NeverScrollableScrollPhysics(),
                  automaticIndicatorColorAdjustment: false,
                  indicator: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  isScrollable: false,
                  dividerColor: Colors.transparent,
                  indicatorColor: Theme.of(context).colorScheme.surface,
                  labelColor: AppColor.darkText1,
                  labelPadding: EdgeInsets.zero,
                  labelStyle: AppFont.medium14,
                  unselectedLabelColor: Theme.of(context).hintColor,
                  unselectedLabelStyle: AppFont.reguler12,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    const Tab(child: Text("Departure")),
                    if (arguments.isRoundTrip) const Tab(child: Text("Return")),
                    const Tab(child: Text("Price")),
                  ],
                ),
              ),
              height(8),
              Expanded(
                child: TabBarView(
                  children: [
                    Column(
                      children: [
                        CardInfoFlight(
                          itinerary: arguments.departure,
                          originAirport: arguments.departureAirport,
                          destinationAirport: arguments.arrivalAirport,
                        ),
                        FlightTimeline(segments: arguments.departure.segments ?? const []),
                      ],
                    ),
                    if (arguments.isRoundTrip)
                      Column(
                        children: [
                          CardInfoFlight(
                            itinerary: arguments.returnItinerary!,
                            originAirport: arguments.arrivalAirport,
                            destinationAirport: arguments.departureAirport,
                            isReturn: true,
                          ),
                          FlightTimeline(segments: arguments.returnItinerary!.segments ?? const []),
                        ],
                      ),
                    PriceDetail(
                      pax: arguments.pax,
                      departureFare: departureFare,
                      returnFare: returnFare,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                blurRadius: 0.5,
                offset: Offset(0, 0.5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Total Price", style: AppFont.reguler12),
                      Text(formatIDR(total), style: AppFont.medium14),
                    ],
                  ),
                ],
              ),
              PrimaryButton(
                title: "Continue",
                onPressed: () {
                  context.pushNamed(RouteNames.paxBooking, extra: arguments);
                },
                width: context.w(0.4),
                borderRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
