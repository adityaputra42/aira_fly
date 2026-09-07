part of '../screen/flight_result_screen.dart';

class WidgetAppBarResult extends StatelessWidget {
  const WidgetAppBarResult({super.key, required this.arguments});

  final FlightResultArguments arguments;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        height(16),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  arguments.departureAirport.code ?? '-',
                  style: AppFont.semibold20.copyWith(color: AppColor.darkText1),
                ),
                height(2),
                Text(
                  arguments.departureAirport.city ?? '-',
                  style: AppFont.reguler12.copyWith(color: AppColor.darkText1),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      generateDashedDivider(context.w(0.2), dashColor: AppColor.secondaryColor),
                      width(8),
                      Iconify(
                        MaterialSymbols.connecting_airports_rounded,
                        color: AppColor.secondaryColor,
                        size: 24,
                      ),
                      width(8),
                      generateDashedDivider(context.w(0.2), dashColor: AppColor.secondaryColor),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  arguments.arrivalAirport.code ?? '-',
                  style: AppFont.semibold20.copyWith(color: AppColor.darkText1),
                ),
                height(2),
                Text(
                  arguments.arrivalAirport.city ?? '-',
                  style: AppFont.reguler12.copyWith(color: AppColor.darkText1),
                ),
              ],
            ),
          ],
        ),
        height(12),
        Row(
          children: [
            Iconify(Mdi.person, size: 16, color: AppColor.secondaryColor),
            width(6),
            Text(
              "${arguments.amountAdult} Adult",
              style: AppFont.medium12.copyWith(color: AppColor.darkText1),
            ),
            width(12),
            SizedBox(
              width: 1,
              height: 16,
              child: VerticalDivider(thickness: 1, color: AppColor.darkText1),
            ),
            width(12),
            Iconify(Mdi.human_child, size: 16, color: AppColor.secondaryColor),
            width(6),
            Text(
              "${arguments.amountChild} Child",
              style: AppFont.medium12.copyWith(color: AppColor.darkText1),
            ),
            width(12),
            SizedBox(
              width: 1,
              height: 16,
              child: VerticalDivider(thickness: 1, color: AppColor.darkText1),
            ),
            width(12),
            Iconify(Mdi.emoticon_baby_outline, size: 16, color: AppColor.secondaryColor),
            width(6),
            Text(
              "${arguments.amountInfant} Infant",
              style: AppFont.medium12.copyWith(color: AppColor.darkText1),
            ),
          ],
        ),
      ],
    );
  }
}
