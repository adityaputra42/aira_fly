part of '../screen/flight_selecting_screen.dart';

class CardFlightSelecting extends StatelessWidget {
  const CardFlightSelecting({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(RouteNames.flightResult);
      },
      child: CardGeneral(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => ShimmerLoading(radius: 8),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),

                width(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Garuda Indonesia", style: AppFont.semibold14),
                      height(2),
                      Text(
                        "GA-123",
                        style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                width(8),
                Text("2h 45m", style: AppFont.reguler12),
              ],
            ),
            height(16),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("09:00", style: AppFont.medium32),
                    Text(
                      DateFormat("EEE, dd MMM yyyy").format(DateTime.now()),
                      style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      generateDashedDivider(context.w(0.1), dashColor: AppColor.secondaryColor),
                      width(8),
                      Transform.rotate(
                        angle: -math.pi / 0.66,
                        child: Iconify(Bx.bxs_plane, color: AppColor.secondaryColor, size: 24),
                      ),
                      width(8),
                      generateDashedDivider(context.w(0.1), dashColor: AppColor.secondaryColor),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("11:45", style: AppFont.medium32),
                    Text(
                      DateFormat("EEE, dd MMM yyyy").format(DateTime.now()),
                      style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ],
            ),
            height(16),
            generateDashedDivider(context.w(0.84)),
            height(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.connecting_airports, size: 16, color: Theme.of(context).hintColor),
                    width(4),
                    Text(
                      "Non Stop",
                      style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      NumberFormat.currency(
                        locale: "id_ID",
                        symbol: "Rp ",
                        decimalDigits: 0,
                      ).format(1250000),
                      style: AppFont.semibold16.copyWith(color: AppColor.greenColor),
                    ),
                    Text(
                      " / pax",
                      style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
