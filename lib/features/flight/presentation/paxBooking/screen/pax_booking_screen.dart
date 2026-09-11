import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/input_text.dart';
import 'package:pss_app/core/utils/show_dialog_zoom.dart';
import 'package:pss_app/core/utils/show_snackbar.dart';
import 'package:pss_app/features/flight/domain/repository/booking_repository.dart';
import 'package:pss_app/features/flight/presentation/flightResult/screen/flight_result_screen.dart';
import 'package:pss_app/features/flight/presentation/paxBooking/widget/contact_information_dialog.dart';
import 'package:pss_app/features/flight/presentation/paxBooking/widget/passenger_information_dialog.dart';
import 'package:pss_app/features/flight/presentation/utils/flight_display_utils.dart';

import '../../../../../core/common/widget/primary_button.dart';
import '../../../../../app/routes/route_names.dart';
import '../../../../../app/theme/theme.dart';
import '../../../../../core/utils/dashed_divider.dart';
import '../../../../../core/utils/size_extension.dart';
import '../../../../../core/utils/widget_helper.dart';

part "../widget/appbar_pax_booking.dart";

typedef _PassengerSlot = ({String type, String label});

class PaxBookingResult {
  final FlightResultArguments searchArguments;
  final ContactInput contact;
  final List<PassengerInput> passengers;

  const PaxBookingResult({
    required this.searchArguments,
    required this.contact,
    required this.passengers,
  });
}

class PaxBookingScreen extends StatefulWidget {
  const PaxBookingScreen({super.key, required this.arguments});

  final FlightResultArguments arguments;

  @override
  State<PaxBookingScreen> createState() => _PaxBookingScreenState();
}

class _PaxBookingScreenState extends State<PaxBookingScreen> {
  late final List<_PassengerSlot> _slots;
  late List<PassengerInput?> _passengers;
  ContactInput? _contact;

  @override
  void initState() {
    super.initState();
    _slots = _buildSlots();
    _passengers = List<PassengerInput?>.filled(_slots.length, null);
  }

  List<_PassengerSlot> _buildSlots() {
    final args = widget.arguments;
    return [
      for (var i = 1; i <= args.amountAdult; i++) (type: 'ADT', label: 'Adult $i'),
      for (var i = 1; i <= args.amountChild; i++) (type: 'CHD', label: 'Child $i'),
      for (var i = 1; i <= args.amountInfant; i++) (type: 'INF', label: 'Infant $i'),
    ];
  }

  bool get _isComplete => _contact != null && _passengers.every((p) => p != null);

  String _passengerDisplayName(PassengerInput passenger) {
    final parts = [
      if (passenger.title != null) passenger.title,
      passenger.firstName,
      if (passenger.lastName != null) passenger.lastName,
    ];
    return parts.whereType<String>().join(' ');
  }

  Future<void> _editContact() async {
    final result = await showZoomDialog<ContactInput>(
      context: context,
      child: ContactInformationDialog(initial: _contact),
    );
    if (result == null || !mounted) return;
    setState(() => _contact = result);
  }

  Future<void> _editPassenger(int index) async {
    final slot = _slots[index];
    final result = await showZoomDialog<PassengerInput>(
      context: context,
      child: PassengerInformationDialog(
        passengerType: slot.type,
        label: slot.label,
        initial: _passengers[index],
      ),
    );
    if (result == null || !mounted) return;
    setState(() => _passengers[index] = result);
  }

  void _onContinue() {
    if (!_isComplete) {
      showSnackBar(context, 'Please fill in contact and all passenger details first.');
      return;
    }

    context.pushNamed(
      RouteNames.addonBooking,
      extra: PaxBookingResult(
        searchArguments: widget.arguments,
        contact: _contact!,
        passengers: _passengers.whereType<PassengerInput>().toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.arguments;

    final departureFare = args.departureFare; // CHANGED — pakai pilihan user, jangan hitung ulang
    final returnFare = args.returnFare; // CHANGED
    final total =
        FareCalculator.totalForFare(departureFare, args.pax) +
        (returnFare != null ? FareCalculator.totalForFare(returnFare, args.pax) : 0);
    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "Passenger Booking Flight",
        height: 132,
        color: AppColor.primaryColor,
        titleColor: AppColor.darkText1,
        bottomWidet: AppbarPaxBooking(arguments: args),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.height(16),
              Text("Contact Information", style: AppFont.semibold16),
              widget.height(8),
              CardGeneral(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _contact == null
                          ? Text(
                              "No contact set yet. Tap Edit to add who we should reach about this booking.",
                              style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_contact!.fullName, style: AppFont.medium14),
                                widget.height(4),
                                if (_contact!.email != null)
                                  Text(
                                    _contact!.email!,
                                    style: AppFont.reguler12.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                widget.height(4),
                                Text(
                                  _contact!.phone,
                                  style: AppFont.reguler12.copyWith(
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    widget.width(8),
                    InkWell(
                      onTap: _editContact,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColor.secondaryColor.withValues(alpha: 0.1),
                          border: Border.all(color: AppColor.secondaryColor, width: 0.5),
                        ),
                        child: Text(
                          _contact == null ? "Add" : "Edit",
                          style: AppFont.medium14.copyWith(color: AppColor.secondaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              widget.height(16),
              Text("Passenger Information", style: AppFont.semibold16),
              widget.height(12),
              for (var i = 0; i < _slots.length; i++) ...[
                InputText(
                  hintText: "Tap to fill in ${_slots[i].label.toLowerCase()}'s details",
                  title: _slots[i].label,
                  controller: TextEditingController(
                    text: _passengers[i] != null ? _passengerDisplayName(_passengers[i]!) : '',
                  ),
                  filled: true,
                  readOnly: true,
                  cursor: false,
                  ontaped: () => _editPassenger(i),
                  icon: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  filledColor: Theme.of(context).cardColor,
                ),
                if (i != _slots.length - 1) widget.height(12),
              ],
              widget.height(16),
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
                onPressed: _onContinue,
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
