import 'package:flutter/widgets.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/utils/addon_models.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/widget/ancillary_hub_screen.dart';

class AddonMealScreen extends StatelessWidget {
  const AddonMealScreen({super.key, required this.arguments});

  final AncillaryHubArguments arguments;

  @override
  Widget build(BuildContext context) {
    return AncillaryHubScreen(
      kind: AncillaryKind.meal,
      title: "Addon Meal",
      paxBookingResult: arguments.paxBookingResult,
      currentSelections: arguments.currentSelections,
    );
  }
}
