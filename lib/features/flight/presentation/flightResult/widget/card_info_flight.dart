part of '../screen/flight_result_screen.dart';

class CardInfoFlight extends StatelessWidget {
  const CardInfoFlight({super.key, this.isReturn = false});
  final bool isReturn;
  @override
  Widget build(BuildContext context) {
    return CardGeneral(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Iconify(Mdi.airplane_takeoff, size: 16, color: AppColor.secondaryColor),
                  width(4),
                  Text(
                    DateFormat(
                      "dd MMM yyyy, HH:mm",
                    ).format(isReturn ? DateTime.now().add(Duration(days: 5)) : DateTime.now()),
                    style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
              Row(
                children: [
                  Iconify(Mdi.airplane_landing, size: 16, color: AppColor.secondaryColor),
                  width(4),
                  Text(
                    DateFormat("dd MMM yyyy, HH:mm").format(
                      isReturn
                          ? DateTime.now().add(Duration(days: 5, hours: 2, minutes: 45))
                          : DateTime.now().add(Duration(hours: 2, minutes: 45)),
                    ),
                    style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            ],
          ),
          height(8),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isReturn ? "DPS" : "CGK", style: AppFont.semibold20),
                  height(2),
                  Text(
                    isReturn ? "Denpasar" : "Jakarta",
                    style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
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
                        Transform.rotate(
                          angle: -math.pi / 0.66,
                          child: Iconify(Bx.bxs_plane, color: AppColor.secondaryColor, size: 24),
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
                  Text(isReturn ? "CGK" : "DPS", style: AppFont.semibold20),
                  height(2),
                  Text(
                    isReturn ? "Jakarta" : "Denpasar",
                    style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
