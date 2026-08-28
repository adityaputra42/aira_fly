import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';

import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/core/constants/images.dart';

import '../../../../core/utils/date_extension.dart';
import '../../../../core/utils/global_function.dart';
import '../../../../core/utils/widget_helper.dart';

class DatePickerArguments {
  String origin;
  String? destination;
  int amountAdult;
  int amountChild;
  int amountInfant;
  DateTime? startDate;
  DateTime? endDate;
  bool isRoundTrip;

  DatePickerArguments({
    required this.origin,
    this.destination,
    this.amountAdult = 0,
    this.amountChild = 0,
    this.amountInfant = 0,
    this.startDate,
    this.endDate,
    this.isRoundTrip = false,
  });
}

class DatePickerScreen extends StatefulWidget {
  final DatePickerArguments arguments;

  const DatePickerScreen({super.key, required this.arguments});

  @override
  State<DatePickerScreen> createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  late DateTime startDate;
  DateTime? endDate;

  late String origin;
  String? destination;
  bool selectingReturnDate = false;
  bool isRangeDate = false;

  bool isPastDate(DateTime date) {
    DateTime currentDate = DateTime.now().toLocal();
    currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);

    DateTime dateToCompare = date.toLocal();
    dateToCompare = DateTime(dateToCompare.year, dateToCompare.month, dateToCompare.day);

