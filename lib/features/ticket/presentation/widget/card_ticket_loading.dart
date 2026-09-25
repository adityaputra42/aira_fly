import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:pss_app/core/common/widget/shimmer_loading.dart';
import 'package:pss_app/core/utils/size_extension.dart';

import '../../../../app/theme/theme.dart';
import '../../../../core/common/widget/card_general.dart';
import '../../../../core/utils/clipper.dart';
import '../../../../core/utils/dashed_divider.dart';

class CardTicketLoading extends StatelessWidget {
  const new({super.key});

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
                  spacing: 8,
                  children: [
                    ShimmerLoading(width: 40, height: 40, radius: 5),

                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ShimmerLoading(width: context.w(0.15), height: 20, radius: 4),
                              ShimmerLoading(width: context.w(0.15), height: 20, radius: 4),
                            ],
                          ),
                          height(2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ShimmerLoading(width: context.w(0.2), height: 16, radius: 4),
                              ShimmerLoading(width: context.w(0.18), height: 16, radius: 4),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                    ShimmerLoading(width: context.w(0.2), height: 20, radius: 4),
                    ShimmerLoading(width: context.w(0.2), height: 20, radius: 4),
                    ShimmerLoading(width: context.w(0.2), height: 20, radius: 4),
                  ],
                ),
                height(4),
                Row(
                  children: [
                    ShimmerLoading(width: context.w(0.12), height: 32, radius: 4),
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
                    ShimmerLoading(width: context.w(0.12), height: 32, radius: 4),
                  ],
                ),
                height(4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerLoading(width: context.w(0.18), height: 16, radius: 4),
                    ShimmerLoading(width: context.w(0.18), height: 16, radius: 4),
                    ShimmerLoading(width: context.w(0.18), height: 16, radius: 4),
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
