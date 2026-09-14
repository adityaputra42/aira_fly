part of '../screen/flight_selecting_screen.dart';

class FlightSearchSkeleton extends StatelessWidget {
  const FlightSearchSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final hintColor = Theme.of(context).hintColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipPath(
            clipper: TicketTopClipper(radius: 10),
            child: CardGeneral(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColor.secondaryColor.withValues(alpha: 0.1),
                        ),
                        child: Center(
                          child: Iconify(Bx.bxs_plane, color: AppColor.secondaryColor, size: 20),
                        ),
                      ),
                      width(8),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerLoading(height: 20, radius: 4, width: context.w(0.4)),
                            height(2),
                            ShimmerLoading(height: 14, radius: 4, width: context.w(0.4)),
                          ],
                        ),
                      ),

                      Icon(Icons.schedule_rounded, size: 16),
                      width(8),
                      ShimmerLoading(height: 14, radius: 4, width: context.w(0.4)),
                    ],
                  ),
                  height(12),
                  Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerLoading(height: 36, radius: 8, width: context.w(0.15)),
                          height(2),
                          ShimmerLoading(height: 14, radius: 4, width: context.w(0.25)),
                        ],
                      ),

                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            generateDashedDivider(
                              context.w(0.1),
                              dashColor: AppColor.secondaryColor,
                            ),

                            const SizedBox(width: 4),

                            Transform.rotate(
                              angle: -math.pi / 2,
                              child: Iconify(
                                Bx.bxs_plane,
                                color: AppColor.secondaryColor,
                                size: 24,
                              ),
                            ),

                            const SizedBox(width: 4),

                            generateDashedDivider(
                              context.w(0.1),
                              dashColor: AppColor.secondaryColor,
                            ),
                          ],
                        ),
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ShimmerLoading(height: 36, radius: 8, width: context.w(0.15)),
                          height(2),
                          ShimmerLoading(height: 14, radius: 4, width: context.w(0.25)),
                        ],
                      ),
                    ],
                  ),

                  height(12),

                  generateDashedDivider(context.w(0.82)),
                ],
              ),
            ),
          ),

          ClipPath(
            clipper: TicketBottomClipper(radius: 10),
            child: CardGeneral(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.connecting_airports, size: 16, color: hintColor),
                      width(4),

                      ShimmerLoading(height: 14, radius: 4, width: context.w(0.12)),
                    ],
                  ),

                  Row(
                    children: [
                      ShimmerLoading(height: 20, radius: 4, width: context.w(0.12)),
                      width(4),
                      ShimmerLoading(height: 14, radius: 4, width: context.w(0.1)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
