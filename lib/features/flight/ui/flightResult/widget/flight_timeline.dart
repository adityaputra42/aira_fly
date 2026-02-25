part of '../screen/flight_result_screen.dart';

class FlightTimeline extends StatelessWidget {
  const FlightTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CardGeneral(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(children: [CardTimeline(), height(16), CardTimeline()]),
        ),
      ),
    );
  }
}

class CardTimeline extends StatelessWidget {
  const CardTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == 4;
    }

    return Column(
      children: [
        Row(
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
            width(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("CGK", style: AppFont.medium12),
                      width(8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      width(8),
                      Text("DPS", style: AppFont.medium12),
                    ],
                  ),
                  height(2),
                  Text(
                    "Jakarta to Denpasar",
                    style: AppFont.reguler10.copyWith(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: Theme.of(context).hintColor,
                    ),
                    height(2),
                    Text(DateFormat("dd MMM yyyy").format(DateTime.now()), style: AppFont.medium12),
                  ],
                ),
                Text(
                  "GA-123",
                  style: AppFont.reguler10.copyWith(color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ],
        ),
        height(16),
        FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0.04,
            color: Theme.of(context).hintColor,
            indicatorTheme: const IndicatorThemeData(size: 10, position: 0.5),
            connectorTheme: const ConnectorThemeData(thickness: 2.5),
          ),
          builder: TimelineTileBuilder.connected(
            itemCount: 5,
            indicatorBuilder: (_, index) {
              return DotIndicator(
                size: isEdgeIndex(index) || index == 2 ? 0 : null,
                color: isEdgeIndex(index) ? null : AppColor.secondaryColor,
                border: Border.all(color: AppColor.secondaryColor, width: 0.5),
              );
            },
            contentsBuilder: (context, index) {
              if (index == 1) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16, left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Jakarta (CGK)", style: AppFont.medium12),
                          Text("09:00", style: AppFont.reguler12),
                        ],
                      ),
                      height(2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Soekarno Hatta Intl. Airport",
                            style: AppFont.reguler10.copyWith(color: Theme.of(context).hintColor),
                          ),
                          Text(
                            "Terminal 3",
                            style: AppFont.reguler10.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              if (index == 2) {
                return CardGeneral(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  background: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  useShadow: false,
                  radius: 4,
                  child: Text(
                    "Duration: 2h 45m",
                    style: AppFont.reguler12.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              }
              if (index == 3) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16, left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Denpasar (DPS)", style: AppFont.medium14),
                          Text("11:45", style: AppFont.reguler14),
                        ],
                      ),
                      height(2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Ngurah Rai Intl. Airport",
                            style: AppFont.reguler10.copyWith(color: Theme.of(context).hintColor),
                          ),
                          Text(
                            "Terminal 1",
                            style: AppFont.reguler10.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return null;
            },
            connectorBuilder: (_, index, type) {
              if (isEdgeIndex(index) || index == 3) {
                return null;
              }

              return Connector.solidLine(
                color: Theme.of(context).canvasColor,
                space: 2.5,
                thickness: 2.5,
              );
            },
          ),
        ),
        height(16),
        generateDashedDivider(context.w(0.84), dashColor: Theme.of(context).canvasColor),
      ],
    );
  }
}
