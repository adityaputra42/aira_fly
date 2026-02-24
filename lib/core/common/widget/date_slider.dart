import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/core/theme/theme.dart';

import '../../utils/date_extension.dart';

class DateSlider extends StatefulWidget {
  final DateTime departureDate;
  final DateTime startDate;
  final DateTime endDate;
  final bool isSelectingReturn;
  final bool canUpdate;
  final Function(int index, DateTime date) onPageChange;

  const DateSlider({
    super.key,
    required this.departureDate,
    required this.startDate,
    required this.endDate,
    required this.onPageChange,
    this.isSelectingReturn = false,
    this.canUpdate = true,
  });

  @override
  State<DateSlider> createState() => _DateSliderState();
}

class _DateSliderState extends State<DateSlider> {
  int _currentIndex = 0;
  int _initialIndex = 0;

  CarouselSliderController carouselController = CarouselSliderController();
  List<DateTime> dateList = [];

  List<DateTime> generateDateList() {
    DateTime startDate = widget.startDate;
    DateTime endDate = widget.endDate;

    if (widget.startDate.isBefore(DateTime.now())) {
      startDate = DateTime.now();
    }

    final List<DateTime> dateList = [];

    for (
      var date = startDate;
      date.isSameDayOrBefore(endDate);
      date = date.add(const Duration(days: 1))
    ) {
      dateList.add(date);
    }

    return dateList;
  }

  @override
  void initState() {
    super.initState();
    dateList = generateDateList();
    _currentIndex = dateList.indexWhere((element) => element.isSameDay(widget.departureDate));
    _initialIndex = dateList.indexWhere((element) => element.isSameDay(widget.departureDate));
  }

  @override
  void didUpdateWidget(DateSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.departureDate != oldWidget.departureDate) {
      _currentIndex = dateList.indexWhere((element) => element.isSameDay(widget.departureDate));
      dateList = generateDateList();
      carouselController.jumpToPage(_currentIndex);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          _DateNavigation(
            navigationType: _NavigationType.backward,
            onTap: () async {
              if (widget.canUpdate) {
                await carouselController.previousPage();
              } else {}
            },
          ),
          Expanded(
            child: CarouselSlider.builder(
              itemCount: dateList.length,
              carouselController: carouselController,
              options: CarouselOptions(
                height: 48,
                aspectRatio: 7,
                initialPage: _initialIndex,
                viewportFraction: .26,
                reverse: false,
                autoPlay: false,
                disableCenter: true,
                enlargeCenterPage: false,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  if (widget.canUpdate) {
                    _currentIndex = index;
                    setState(() {});
                    widget.onPageChange(index, dateList[index]);
                  } else {}
                },
              ),
              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                bool isActive = itemIndex == _currentIndex;

                return _DateItem(
                  date: DateFormat('dd MMM').format(dateList[itemIndex]),
                  isActive: isActive,
                  onTap: () {
                    carouselController.animateToPage(pageViewIndex);
                  },
                );
              },
            ),
          ),
          _DateNavigation(
            navigationType: _NavigationType.forward,
            onTap: () async {
              if (widget.canUpdate) {
                await carouselController.nextPage();
              } else {}
            },
          ),
        ],
      ),
    );
  }
}

class _DateItem extends StatelessWidget {
  final String date;
  final bool isActive;
  final VoidCallback onTap;

  const _DateItem({required this.date, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color textColor = isActive ? Colors.white : AppColor.primaryColor;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isActive ? AppColor.secondaryColor : Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppColor.secondaryColor : AppColor.darkText1.withValues(alpha: 0.75),
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Text(date, style: AppFont.medium12.copyWith(color: textColor)),
        ),
      ),
    );
  }
}

enum _NavigationType { forward, backward }

class _DateNavigation extends StatefulWidget {
  final AsyncCallback onTap;
  final _NavigationType navigationType;

  const _DateNavigation({required this.onTap, required this.navigationType});

  @override
  State<_DateNavigation> createState() => _DateNavigationState();
}

class _DateNavigationState extends State<_DateNavigation> {
  final double paddingSize = 3;

  Timer? timer;

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.keyboard_arrow_left_rounded;
    EdgeInsetsGeometry padding = EdgeInsets.fromLTRB(
      paddingSize / 2,
      paddingSize,
      paddingSize,
      paddingSize,
    );
    if (widget.navigationType == _NavigationType.forward) {
      icon = Icons.keyboard_arrow_right_rounded;
      padding = EdgeInsets.fromLTRB(paddingSize, paddingSize, paddingSize / 2, paddingSize);
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap,
      onLongPressStart: (detail) {
        setState(() {
          timer = Timer.periodic(const Duration(milliseconds: 250), (t) async {
            await widget.onTap();
          });
        });
      },
      onLongPressEnd: (detail) {
        if (timer != null) {
          timer!.cancel();
        }
      },
      child: Container(
        padding: padding,
        margin: EdgeInsets.only(
          left: widget.navigationType == _NavigationType.forward ? 8 : 0,
          right: widget.navigationType == _NavigationType.forward ? 0 : 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .8),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColor.primaryColor, size: 20),
      ),
    );
  }
}
