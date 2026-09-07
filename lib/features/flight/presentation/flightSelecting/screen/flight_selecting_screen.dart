import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/core/animation/animations.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/date_slider.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/empty.dart';
import 'package:pss_app/core/utils/clipper.dart';
import 'package:pss_app/core/utils/dashed_divider.dart';
import 'package:pss_app/features/flight/domain/entities/airport_entity.dart';
import 'package:pss_app/features/flight/domain/entities/itinerary_entity.dart';
import 'package:pss_app/features/flight/presentation/bloc/flight/flight_bloc.dart';
import 'package:pss_app/features/flight/presentation/flightResult/screen/flight_result_screen.dart';
import 'package:pss_app/features/flight/presentation/utils/flight_display_utils.dart';

import '../../../../../app/init_dependencies.dart';
import '../../../../../core/common/widget/shimmer_loading.dart';
import '../../../../../core/constants/images.dart';
import '../../../../../app/routes/route_names.dart';
import '../../../../../core/utils/date_extension.dart';
import '../../../../../core/utils/size_extension.dart';
part '../widget/flexible_appbar_widget.dart';
part '../widget/card_flight_selecting.dart';

/// Which leg of the trip this screen instance is showing a list for.
///
/// A single `SearchFlightsRequested` call already returns BOTH legs at
/// once (`FlightSearchResultEntity.departure` and `.returnItineraries`)
/// -- so picking a return leg does not re-search, it just re-reads the
/// same [FlightSearchLoaded] state for the other list.
enum FlightLeg { departure, returnLeg }

/// Passed via `state.extra` when navigating to this route.
class FlightSelectingArguments {
  final AirportEntity departureAirport;
  final AirportEntity arrivalAirport;
  final DateTime departureDate;
  final DateTime? returnDate;
  final String tripType; // 'one_way' | 'round_trip'
  final int amountAdult;
  final int amountChild;
  final int amountInfant;
  final FlightLeg leg;

  /// Set once the departure leg has been picked, when [leg] is
  /// [FlightLeg.returnLeg] -- carried forward so flight_result_screen
  /// gets both legs together.
  final ItineraryEntity? selectedDeparture;

  const FlightSelectingArguments({
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureDate,
    this.returnDate,
    required this.tripType,
    required this.amountAdult,
    required this.amountChild,
    required this.amountInfant,
    this.leg = FlightLeg.departure,
    this.selectedDeparture,
  });

  bool get isRoundTrip => tripType == 'round_trip';

  PaxCount get pax => PaxCount(adult: amountAdult, child: amountChild, infant: amountInfant);

  String get originCode =>
      (leg == FlightLeg.departure ? departureAirport.code : arrivalAirport.code) ?? '-';
  String get destinationCode =>
      (leg == FlightLeg.departure ? arrivalAirport.code : departureAirport.code) ?? '-';
  DateTime get dateForLeg =>
      leg == FlightLeg.departure ? departureDate : (returnDate ?? departureDate);
  String get legLabel => leg == FlightLeg.departure ? "Departure Flight" : "Return Flight";

  FlightSelectingArguments forReturnLeg(ItineraryEntity departure) {
    return FlightSelectingArguments(
      departureAirport: departureAirport,
      arrivalAirport: arrivalAirport,
      departureDate: departureDate,
      returnDate: returnDate,
      tripType: tripType,
      amountAdult: amountAdult,
      amountChild: amountChild,
      amountInfant: amountInfant,
      leg: FlightLeg.returnLeg,
      selectedDeparture: departure,
    );
  }
}

class FlightSelectingScreen extends StatefulWidget {
  const FlightSelectingScreen({super.key, required this.arguments});

  final FlightSelectingArguments arguments;

  @override
  State<FlightSelectingScreen> createState() => _FlightSelectingScreenState();
}

class _FlightSelectingScreenState extends State<FlightSelectingScreen> {
  var scrollController = ScrollController();
  var isCollapsed = false;
  var expandedBarHeight = 200.0;
  var collapsedBarHeight = 60.0;

  // See the matching comment in search_airport_screen.dart -- resolved
  // once here, provided via BlocProvider.value below, never
  // BlocProvider(create:), because this is a shared singleton.
  late final FlightBloc _flightBloc;

  @override
  void initState() {
    super.initState();
    _flightBloc = serviceLocator<FlightBloc>();
    scrollController.addListener(() => _onScroll());
  }

  void _onScroll() {
    setState(() {
      isCollapsed =
          scrollController.hasClients &&
          scrollController.offset > (expandedBarHeight - collapsedBarHeight);
    });
  }

