part of '../screen/ticket_screen.dart';

class CardTikcetList extends StatelessWidget {
  const CardTikcetList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipPath(
          clipper: TicketTopClipper(radius: 8),
          child: CardGeneral(
            width: double.infinity,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Garuda Indonesia", style: AppFont.medium14),
                    Text("BF47S8", style: AppFont.reguler14),
                  ],
                ),
                height(4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "GA-245",
                      style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                    ),
                    Text("Confirm", style: AppFont.medium12.copyWith(color: AppColor.greenColor)),
                  ],
                ),
                height(16),
                generateDashedDivider(context.w(0.82)),
              ],
            ),
          ),
        ),
        ClipPath(
          clipper: TicketBottomClipper(radius: 8),
          child: CardGeneral(
            width: double.infinity,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Jakarta",
                        style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        DateFormat("dd MMM yyyy").format(DateTime.now()),
                        style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Denpasar",
                        style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("CGK", style: AppFont.medium24),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          generateDashedDivider(
                            context.w(0.15),
                            dashColor: AppColor.secondaryColor,
                          ),
                          width(4),
                          Transform.rotate(
                            angle: -math.pi / 0.66,
                            child: Iconify(Bx.bxs_plane, color: AppColor.secondaryColor, size: 20),
                          ),
                          width(4),
                          generateDashedDivider(
                            context.w(0.15),
                            dashColor: AppColor.secondaryColor,
                          ),
                        ],
                      ),
                    ),
                    Text("DPS", style: AppFont.medium24),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat("HH:mm").format(DateTime.now()),
                      style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                    ),
                    Expanded(
                      child: Text(
                        "2h 45m",
                        style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      DateFormat(
                        "HH:mm",
                      ).format(DateTime.now().add(Duration(hours: 2, minutes: 45))),
                      style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
