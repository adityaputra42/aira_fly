import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:pss_app/app/routes/route_names.dart';
import 'package:pss_app/core/utils/show_dialog_zoom.dart';
import 'package:pss_app/core/utils/show_snackbar.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/features/flight/domain/entities/airport_entity.dart';
import 'package:pss_app/features/flight/presentation/bloc/flight/flight_bloc.dart';
import 'package:pss_app/features/flight/presentation/flightSelecting/screen/flight_selecting_screen.dart';
import 'package:pss_app/features/flight/presentation/searchAirport/screen/search_airport_screen.dart';
import 'package:pss_app/features/home/presentation/widget/pax_selection.dart';

import '../../../../app/theme/app_color.dart';
import '../../../../app/theme/app_font.dart';
import '../../../../core/common/widget/card_general.dart';
import '../../../../core/common/widget/input_text.dart';
import '../../../../core/common/widget/primary_button.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/utils/date_extension.dart';
import 'date_picker_screen.dart';

class SearchFlightForm extends StatefulWidget {
  const SearchFlightForm({super.key});

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

    paxTextController.text = totalAdult;

    if (amountChild > 0) {
      paxTextController.text += ', $totalChild';
    }
    if (amountInfant > 0) {
      paxTextController.text += ', $totalInfant';
    }
  }

  /// Opens the pax-count dialog and applies whatever the user actually
  /// picked. Previously the dialog's "Save" button popped without a
  /// value, so nothing typed here ever reached [onChangeTotalPassenger]
  /// -- fixed in pax_selection.dart alongside this call site.
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

  /// Opens the airport picker for either the "From" or "To" field.
  ///
  /// Passes the OTHER field's selection as `excludeAirportId` so the
  /// list doesn't offer the same airport twice -- previously there was
  /// nothing stopping "Jakarta to Jakarta".
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

    context.read<FlightBloc>().add(
      SearchFlightsRequested(
        departureAirportId: departureAirport!.id!,
        arrivalAirportId: arrivalAirport!.id!,
        date: departureDate.toFormattedString(flightFormatDateReversed),
        tripType: tripType,
        returnDate: isReturn ? returnDate?.toFormattedString(flightFormatDateReversed) : null,
        totalPax: amountAdult + amountChild + amountInfant,
      ),
    );

    context.pushNamed(
      RouteNames.flightSelecting,
      extra: FlightSelectingArguments(
        departureAirport: departureAirport!,
        arrivalAirport: arrivalAirport!,
        departureDate: departureDate,
        returnDate: isReturn ? returnDate : null,
        tripType: tripType,
        amountAdult: amountAdult,
        amountChild: amountChild,
        amountInfant: amountInfant,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    departureDate = DateTime.now();
    departureDateTextController.text = departureDate.toFormattedString(shortDDMMY);
    paxTextController.text = amountAdult.toString();
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

  /// The One Way and Round Trip tabs used to be ~180 lines of
  /// hand-duplicated `InputText`s each -- identical except for the
  /// return-date field. That meant every fix (like the ones in this
  /// change) had to be applied twice and could silently drift apart.
  /// This builds both from one source; [showReturnDate] is the only
  /// thing that varies.
  Widget _buildSearchCard({required bool showReturnDate}) {
    return CardGeneral(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      child: Column(
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
                  // Deliberately left without an `ontaped` handler:
                  // there is no seat-class list endpoint/usecase behind
                  // this app yet (FlightBloc only knows airports,
                  // flights, and seats-per-flight). Wiring this up to
                  // fake static classes would look done while quietly
                  // sending seatClassId as null regardless of what's
                  // shown -- worse than leaving it visibly inert.
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
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Container(
            width: context.w(1),
            height: context.w(0.65),
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  AppImages.map,
                  width: context.w(1),
                  color: AppColor.cardLight.withValues(alpha: .5),
                ),
              ),
            ),
          ),
          Form(
            key: formKey,
            child: DefaultTabController(
              length: 2,
              initialIndex: selectedTab,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.height(8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Securely Book \nYour Flight Ticket",
                      style: AppFont.semibold24.copyWith(color: AppColor.darkText1),
                    ),
                  ),
                  widget.height(16),
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
                      unselectedLabelStyle: AppFont.reguler14,
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
                  SizedBox(
                    height: context.h(0.47),
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
          ),
        ],
      ),
    );
  }
}