  /// Re-runs the ORIGINAL search (both legs, one call) after a
  /// [FlightError]. Always uses the outbound departure/arrival, date,
  /// and trip type from [widget.arguments] regardless of which leg is
  /// currently displayed -- that's how the search endpoint is shaped.
  void _retrySearch() {
    final args = widget.arguments;
    context.read<FlightBloc>().add(
      SearchFlightsRequested(
        departureAirportId: args.departureAirport.id!,
        arrivalAirportId: args.arrivalAirport.id!,
        date: args.departureDate.toFormattedString(flightFormatDateReversed),
        tripType: args.tripType,
        returnDate: args.returnDate?.toFormattedString(flightFormatDateReversed),
        totalPax: args.pax.total,
      ),
    );
  }

  void _onSelectItinerary(ItineraryEntity itinerary) {
    final args = widget.arguments;

    if (args.isRoundTrip && args.leg == FlightLeg.departure) {
      // One leg down -- push this same screen again for the return
      // leg. No new dispatch: the return itineraries are already
      // sitting in the current FlightSearchLoaded state.
      context.pushNamed(RouteNames.flightSelecting, extra: args.forReturnLeg(itinerary));
      return;
    }

    context.pushNamed(
      RouteNames.flightResult,
      extra: FlightResultArguments(
        departure: args.leg == FlightLeg.returnLeg ? args.selectedDeparture! : itinerary,
        returnItinerary: args.leg == FlightLeg.returnLeg ? itinerary : null,
        departureAirport: args.departureAirport,
        arrivalAirport: args.arrivalAirport,
        tripType: args.tripType,
        amountAdult: args.amountAdult,
        amountChild: args.amountChild,
        amountInfant: args.amountInfant,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.arguments;

    return BlocProvider.value(
      value: _flightBloc,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    snap: true,
                    floating: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: isCollapsed
                          ? BorderRadius.zero
                          : BorderRadius.vertical(bottom: Radius.circular(8)),
                    ),
                    backgroundColor: AppColor.primaryColor,
                    collapsedHeight: collapsedBarHeight,
                    expandedHeight: expandedBarHeight,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          AppImages.map,
                          width: context.w(1),
                          color: AppColor.cardLight.withValues(alpha: .5),
                        ),
                      ),
                      titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      expandedTitleScale: 1,
                      title: FlexibleAppBarWidget(isCollapsed: isCollapsed, arguments: args),
                    ),
                  ),

                  BlocBuilder<FlightBloc, FlightState>(
                    builder: (context, state) {
                      if (state is FlightError) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Empty(
                            title: state.message,
                            actionLabel: "Retry",
                            onAction: _retrySearch,
                          ),
                        );
                      }

                      if (state is! FlightSearchLoaded) {
                        // FlightSearchLoading, or a brief FlightInitial
                        // gap right after this screen mounts.
                        return SliverList.builder(
                          itemCount: 4,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                            child: ShimmerLoading(height: 190, radius: 12),
                          ),
                        );
                      }

                      final itineraries = args.leg == FlightLeg.departure
                          ? state.result.departure
                          : state.result.returnItineraries;

                      if (itineraries == null || itineraries.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Empty(
                            title: "No flights found for ${args.originCode} \u2192 ${args.destinationCode} "
                                "on ${args.dateForLeg.toFormattedString(shortDDMMY)}.",
                          ),
                        );
                      }

                      return SliverList.builder(
                        itemCount: itineraries.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                              16,
                              12,
                              16,
                              index == itineraries.length - 1 ? 76 : 0,
                            ),
                            child: StaggerItem(
                              index: index,
                              child: CardFlightSelecting(
                                itinerary: itineraries[index],
                                pax: args.pax,
                                onTap: () => _onSelectItinerary(itineraries[index]),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CardGeneral(
                  radius: 99,
                  background: AppColor.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Iconify(Mdi.sort_variant, color: AppColor.secondaryColor, size: 16),
                            widget.width(8),
                            Text(
                              "Sort",
                              style: AppFont.medium14.copyWith(color: AppColor.darkText1),
                            ),
                          ],
                        ),
                      ),
                      widget.width(24),
                      SizedBox(
                        width: 1,
                        height: 28,
                        child: VerticalDivider(thickness: 1, color: AppColor.darkText1),
                      ),
                      widget.width(24),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Iconify(Mdi.filter_outline, color: AppColor.secondaryColor, size: 16),
                            widget.width(8),
                            Text(
                              "Filter",
                              style: AppFont.medium14.copyWith(color: AppColor.darkText1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
