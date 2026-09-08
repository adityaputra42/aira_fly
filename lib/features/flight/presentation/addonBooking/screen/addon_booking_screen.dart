import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/utils/addon_models.dart';
import 'package:pss_app/features/flight/presentation/paxBooking/screen/pax_booking_screen.dart';
import 'package:pss_app/features/flight/presentation/utils/flight_display_utils.dart';

import '../../../../../core/common/widget/primary_button.dart';
import '../../../../../app/routes/route_names.dart';
import '../../../../../core/utils/dashed_divider.dart';
import '../../../../../core/utils/size_extension.dart';
import '../../../../../core/utils/widget_helper.dart';
import '../../flightResult/screen/flight_result_screen.dart';

part '../widget/card_detail_flight.dart';
part '../widget/card_menu_addon.dart';

class AddonBookingScreen extends StatefulWidget {
  const AddonBookingScreen({super.key, required this.paxBookingResult});

  final PaxBookingResult paxBookingResult;

  @override
  State<AddonBookingScreen> createState() => _AddonBookingScreenState();
}

class _AddonBookingScreenState extends State<AddonBookingScreen> {
  List<SelectedAncillary> _baggage = [];
  List<SelectedAncillary> _meals = [];
  List<SelectedSeat> _seats = [];

  Future<void> _openBaggage() async {
    final result = await context.pushNamed<List<SelectedAncillary>>(
      RouteNames.addonBaggage,
      extra: AncillaryHubArguments(
        paxBookingResult: widget.paxBookingResult,
        currentSelections: _baggage,
      ),
    );
    if (result != null && mounted) setState(() => _baggage = result);
  }

  Future<void> _openMeal() async {
    final result = await context.pushNamed<List<SelectedAncillary>>(
      RouteNames.addonMeal,
      extra: AncillaryHubArguments(
        paxBookingResult: widget.paxBookingResult,
        currentSelections: _meals,
      ),
    );
    if (result != null && mounted) setState(() => _meals = result);
  }

  Future<void> _openSeat() async {
    final result = await context.pushNamed<List<SelectedSeat>>(
      RouteNames.addonSeat,
      extra: SeatHubArguments(paxBookingResult: widget.paxBookingResult, currentSelections: _seats),
    );
    if (result != null && mounted) setState(() => _seats = result);
  }

  double get _addonTotal => sumAncillaryPrices(_baggage) + sumAncillaryPrices(_meals);

  double get _fareTotal {
    final args = widget.paxBookingResult.searchArguments;
    final departureFare = FareCalculator.cheapestFare(args.departure.fares, args.pax);
    final returnFare = args.returnItinerary != null
        ? FareCalculator.cheapestFare(args.returnItinerary!.fares, args.pax)
        : null;
    return (departureFare != null ? FareCalculator.totalForFare(departureFare, args.pax) : 0) +
        (returnFare != null ? FareCalculator.totalForFare(returnFare, args.pax) : 0);
  }

  @override
  Widget build(BuildContext context) {
    final total = _fareTotal + _addonTotal;

    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "Addon Booking Flight",
        color: AppColor.primaryColor,
        titleColor: AppColor.darkText1,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardDetailFlight(searchArguments: widget.paxBookingResult.searchArguments),
            Text("Addon Service", style: AppFont.medium14),
            widget.height(12),
            CardMenuAddon(
              onTap: _openBaggage,
              title: 'Baggage',
              description: _baggage.isEmpty
                  ? 'Add extra baggage allowance for each passenger'
                  : '${_baggage.length} passenger-leg selection(s) added',
              icon: Mdi.bag_suitcase,
              isSelected: _baggage.isNotEmpty,
            ),
            widget.height(16),
            CardMenuAddon(
              onTap: _openMeal,
              title: 'In-flight Meal',
              description: _meals.isEmpty
                  ? 'Pre-order your meal and enjoy it on board'
                  : '${_meals.length} passenger-leg selection(s) added',
              icon: Mdi.food,
              isSelected: _meals.isNotEmpty,
            ),
            widget.height(16),
            CardMenuAddon(
              onTap: _openSeat,
              title: 'Seat Selection',
              description: _seats.isEmpty
                  ? 'Select your preferred seat'
                  : '${_seats.length} passenger-leg seat(s) assigned',
              icon: Mdi.seat_passenger,
              isSelected: _seats.isNotEmpty,
            ),
          ],
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Total Price", style: AppFont.reguler12),
                  Text(formatIDR(total), style: AppFont.medium14),
                ],
              ),
              PrimaryButton(
                title: "Book Now",
                onPressed: () {
                  context.pushNamed(
                    RouteNames.bookingDetail,
                    extra: AddonBookingResult(
                      paxBookingResult: widget.paxBookingResult,
                      baggage: _baggage,
                      meals: _meals,
                      seats: _seats,
                    ),
                  );
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
