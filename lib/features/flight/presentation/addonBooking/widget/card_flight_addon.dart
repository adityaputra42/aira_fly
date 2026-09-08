import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:intl/intl.dart';

import '../../../../../core/common/widget/card_general.dart';
import '../../../../../app/theme/theme.dart';
import '../../../../../core/utils/dashed_divider.dart';
import '../../../../../core/utils/size_extension.dart';
import '../../utils/flight_display_utils.dart';
import '../utils/addon_models.dart';

class CardFlightAddon extends StatelessWidget {
  const CardFlightAddon({
    super.key,
    required this.leg,
    this.isSelected = false,
    this.subtitle,
    this.onTap,
  });

  final AddonLeg leg;
  final bool isSelected;

  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final segments = leg.itinerary.segments ?? const [];
    final first = segments.isNotEmpty ? segments.first : null;
    final last = segments.isNotEmpty ? segments.last : null;

    String formatTime(DateTime? dt) =>
        dt == null ? '-' : DateFormat("dd MMM yyyy, HH:mm").format(dt);

    return InkWell(
      onTap: onTap,
      child: CardGeneral(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColor.secondaryColor.withValues(alpha: 0.1),
                        ),
                        child: Center(
                          child: Iconify(Bx.bxs_plane, color: AppColor.secondaryColor, size: 18),
                        ),
                      ),
                      width(6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(first?.flightNumber ?? '-', style: AppFont.reguler12),
                          Text(
                            formatStops(leg.itinerary.stops),
                            style: AppFont.reguler10.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppColor.greenColor.withValues(alpha: 0.15),
                      border: Border.all(color: AppColor.greenColor, width: 0.5),
                    ),
                    child: Text(
                      "Selected",
                      style: AppFont.medium12.copyWith(color: AppColor.greenColor),
                    ),
                  ),
              ],
            ),
            height(8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(first?.departureAirportCode ?? '-', style: AppFont.medium14),
                      height(2),
                      Text(
                        first?.departureAirportName ?? '-',
                        style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    generateDashedDivider(context.w(0.12), dashColor: AppColor.secondaryColor),
                    width(8),
                    Transform.rotate(
                      angle: -math.pi / 0.66,
                      child: Iconify(Bx.bxs_plane, color: AppColor.secondaryColor, size: 20),
                    ),
                    width(8),
                    generateDashedDivider(context.w(0.12), dashColor: AppColor.secondaryColor),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(last?.arrivalAirportCode ?? '-', style: AppFont.medium14),
                      height(2),
                      Text(
                        last?.arrivalAirportName ?? '-',
                        style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            height(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Iconify(Mdi.airplane_takeoff, size: 16, color: AppColor.secondaryColor),
                    width(4),
                    Text(
                      formatTime(first?.departureTime),
                      style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Iconify(Mdi.airplane_landing, size: 16, color: AppColor.secondaryColor),
                    width(4),
                    Text(
                      formatTime(last?.arrivalTime),
                      style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ],
            ),
            if (subtitle != null) ...[
              height(8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  subtitle!,
                  style: AppFont.medium12.copyWith(color: AppColor.secondaryColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
