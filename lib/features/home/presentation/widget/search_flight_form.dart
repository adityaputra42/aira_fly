import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:pss_app/app/routes/route_names.dart';
import 'package:pss_app/core/utils/show_dialog_zoom.dart';
import 'package:pss_app/core/utils/show_snackbar.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/features/flight/domain/entities/airport_entity.dart';
import 'package:pss_app/features/flight/presentation/flightSelecting/screen/flight_selecting_screen.dart';
import 'package:pss_app/features/flight/presentation/searchAirport/screen/search_airport_screen.dart';
import 'package:pss_app/features/home/presentation/widget/pax_selection.dart';

import '../../../../app/theme/app_color.dart';
import '../../../../app/theme/app_font.dart';
import '../../../../core/common/widget/card_general.dart';
import '../../../../core/common/widget/input_text.dart';
import '../../../../core/common/widget/primary_button.dart';
import '../../../../core/utils/date_extension.dart';
import 'date_picker_screen.dart';

class SearchFlightForm extends StatefulWidget {
  const SearchFlightForm({super.key, this.param, this.margin, this.fromSelectingFlight = false});
  final FlightSelectingArguments? param;
  final EdgeInsets? margin;
  final bool fromSelectingFlight;
  @override
  State<SearchFlightForm> createState() => _SearchFlightFormState();
}

class _SearchFlightFormState extends State<SearchFlightForm> {
  final formKey = GlobalKey<FormState>();
  int amountAdult = 1;
  int amountChild = 0;
  int amountInfant = 0;

  late DateTime departureDate;
  DateTime? returnDate;
  bool isReturn = false;
  int selectedTab = 0;

  AirportEntity? departureAirport;
  AirportEntity? arrivalAirport;

  CancelToken cancelToken = CancelToken();

  final TextEditingController departureTextController = TextEditingController();
  final TextEditingController arrivalTextController = TextEditingController();
  final TextEditingController departureDateTextController = TextEditingController();
  final TextEditingController returnDateTextController = TextEditingController();
  final TextEditingController paxTextController = TextEditingController();
  final TextEditingController classTextController = TextEditingController();

  void changeTab(int index) {
    setState(() {
      selectedTab = index;
      isReturn = index == 1;
    });
  }

  Future<void> onSelectDate() async {
    final form = formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    final result = await context.pushNamed<List<DateTime>>(
      RouteNames.selectDate,
      extra: DatePickerArguments(
        origin: departureTextController.text,
        destination: arrivalTextController.text,
        startDate: departureDate,
        endDate: returnDate,
        amountAdult: amountAdult,
        amountChild: amountChild,
        amountInfant: amountInfant,
        isRoundTrip: isReturn,
      ),
    );

    if (!mounted || result == null || result.isEmpty) {
      return;
    }

    setState(() {
      departureDate = result.first;

      departureDateTextController.text = departureDate.toFormattedString(shortDDMMY);

      if (isReturn && result.length > 1) {
        returnDate = result[1];

        returnDateTextController.text = returnDate!.toFormattedString(shortDDMMY);
      } else {
        returnDate = null;
        returnDateTextController.clear();
      }
    });
  }

  void onChangeTotalPassenger(List<int>? value) {
    if (value == null) return;

    amountAdult = value[0];
    amountChild = value[1];
    amountInfant = value[2];

    String totalAdult = (amountAdult).toString();
    String totalChild = (amountChild).toString();
    String totalInfant = (amountInfant).toString();

    paxTextController.text = "$totalAdult Adult";

    if (amountChild > 0) {
      paxTextController.text += ', $totalChild Child';
    }
    if (amountInfant > 0) {
      paxTextController.text += ', $totalInfant Infant';
    }
  }

  Future<void> onSelectPax() async {
    final result = await showZoomDialog<List<int>>(
      context: context,
      child: PaxSelectionDialog(
        amountAdult: amountAdult,
        amountChild: amountChild,
        amountInfant: amountInfant,
      ),
    );

    if (!mounted) return;
    setState(() => onChangeTotalPassenger(result));
  }

  Future<void> onSelectAirport({required bool isDeparture}) async {
    final excludeId = isDeparture ? arrivalAirport?.id : departureAirport?.id;

    final result = await context.pushNamed<AirportEntity>(
      RouteNames.searchAirport,
      extra: SearchAirportArguments(excludeAirportId: excludeId),
    );

    if (result == null || !mounted) return;

    setState(() {
      final label = '${result.city ?? '-'} (${result.code ?? '-'})';
      if (isDeparture) {
        departureAirport = result;
        departureTextController.text = label;
      } else {
        arrivalAirport = result;
        arrivalTextController.text = label;
      }
    });
  }

  void onSearchFlight() {
    if (departureAirport == null || arrivalAirport == null) {
      showSnackBar(context, 'Please select both departure and arrival airports.');
      return;
    }
    if (departureAirport!.id == arrivalAirport!.id) {
      showSnackBar(context, 'Departure and arrival airports cannot be the same.');
      return;
    }
    if (isReturn && returnDate == null) {
      showSnackBar(context, 'Please select a return date.');
      return;
    }
    if (amountAdult < 1) {
      showSnackBar(context, 'At least one adult passenger is required.');
      return;
    }

    final tripType = isReturn ? 'round_trip' : 'one_way';
    final args = FlightSelectingArguments(
      departureAirport: departureAirport!,
      arrivalAirport: arrivalAirport!,
      departureDate: departureDate,
      returnDate: isReturn ? returnDate : null,
      tripType: tripType,
      amountAdult: amountAdult,
      amountChild: amountChild,
      amountInfant: amountInfant,
    );

    if (widget.fromSelectingFlight) {
      context.pop(args);
    } else {
      context.pushNamed(RouteNames.flightSelecting, extra: args);
    }
  }

