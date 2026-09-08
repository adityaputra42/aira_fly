import 'package:flutter/widgets.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/utils/addon_models.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/widget/ancillary_hub_screen.dart';

class AddonBagageScreen extends StatelessWidget {
  const AddonBagageScreen({super.key, required this.arguments});

  final AncillaryHubArguments arguments;

  @override
  Widget build(BuildContext context) {
    return AncillaryHubScreen(
      kind: AncillaryKind.baggage,
      title: "Addon Baggage",
      paxBookingResult: arguments.paxBookingResult,
      currentSelections: arguments.currentSelections,
    );
  }
}
