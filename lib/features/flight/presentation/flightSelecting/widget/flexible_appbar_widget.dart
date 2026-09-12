part of '../screen/flight_selecting_screen.dart';

class FlexibleAppBarWidget extends StatefulWidget {
  const FlexibleAppBarWidget({
    super.key,
    required this.isCollapsed,
    required this.arguments,
    required this.currentDate,
    required this.minDate,
    required this.onDateChanged,
    required this.onSearchChanged,
  });

  final bool isCollapsed;
  final FlightSelectingArguments arguments;
  final DateTime currentDate;
  final DateTime minDate;
  final ValueChanged<DateTime> onDateChanged;

  final ValueChanged<FlightSelectingArguments> onSearchChanged;

  @override
  State<FlexibleAppBarWidget> createState() => _FlexibleAppBarWidgetState();
}

class _FlexibleAppBarWidgetState extends State<FlexibleAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => context.pop(),
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: (AppColor.darkText1).withValues(alpha: 0.2),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColor.darkText1,
                    size: 18,
                  ),
                ),
              ),
            ),
            widget.width(8),
            Expanded(
              child: Text(
                widget.isCollapsed
                    ? "${widget.arguments.originCode} - ${widget.arguments.destinationCode}"
                    : widget.arguments.legLabel,
                style: AppFont.semibold16.copyWith(color: AppColor.darkText1),
                textAlign: TextAlign.center,
              ),
            ),
            widget.width(8),
            InkWell(
              onTap: () async {
                final result = await showZoomDialog<FlightSelectingArguments>(
                  context: context,
                  barrierDismissible: false,
                  child: Dialog(
                    child: CardGeneral(
                      background: Theme.of(context).colorScheme.surface,
                      width: context.w(1),
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.zero,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Change Flight", style: AppFont.medium14),
                              InkWell(
                                onTap: () => context.pop(),
                                child: Icon(
                                  Icons.close,
                                  size: 24,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          widget.height(12),
                          SearchFlightForm(param: widget.arguments, fromSelectingFlight: true),
                        ],
                      ),
                    ),
                  ),
                );

                if (result == null || !context.mounted) return;
                widget.onSearchChanged(result);
              },
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: (AppColor.darkText1).withValues(alpha: 0.2),
                ),
                child: Center(child: Icon(Icons.edit_rounded, color: AppColor.darkText1, size: 18)),
              ),
            ),
          ],
        ),
        widget.height(24),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.arguments.originCode,
              style: AppFont.semibold20.copyWith(color: AppColor.darkText1),
            ),
            widget.width(8),
            generateDashedDivider(context.w(0.25), dashColor: AppColor.darkText1),
            widget.width(8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.cardLight.withValues(alpha: 0.25),
              ),
              child: Iconify(Mdi.airplane_takeoff, color: AppColor.darkText1, size: 20),
            ),
            widget.width(8),
            generateDashedDivider(context.w(0.25), dashColor: AppColor.darkText1),
            widget.width(8),
            Text(
              widget.arguments.destinationCode,
              style: AppFont.semibold20.copyWith(color: AppColor.darkText1),
            ),
          ],
        ),
        widget.height(12),
        DateSlider(
          departureDate: widget.currentDate,
          startDate: widget.minDate,
          endDate: DateTime.now().add(const Duration(days: 100)),
          isSelectingReturn: widget.arguments.leg == FlightLeg.returnLeg,
          canUpdate: true,
          onPageChange: (index, date) => widget.onDateChanged(date),
        ),
      ],
    );
  }
}
