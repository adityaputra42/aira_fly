import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:pss_app/app/routes/route_names.dart';
import 'package:pss_app/core/utils/size_extension.dart';

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

  @override
  void initState() {
    super.initState();
    departureDate = DateTime.now();
    departureDateTextController.text = departureDate.toFormattedString(shortDDMMY);

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
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
                        CardGeneral(
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
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                                ontaped: () {
                                  context.pushNamed(RouteNames.searchAirport);
                                },
                                hintText: "From",
                                title: "From",

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
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                                hintText: "To",
                                title: "To",
                                ontaped: () {
                                  context.pushNamed(RouteNames.searchAirport);
                                },
                                readOnly: true,
                                cursor: false,
                              ),
                              widget.height(12),
                              InputText(
                                prefixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    widget.width(12),
                                    Iconify(
                                      Mdi.calendar_day_outline,
                                      size: 18,

                                      color: AppColor.secondaryColor,
                                    ),
                                  ],
                                ),
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                                controller: departureDateTextController,
                                ontaped: onSelectDate,
                                title: "Departure Date",
                                hintText: "Departure Date",
                                readOnly: true,
                                cursor: false,
                              ),
                              widget.height(12),
                              Row(
                                children: [
                                  Expanded(
                                    child: InputText(
                                      prefixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          widget.width(12),
                                          Iconify(
                                            Mdi.people,
                                            size: 18,
                                            color: AppColor.secondaryColor,
                                          ),
                                        ],
                                      ),
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
                                        color: Theme.of(context).hintColor,
                                      ),
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
                                          Iconify(
                                            Mdi.car_seat,
                                            size: 18,
                                            color: AppColor.secondaryColor,
                                          ),
                                        ],
                                      ),
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      hintText: "Class",
                                      title: "Class",
                                      readOnly: true,
                                      cursor: false,
                                    ),
                                  ),
                                ],
                              ),
                              widget.height(24),
                              PrimaryButton(
                                title: "Search Flight",
                                onPressed: () {
                                  context.pushNamed(RouteNames.flightSelecting);
                                },
                              ),
                            ],
                          ),
                        ),
                        CardGeneral(
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
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                                hintText: "From",
                                title: "From",
                                ontaped: () {
                                  context.pushNamed(RouteNames.searchAirport);
                                },
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
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                                hintText: "To",
                                title: "To",
                                ontaped: () {
                                  context.pushNamed(RouteNames.searchAirport);
                                },
                                readOnly: true,
                                cursor: false,
                              ),
                              widget.height(12),
                              Row(
                                children: [
                                  Expanded(
                                    child: InputText(
                                      prefixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          widget.width(12),
                                          Iconify(
                                            Mdi.calendar_day_outline,
                                            size: 18,

                                            color: AppColor.secondaryColor,
                                          ),
                                        ],
                                      ),
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      controller: departureDateTextController,
                                      ontaped: onSelectDate,
                                      title: "Departure Date",
                                      hintText: "Departure Date",
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
                                          Iconify(
                                            Mdi.calendar_day_outline,
                                            size: 18,
                                            color: AppColor.secondaryColor,
                                          ),
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
                              ),
                              widget.height(12),
                              Row(
                                children: [
                                  Expanded(
                                    child: InputText(
                                      prefixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          widget.width(12),
                                          Iconify(
                                            Mdi.people,
                                            size: 18,
                                            color: AppColor.secondaryColor,
                                          ),
                                        ],
                                      ),
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
                                        color: Theme.of(context).hintColor,
                                      ),
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
                                          Iconify(
                                            Mdi.car_seat,
                                            size: 18,
                                            color: AppColor.secondaryColor,
                                          ),
                                        ],
                                      ),
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      hintText: "Class",
                                      title: "Class",
                                      readOnly: true,
                                      cursor: false,
                                    ),
                                  ),
                                ],
                              ),
                              widget.height(24),
                              PrimaryButton(
                                title: "Search Flight",
                                onPressed: () {
                                  context.pushNamed(RouteNames.flightSelecting);
                                },
                              ),
                            ],
                          ),
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
    );
  }
}
