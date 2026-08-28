part of '../screen/flight_selecting_screen.dart';

class FlexibleAppBarWidget extends StatelessWidget {
  const FlexibleAppBarWidget({super.key, required this.isCollapsed});
  final bool isCollapsed;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                context.pop();
              },
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
            width(8),
            Expanded(
              child: Text(
                isCollapsed ? "CGK - DPS" : "Departure Flight",
                style: AppFont.semibold16.copyWith(color: AppColor.darkText1),
                textAlign: TextAlign.center,
              ),
            ),
            width(8),
            InkWell(
              onTap: () {},
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
        height(24),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("CGK", style: AppFont.semibold20.copyWith(color: AppColor.darkText1)),
            width(8),
            generateDashedDivider(context.w(0.25), dashColor: AppColor.darkText1),
            width(8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.cardLight.withValues(alpha: 0.25),
              ),
              child: Iconify(Mdi.airplane_takeoff, color: AppColor.darkText1, size: 20),
            ),
            width(8),
            generateDashedDivider(context.w(0.25), dashColor: AppColor.darkText1),
            width(8),
            Text("DPS", style: AppFont.semibold20.copyWith(color: AppColor.darkText1)),
          ],
        ),
        height(12),
        DateSlider(
          departureDate: DateTime.now().add(Duration(days: 2)),
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 100)),
          onPageChange: (index, date) {},
        ),
      ],
    );
  }
}
