import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/app/theme/theme.dart';

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
  final CarouselSliderController carouselController = CarouselSliderController();
  List<DateTime> dateList = [];

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  List<DateTime> generateDateList() {
    final today = _dateOnly(DateTime.now());
    var startDate = _dateOnly(widget.startDate);
    final endDate = _dateOnly(widget.endDate);

    if (startDate.isBefore(today)) startDate = today;

    final List<DateTime> list = [];
    for (var date = startDate; !date.isAfter(endDate); date = DateTime(date.year, date.month, date.day + 1)) {
      list.add(date);
    }
    return list;
  }

  int _indexOf(DateTime date) =>
      dateList.indexWhere((e) => e.isSameDay(date));

  @override
  void initState() {
    super.initState();
    dateList = generateDateList();
    final idx = _indexOf(widget.departureDate);
    _currentIndex = idx < 0 ? 0 : idx;
  }

  @override
  void didUpdateWidget(DateSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    final rangeChanged = !oldWidget.startDate.isSameDay(widget.startDate) ||
        !oldWidget.endDate.isSameDay(widget.endDate);
    final dateChanged = !oldWidget.departureDate.isSameDay(widget.departureDate);

    if (!rangeChanged && !dateChanged) return;

    if (rangeChanged) dateList = generateDateList();

    final newIndex = _indexOf(widget.departureDate);
    if (newIndex < 0) {
      setState(() {});
      return;
    }

    // Hanya jump kalau memang beda dengan posisi sekarang.
    // _currentIndex di-set dulu supaya onPageChanged dari jump diabaikan.
    final needJump = newIndex != _currentIndex || rangeChanged;
    _currentIndex = newIndex;

    if (needJump) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        carouselController.jumpToPage(newIndex);
      });
    }
    setState(() {});
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
              if (widget.canUpdate) await carouselController.previousPage();
            },
          ),
          Expanded(
            child: CarouselSlider.builder(
              // key supaya carousel di-rebuild bersih kalau range tanggal berubah
              key: ValueKey('${dateList.length}_${dateList.isEmpty ? 0 : dateList.first.millisecondsSinceEpoch}'),
              itemCount: dateList.length,
              carouselController: carouselController,
              options: CarouselOptions(
                height: 48,
                aspectRatio: 7,
                initialPage: _currentIndex,
                viewportFraction: .26,
                reverse: false,
                autoPlay: false,
                disableCenter: true,
                enlargeCenterPage: false,
                enableInfiniteScroll: false,
                scrollPhysics: widget.canUpdate
                    ? null
                    : const NeverScrollableScrollPhysics(),
                onPageChanged: (index, reason) {
                  if (!widget.canUpdate) return;
                  if (index < 0 || index >= dateList.length) return;

                  // Sama dengan posisi saat ini = bukan aksi user
                  // (mis. hasil jumpToPage dari parent), abaikan.
                  if (index == _currentIndex) return;

                  setState(() => _currentIndex = index);
                  widget.onPageChange(index, dateList[index]);
                },
              ),
              itemBuilder: (context, itemIndex, pageViewIndex) {
                return _DateItem(
                  date: DateFormat('dd MMM').format(dateList[itemIndex]),
                  isActive: itemIndex == _currentIndex,
                  onTap: () => carouselController.animateToPage(itemIndex),
                );
              },
            ),
          ),
          _DateNavigation(
            navigationType: _NavigationType.forward,
            onTap: () async {
              if (widget.canUpdate) await carouselController.nextPage();
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
          color: isActive ? AppColor.secondaryColor : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppColor.secondaryColor : AppColor.darkText1.withValues(alpha: 0.9),
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

  void _stopTimer() {
    timer?.cancel();
    timer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
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
