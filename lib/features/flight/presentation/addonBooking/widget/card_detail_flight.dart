part of '../screen/addon_booking_screen.dart';

class CardDetailFlight extends StatelessWidget {
  const CardDetailFlight({super.key});

  @override
  Widget build(BuildContext context) {
    return CardGeneral(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(DateFormat('dd MMM yyyy').format(DateTime.now()), style: AppFont.reguler12),
              width(8),
              Iconify(MaterialSymbols.swap_horiz_rounded, color: AppColor.secondaryColor, size: 20),
              width(8),
              Text(
                DateFormat('dd MMM yyyy').format(DateTime.now().add(Duration(days: 5))),
                style: AppFont.reguler12,
              ),
            ],
          ),
          height(8),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CGK", style: AppFont.semibold20),
                  height(2),
                  Text("Jakarta", style: AppFont.reguler12),
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
                  Text("DPS", style: AppFont.semibold20),
                  height(2),
                  Text("Denpasar", style: AppFont.reguler12),
                ],
              ),
            ],
          ),
          height(12),
          Row(
            children: [
              Iconify(Mdi.person, size: 16, color: AppColor.secondaryColor),
              width(6),
              Text("2 Adult", style: AppFont.medium12),
              width(12),
              SizedBox(
                width: 1,
                height: 16,
                child: VerticalDivider(thickness: 1, color: AppColor.darkText1),
              ),
              width(12),
              Iconify(Mdi.human_child, size: 16, color: AppColor.secondaryColor),
              width(6),
              Text("1 Child", style: AppFont.medium12),
              width(12),
              SizedBox(
                width: 1,
                height: 16,
                child: VerticalDivider(thickness: 1, color: AppColor.darkText1),
              ),
              width(12),
              Iconify(Mdi.emoticon_baby_outline, size: 16, color: AppColor.secondaryColor),
              width(6),
              Text("0 Infant", style: AppFont.medium12),
            ],
          ),
        ],
      ),
    );
  }
}
