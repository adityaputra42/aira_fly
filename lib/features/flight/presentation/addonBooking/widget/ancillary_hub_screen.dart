import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/core/utils/widget_helper.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/utils/addon_models.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/widget/card_flight_addon.dart';
import 'package:pss_app/features/flight/presentation/paxBooking/screen/pax_booking_screen.dart';
import 'package:pss_app/features/flight/presentation/utils/flight_display_utils.dart';

import '../../../../../app/routes/route_names.dart';

class AncillaryHubScreen extends StatefulWidget {
  const AncillaryHubScreen({
    super.key,
    required this.kind,
    required this.title,
    required this.paxBookingResult,
    required this.currentSelections,
  });

  final AncillaryKind kind;
  final String title;
  final PaxBookingResult paxBookingResult;
  final List<SelectedAncillary> currentSelections;

  @override
  State<AncillaryHubScreen> createState() => _AncillaryHubScreenState();
}

class _AncillaryHubScreenState extends State<AncillaryHubScreen> {
  late List<SelectedAncillary> _selections;
  late final List<AddonLeg> _legs;

  @override
  void initState() {
    super.initState();
    _selections = List.of(widget.currentSelections);
    _legs = buildAddonLegs(widget.paxBookingResult.searchArguments);
  }

  String get _unitLabel => widget.kind == AncillaryKind.baggage ? "Baggage" : "Meal";

  int _countForLeg(int flightId) =>
      _selections.where((s) => s.flightId == flightId).length;

  double get _total => sumAncillaryPrices(_selections);

  Future<void> _openLeg(AddonLeg leg) async {
    final routeName = widget.kind == AncillaryKind.baggage
        ? RouteNames.selectingBaggage
        : RouteNames.selectingMeal;

    final result = await context.pushNamed<List<SelectedAncillary>>(
      routeName,
      extra: AncillaryPickerArguments(
        kind: widget.kind,
        leg: leg,
        passengers: widget.paxBookingResult.passengers,
        currentSelections: _selections.where((s) => s.flightId == leg.flightId).toList(),
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      _selections = [
        ..._selections.where((s) => s.flightId != leg.flightId),
        ...result,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: widget.title,
        color: AppColor.primaryColor,
        titleColor: AppColor.darkText1,
      ),
      body: _legs.isEmpty
          ? Center(
              child: Text(
                "No flight information available for this booking.",
                style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final leg in _legs) ...[
                    Text(leg.label, style: AppFont.medium14),
                    widget.height(8),
                    CardFlightAddon(
                      leg: leg,
                      isSelected: _countForLeg(leg.flightId) > 0,
                      subtitle: _countForLeg(leg.flightId) > 0
                          ? "$_unitLabel selected for ${_countForLeg(leg.flightId)} of "
                                "${widget.paxBookingResult.passengers.length} passenger(s)"
                          : null,
                      onTap: () => _openLeg(leg),
                    ),
                    widget.height(16),
                  ],
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
                  Text(formatIDR(_total), style: AppFont.medium14),
                ],
              ),
              PrimaryButton(
                title: "Add $_unitLabel",
                onPressed: () => context.pop(_selections),
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
