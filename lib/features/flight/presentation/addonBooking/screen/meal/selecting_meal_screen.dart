import 'package:flutter/widgets.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/utils/addon_models.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/widget/ancillary_picker_screen.dart';

class SelectingMealScreen extends StatelessWidget {
  const SelectingMealScreen({super.key, required this.arguments});

  final AncillaryPickerArguments arguments;

  @override
  Widget build(BuildContext context) {
    return AncillaryPickerScreen(arguments: arguments);
  }
}