    return dateToCompare.isBefore(currentDate);
  }

  bool isSelected(DateTime date) {
    bool isSelected = date.isSameDay(startDate);
    if (endDate != null) {
      isSelected = date.isSameDay(startDate) || date.isSameDay(endDate!);
    }
    return isSelected;
  }

  bool isInRanged(DateTime date) {
    bool isRanged = false;
    if (endDate != null) {
      isRanged = date.isAfter(startDate) && date.isBefore(endDate!);
    }
    return isRanged;
  }

  bool isAllowedToSave() {
    if (!isRangeDate) {
      return true;
    }

    return endDate != null && endDate!.isAfter(startDate);
  }

  Color getTextColor(DateTime date, {bool isPrice = false}) {
    Color textColor = Theme.of(context).colorScheme.onSurface;
    bool isWeekend = date.weekday == DateTime.sunday;

    if (isSelected(date)) {
      textColor = Colors.white;
    } else if (isPrice && isInRanged(date) && isRangeDate) {
      textColor = Theme.of(context).colorScheme.onSurface;
    } else if (isPrice) {
      textColor = Colors.green;
    } else if (isWeekend) {
      textColor = Colors.red;
    } else if (isPastDate(date)) {
      textColor = Theme.of(context).hintColor;
    }
    return textColor;
  }

  Color getBackgroundColor(DateTime date) {
    Color backgroundColor = Colors.white;

    if (isSelected(date)) {
      backgroundColor = AppColor.primaryColor;
    } else if (isRangeDate && isInRanged(date)) {
      backgroundColor = AppColor.secondaryColor;
    } else if (isPastDate(date)) {
      backgroundColor = Theme.of(context).canvasColor;
    }

    return backgroundColor;
  }

  void onSelectDate(DateTime date) {
    if (isPastDate(date)) {
      return;
    }

    setState(() {
      if (!isRangeDate) {
        startDate = date;
        endDate = null;
        return;
      }

      if (selectingReturnDate) {
        if (date.isAfter(startDate)) {
          endDate = date;
          selectingReturnDate = false;
        } else {
          startDate = date;
          endDate = null;
        }

        return;
      }

      startDate = date;
      endDate = null;
      selectingReturnDate = true;
    });
  }

  void onSelectDate1(DateTime date) {
    if (isPastDate(date)) return;

    if (isRangeDate) {
      if (endDate != null) {
        endDate = null;
        startDate = date;
      } else if (date.isBefore(startDate)) {
        startDate = date;
      } else {
        endDate = date;
      }
    } else {
      startDate = date;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    origin = widget.arguments.origin;
    destination = widget.arguments.destination;

    startDate = widget.arguments.startDate ?? DateTime.now();

    endDate = widget.arguments.endDate;

    isRangeDate = widget.arguments.isRoundTrip;

    if (!isRangeDate) {
      endDate = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime minDate = DateTime.now();
    minDate = DateTime(minDate.year, minDate.month, 1);
    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "Select Date",
        color: AppColor.primaryColor,
        titleColor: AppColor.darkText1,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  border: Border(
                    bottom: BorderSide(color: Theme.of(context).canvasColor, width: 0.6),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Date",
                        style: AppFont.semibold22.copyWith(color: AppColor.darkText1),
                      ),
                      const SizedBox(height: 10),
                      _DetailTravel(
                        origin: origin,
                        destination: destination,
                        amountAdult: widget.arguments.amountAdult,
                        amountChild: widget.arguments.amountChild,
                        amountInfant: widget.arguments.amountInfant,
                        isRangeDate: isRangeDate,
                        startDate: startDate,
                        endDate: endDate,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              // hasScrollBody: false,
              child: Theme(
                data: ThemeData(
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                ),
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: PagedVerticalCalendar(
                    minDate: minDate,
                    maxDate: DateTime.now().add(Duration(days: 365)),
                    initialDate: widget.arguments.startDate ?? DateTime.now(),
                    listPadding: const EdgeInsets.all(18),
                    invisibleMonthsThreshold: 1,
                    startWeekWithSunday: true,
                    monthBuilder: (context, month, year) {
                      return Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            intl.DateFormat('MMMM yyyy').format(DateTime(year, month)),
                            style: AppFont.medium14,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      );
                    },
                    dayBuilder: (context, date) {
                      Color dateColor = getTextColor(date);
                      // Color priceColor = getTextColor(date, isPrice: true);

                      return Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: getBackgroundColor(date),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.withValues(alpha: 0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              intl.DateFormat('d').format(date),
                              style: AppFont.reguler14.copyWith(color: dateColor),
                            ),
                            // if (!isPastDate(date) &&
                            //     priceDate != null &&
                            //     priceDate.priceShow != '0')
                            //   Text(
                            //     priceDate.priceShow,
                            //     maxLines: 1,
                            //     overflow: TextOverflow.ellipsis,
                            //     style: AppFont.reguler10.copyWith(color: priceColor),
                            //   ),
                          ],
                        ),
                      );
                    },
                    onDayPressed: (date) {
                      // onSelectDate(date);
                      onSelectDate1(date);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: isRangeDate ? 143.2 : 124.2,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Theme.of(context).canvasColor, width: 1.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _ShowSelectedDate(title: "Departure Date", date: startDate),
                  if (isRangeDate)
                    _ShowSelectedDate(
                      title: "Return Date",

                      date: endDate,
                      onReset: () {
                        endDate = null;
                        isRangeDate = false;
                        setState(() {});
                      },
                      crossAxisAlignment: CrossAxisAlignment.end,
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        isRangeDate = true;
                        endDate = startDate.add(const Duration(days: 4));
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.add_rounded),
                          const SizedBox(width: 5),
                          Text("Add Return Date"),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 15),
              PrimaryButton(
                title: "Save",
                disable: !isAllowedToSave(),
                onPressed: () {
                  final dates = <DateTime>[startDate];

                  if (isRangeDate && endDate != null) {
                    dates.add(endDate!);
                  }

                  context.pop(dates);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShowSelectedDate extends StatelessWidget {
  final String title;
  final VoidCallback? onReset;
  final DateTime? date;
  final CrossAxisAlignment crossAxisAlignment;

  const _ShowSelectedDate({
    required this.title,
    this.date,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        onReset != null
            ? GestureDetector(
                onTap: onReset,
                child: Icon(
                  Icons.cancel_rounded,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              )
            : Container(),
        SizedBox(height: onReset != null ? 2 : 0),
        Text(title, style: AppFont.reguler10),
        const SizedBox(height: 3),
        Text(
          date != null ? DateFormat('dd MMM yyyy').format(date!) : "Select Date",
          style: AppFont.medium14,
        ),
      ],
    );
  }
}

class _DetailTravel extends StatelessWidget {
  final String origin;
  final String? destination;
  final int amountAdult;
  final int amountChild;
  final int amountInfant;
  final bool isRangeDate;
  final DateTime startDate;
  final DateTime? endDate;

  const _DetailTravel({
    required this.origin,
    this.destination,
    this.amountAdult = 0,
    this.amountChild = 0,
    this.amountInfant = 0,
    required this.isRangeDate,
    required this.startDate,
    this.endDate,
  });

  String _getDetailPax(BuildContext context) {
    String totalAdult = "0";
    String totalChild = "0";

    String totalInfant = "0";

    String paxDetail = totalAdult;

    if (amountChild > 0) {
      paxDetail += ', $totalChild';
    }
    if (amountInfant > 0) {
      paxDetail += ', $totalInfant';
    }

    return paxDetail;
  }

  @override
  Widget build(BuildContext context) {
    bool isMultiline = GlobalFunction.isMultiLine(context, origin, destination);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMultiline)
          Row(
            children: [
              Text(
                origin,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppFont.medium14.copyWith(color: Colors.white),
              ),
              const SizedBox(width: 10),
              if (!isRangeDate)
                const Icon(Icons.east, size: 18, color: Colors.white)
              else
                Image.asset(AppImages.logo, width: 18, color: Colors.white),
            ],
          )
        else if (destination != null)
          Row(
            children: [
              Text(
                origin,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppFont.medium14.copyWith(fontSize: 15, color: Colors.white),
              ),
              const SizedBox(width: 10),
              !isRangeDate
                  ? const Icon(Icons.east, size: 18, color: Colors.white)
                  : Image.asset(AppImages.logo, width: 18, color: Colors.white),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  destination ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFont.medium14.copyWith(fontSize: 15, color: Colors.white),
                ),
              ),
            ],
          )
        else
          Text(
            origin,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppFont.medium14.copyWith(fontSize: 15, color: Colors.white),
          ),
        SizedBox(height: isMultiline ? 5 : 0),
        if (isMultiline)
          Text(
            destination!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppFont.medium14.copyWith(fontSize: 15, color: Colors.white),
          ),
        const SizedBox(height: 5),
        Text(
          endDate != null
              ? startDate.distanceFromDate(endDate!)
              : startDate.toFormattedString(shortDDMY),
          style: AppFont.reguler12.copyWith(color: Colors.white),
        ),
        if (amountAdult > 0)
          Text(_getDetailPax(context), style: AppFont.reguler12.copyWith(color: Colors.white)),
      ],
    );
  }
}
