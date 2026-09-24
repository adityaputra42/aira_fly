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
import 'package:pss_app/core/utils/show_dialog_zoom.dart';
import 'package:pss_app/features/flight/domain/entities/airport_entity.dart';
import 'package:pss_app/features/flight/domain/entities/itinerary_entity.dart';
import 'package:pss_app/features/flight/domain/entities/seat_class_entity.dart';
import 'package:pss_app/features/flight/presentation/bloc/fareClass/fare_class_bloc.dart';
import 'package:pss_app/features/flight/presentation/bloc/flight/flight_bloc.dart';
import 'package:pss_app/features/flight/presentation/flightResult/screen/flight_result_screen.dart';
import 'package:pss_app/features/flight/presentation/utils/flight_display_utils.dart';
import 'package:pss_app/features/home/presentation/widget/search_flight_form.dart';

import '../../../../../app/init_dependencies.dart';
import '../../../../../core/common/widget/shimmer_loading.dart';
import '../../../../../core/constants/images.dart';
import '../../../../../app/routes/route_names.dart';
import '../../../../../core/utils/date_extension.dart';
import '../../../../../core/utils/size_extension.dart';
part '../widget/flexible_appbar_widget.dart';
part '../widget/card_flight_selecting.dart';

part '../widget/card_flight_sekleton.dart';

