part of '../screen/booking_detail_screen.dart';

class CardTicketBookingDetail extends StatelessWidget {
  const CardTicketBookingDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipPath(
          clipper: TicketTopClipper(),
          child: CardGeneral(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            radius: 12,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    color: AppColor.secondaryColor.withValues(alpha: 0.15),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  fadeInDuration: const Duration(milliseconds: 100),

                                  imageUrl:
                                      "https://static.vecteezy.com/system/resources/thumbnails/055/210/906/small/garuda-indonesia-logo-square-rounded-garuda-indonesia-logo-garuda-indonesia-logo-free-download-free-png.png",
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => ShimmerLoading(radius: 4),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                                width(6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Garuda Indonesia", style: AppFont.medium14),
                                    height(2),
                                    Text(
                                      "GA-123",
                                      style: AppFont.reguler12.copyWith(
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Booking Code",
                                style: AppFont.reguler12.copyWith(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              height(2),
                              Text("GA517FS", style: AppFont.medium14),
                            ],
                          ),
                        ],
                      ),
                      height(16),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("CGK", style: AppFont.semibold16),
                              height(2),
                              Text(
                                "Jakarta",
                                style: AppFont.reguler12.copyWith(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    generateDashedDivider(
                                      context.w(0.175),
                                      dashColor: AppColor.secondaryColor,
                                    ),
                                    width(4),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor.secondaryColor.withValues(alpha: 0.15),
                                      ),
                                      child: Transform.rotate(
                                        angle: -math.pi / 0.66,
                                        child: Iconify(
                                          Bx.bxs_plane,
                                          color: AppColor.secondaryColor,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    width(4),
                                    generateDashedDivider(
                                      context.w(0.175),
                                      dashColor: AppColor.secondaryColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("DPS", style: AppFont.semibold16),
                              height(2),
                              Text(
                                "Denpasar",
                                style: AppFont.reguler12.copyWith(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Departure", style: AppFont.reguler12),
                          height(2),
                          Text(DateFormat("HH:mm").format(DateTime.now()), style: AppFont.medium16),
                          height(2),
                          Text(
                            DateFormat("dd MMM yyyy").format(DateTime.now()),
                            style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Duration",
                            style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                          ),
                          height(2),
                          Text("2h 45m", style: AppFont.medium14),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Arrival", style: AppFont.reguler12),
                          height(2),
                          Text(
                            DateFormat(
                              "HH:mm",
                            ).format(DateTime.now().add(Duration(hours: 2, minutes: 45))),
                            style: AppFont.medium16,
                          ),
                          height(2),
                          Text(
                            DateFormat(
                              "dd MMM yyyy",
                            ).format(DateTime.now().add(Duration(hours: 2, minutes: 45))),
                            style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                height(16),

                generateDashedDivider(context.w(0.8)),
              ],
            ),
          ),
        ),
        ClipPath(
          clipper: TicketBottomClipper(),
          child: CardGeneral(
            radius: 8,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CardItemTicket(
                  title1: 'Passenger',
                  value1: "2 Adult, 1 Child",
                  title2: 'Flight Number',
                  value2: 'GA-123',
                ),
                CardItemTicket(title1: "Terminal", value1: "3B", title2: "Gate", value2: "2"),
                CardItemTicket(
                  title1: "Class",
                  value1: "Business",
                  title2: "Seat",
                  value2: "E4, E5, E6",
                ),
                CardItemTicket(
                  title1: "Baggages",
                  value1: "BG20",
                  title2: "Meals",
                  value2: "MH21, MC12, MF36",
                ),
                height(8),
                SecondaryButton(
                  title: "Show Addon Details",
                  onPressed: () {},
                  bgColor: Theme.of(context).cardColor,
                  textColor: AppColor.secondaryColor,
                  borderColor: AppColor.secondaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CardItemTicket extends StatelessWidget {
  const CardItemTicket({
    super.key,
    required this.title1,
    required this.value1,
    required this.title2,
    required this.value2,
  });
  final String title1;
  final String value1;
  final String title2;
  final String value2;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title1, style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor)),
              height(2),
              Text(value1, style: AppFont.medium14),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(title2, style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor)),
              height(2),
              Text(value2, style: AppFont.medium14),
            ],
          ),
        ],
      ),
    );
  }
}