  @override
  void initState() {
    super.initState();

    final param = widget.param;

    if (param != null) {
      departureAirport = param.departureAirport;
      arrivalAirport = param.arrivalAirport;
      departureDate = param.departureDate;
      returnDate = param.returnDate;

      isReturn = param.isRoundTrip;
      selectedTab = isReturn ? 1 : 0;

      amountAdult = param.amountAdult;
      amountChild = param.amountChild;
      amountInfant = param.amountInfant;

      departureTextController.text =
          '${param.departureAirport.city ?? '-'} (${param.departureAirport.code ?? '-'})';
      arrivalTextController.text =
          '${param.arrivalAirport.city ?? '-'} (${param.arrivalAirport.code ?? '-'})';
      departureDateTextController.text = departureDate.toFormattedString(shortDDMMY);

      if (isReturn && returnDate != null) {
        returnDateTextController.text = returnDate!.toFormattedString(shortDDMMY);
      }

      onChangeTotalPassenger([amountAdult, amountChild, amountInfant]);
    } else {
      departureDate = DateTime.now();
      departureDateTextController.text = departureDate.toFormattedString(shortDDMMY);
      paxTextController.text = "$amountAdult Adult";
    }
  }

  @override
  void dispose() {
    departureTextController.dispose();
    arrivalTextController.dispose();
    departureDateTextController.dispose();
    returnDateTextController.dispose();
    paxTextController.dispose();
    classTextController.dispose();
    super.dispose();
  }

  Widget _buildSearchCard({required bool showReturnDate}) {
    return CardGeneral(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InputText(
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.width(12),
                Iconify(Mdi.airplane, size: 18, color: AppColor.secondaryColor),
              ],
            ),
            icon: Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).hintColor),
            hintText: "From",
            title: "From",
            controller: departureTextController,
            ontaped: () => onSelectAirport(isDeparture: true),
            readOnly: true,
            cursor: false,
          ),
          widget.height(12),
          InputText(
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.width(12),
                Iconify(Mdi.airplane, size: 18, color: AppColor.secondaryColor),
              ],
            ),
            icon: Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).hintColor),
            hintText: "To",
            title: "To",
            controller: arrivalTextController,
            ontaped: () => onSelectAirport(isDeparture: false),
            readOnly: true,
            cursor: false,
          ),
          widget.height(12),
          if (showReturnDate)
            Row(
              children: [
                Expanded(child: _departureDateField()),
                widget.width(8),
                Expanded(
                  child: InputText(
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.width(12),
                        Iconify(Mdi.calendar_day_outline, size: 18, color: AppColor.secondaryColor),
                      ],
                    ),
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Theme.of(context).hintColor,
                    ),
                    controller: returnDateTextController,
                    ontaped: onSelectDate,
                    title: "Return Date",
                    hintText: "Return Date",
                    readOnly: true,
                    cursor: false,
                  ),
                ),
              ],
            )
          else
            _departureDateField(),
          widget.height(12),
          Row(
            children: [
              Expanded(
                child: InputText(
                  controller: paxTextController,
                  ontaped: onSelectPax,
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.width(12),
                      Iconify(Mdi.people, size: 18, color: AppColor.secondaryColor),
                    ],
                  ),
                  icon: Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).hintColor),
                  title: "Passangger",
                  hintText: "Passangger",
                  readOnly: true,
                  cursor: false,
                ),
              ),
              widget.width(8),
              Expanded(
                child: InputText(
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.width(12),
                      Iconify(Mdi.car_seat, size: 18, color: AppColor.secondaryColor),
                    ],
                  ),
                  icon: Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).hintColor),
                  hintText: "Any Class",
                  title: "Class",
                  readOnly: true,
                  cursor: false,
                ),
              ),
            ],
          ),
          widget.height(24),
          PrimaryButton(title: "Search Flight", onPressed: onSearchFlight),
        ],
      ),
    );
  }

  Widget _departureDateField() {
    return InputText(
      prefixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.width(12),
          Iconify(Mdi.calendar_day_outline, size: 18, color: AppColor.secondaryColor),
        ],
      ),
      icon: Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).hintColor),
      controller: departureDateTextController,
      ontaped: onSelectDate,
      title: "Departure Date",
      hintText: "Departure Date",
      readOnly: true,
      cursor: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: DefaultTabController(
        length: 2,
        initialIndex: selectedTab,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardGeneral(
              margin: EdgeInsets.zero,
              width: double.infinity,
              height: 42,
              padding: EdgeInsets.all(3),
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
                labelStyle: AppFont.medium12,
                unselectedLabelColor: Theme.of(context).hintColor,
                unselectedLabelStyle: AppFont.reguler12,
                indicatorSize: TabBarIndicatorSize.tab,
                onTap: (index) {
                  changeTab(index);
                },
                tabs: const [
                  Tab(child: Text("One Way")),
                  Tab(child: Text("Round Trip")),
                ],
              ),
            ),
            widget.height(12),
            SizedBox(
              height: context.h(0.45),
              child: TabBarView(
                children: [
                  _buildSearchCard(showReturnDate: false),
                  _buildSearchCard(showReturnDate: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