enum FlightLeg { departure, returnLeg }

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
  final ItineraryEntity? selectedDeparture;
  final ItineraryFareEntity? selectedDepartureFare; // NEW
  final SeatClassEntity? seatClass;

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
    this.selectedDepartureFare, // NEW
    this.seatClass,
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

  FlightSelectingArguments forReturnLeg(
    ItineraryEntity departure,
    ItineraryFareEntity departureFare, { // NEW required param
    DateTime? departureDate,
  }) {
    return FlightSelectingArguments(
      departureAirport: departureAirport,
      arrivalAirport: arrivalAirport,
      departureDate: departureDate ?? this.departureDate,
      returnDate: returnDate,
      tripType: tripType,
      amountAdult: amountAdult,
      amountChild: amountChild,
      amountInfant: amountInfant,
      leg: FlightLeg.returnLeg,
      selectedDeparture: departure,
      selectedDepartureFare: departureFare, // NEW
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
  bool _firstLoading = true;
  FlightSearchLoaded? _lastLoaded;
  late final FlightBloc _flightBloc;
  late final FareClassBloc _fareClassBloc;

  late FlightSelectingArguments _arguments;

  late DateTime _departureDate;
  DateTime? _returnDate;

  @override
  void initState() {
    super.initState();
    _arguments = widget.arguments;
    _flightBloc = serviceLocator<FlightBloc>();
    _fareClassBloc = serviceLocator<FareClassBloc>();
    _fareClassBloc.add(const LoadFareClassesRequested());
    _departureDate = _arguments.departureDate;
    _returnDate = _arguments.returnDate;
    scrollController.addListener(() => _onScroll());
    _retrySearch();
  }

  void _onScroll() {
    setState(() {
      isCollapsed =
          scrollController.hasClients &&
          scrollController.offset > (expandedBarHeight - collapsedBarHeight);
    });
  }

  void _onSearchChanged(FlightSelectingArguments newArguments) {
    setState(() {
      _arguments = newArguments;
      _departureDate = newArguments.departureDate;
      _returnDate = newArguments.returnDate;
      _firstLoading = true;
      _lastLoaded = null;
    });
    _retrySearch();
  }

  void _retrySearch({DateTime? newDate}) {
    final args = _arguments;

    if (newDate != null) {
      setState(() {
        if (args.leg == FlightLeg.departure) {
          _departureDate = newDate;
        } else {
          _returnDate = newDate;
        }
      });
    }

    _flightBloc.add(
      SearchFlightsRequested(
        departureAirportId: args.departureAirport.id!,
        arrivalAirportId: args.arrivalAirport.id!,
        date: _departureDate.toFormattedString(flightFormatDateReversed),
        tripType: args.tripType,
        returnDate: args.isRoundTrip
            ? _returnDate?.toFormattedString(flightFormatDateReversed)
            : null,
        totalPax: args.pax.total,
        seatClassId: args.seatClass?.id,
      ),
    );
  }

  void _onSelectItinerary(ItineraryEntity itinerary, ItineraryFareEntity fare) {
    final args = _arguments;

    if (args.isRoundTrip && args.leg == FlightLeg.departure) {
      context.pushNamed(
        RouteNames.flightSelecting,
        extra: args.forReturnLeg(itinerary, fare, departureDate: _departureDate),
      );
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

        departureFare: args.leg == FlightLeg.returnLeg ? args.selectedDepartureFare! : fare,
        returnFare: args.leg == FlightLeg.returnLeg ? fare : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = _arguments;
    final currentLegDate = args.leg == FlightLeg.departure
        ? _departureDate
        : (_returnDate ?? args.dateForLeg);
    final minSelectableDate = args.leg == FlightLeg.returnLeg ? _departureDate : DateTime.now();

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _flightBloc),
        BlocProvider.value(value: _fareClassBloc),
      ],
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
                      title: FlexibleAppBarWidget(
                        isCollapsed: isCollapsed,
                        arguments: args,
                        currentDate: currentLegDate,
                        minDate: minSelectableDate,
                        onDateChanged: (date) => _retrySearch(newDate: date),
                        onSearchChanged: _onSearchChanged,
                      ),
                    ),
                  ),
                  BlocConsumer<FlightBloc, FlightState>(
                    listener: (context, state) {
                      if (state is FlightSearchLoaded) {
                        setState(() {
                          _lastLoaded = state;
                          _firstLoading = false;
                        });
                      } else if (state is FlightError) {
                        if (_firstLoading) {
                          setState(() => _firstLoading = false);
                        }

                        if (_lastLoaded != null) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(state.message)));
                        }
                      }
                    },
                    builder: (context, state) {
                      final isRefetching = state is! FlightSearchLoaded && state is! FlightError;

                      final fareClassState = context.watch<FareClassBloc>().state;
                      final fareClassLabels = fareClassState is FareClassLoaded
                          ? fareClassState.byId.map(
                              (id, fc) => MapEntry(id, fc.name ?? 'Kelas #$id'),
                            )
                          : null;

                      if (state is FlightError && _lastLoaded == null) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Empty(
                            title: state.message,
                            actionLabel: "Retry",
                            onAction: _retrySearch,
                          ),
                        );
                      }

                      if (_firstLoading) {
                        return SliverList.builder(
                          itemCount: 4,
                          itemBuilder: (context, index) => const FlightSearchSkeleton(),
                        );
                      }

                      final loaded = _lastLoaded;
                      if (loaded == null) {
                        return const SliverToBoxAdapter(child: SizedBox.shrink());
                      }

                      final itineraries = args.leg == FlightLeg.departure
                          ? loaded.result.departure
                          : loaded.result.returnItineraries;

                      if (itineraries == null || itineraries.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Empty(
                            title:
                                "No flights found for ${args.originCode} \u2192 ${args.destinationCode} "
                                "on ${args.dateForLeg.toFormattedString(shortDDMMY)}.",
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (isRefetching && index == 0) {
                            return Column(
                              children: [
                                const LinearProgressIndicator(minHeight: 2),
                                _buildFlightCard(
                                  itineraries[0],
                                  0,
                                  itineraries.length,
                                  fareClassLabels,
                                ),
                              ],
                            );
                          }
                          return _buildFlightCard(
                            itineraries[index],
                            index,
                            itineraries.length,
                            fareClassLabels,
                          );
                        }, childCount: itineraries.length),
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

  Widget _buildFlightCard(
    ItineraryEntity itinerary,
    int index,
    int length,
    Map<int, String>? fareClassLabels,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, index == length - 1 ? 76 : 0),
      child: StaggerItem(
        index: index,
        child: CardFlightSelecting(
          itinerary: itinerary,
          pax: _arguments.pax,
          onFareSelected: (fare) => _onSelectItinerary(itinerary, fare),
          fareClassLabels: fareClassLabels,
        ),
      ),
    );
  }
}
