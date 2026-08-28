import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:intl/intl.dart';

import '../../../../../core/common/widget/card_general.dart';
import '../../../../../core/common/widget/shimmer_loading.dart';
import '../../../../../app/theme/theme.dart';
import '../../../../../core/utils/dashed_divider.dart';
import '../../../../../core/utils/size_extension.dart';

class CardFlightAddon extends StatelessWidget {
  const CardFlightAddon({super.key, this.isReturn = false, this.isSelected = false, this.onTap});
  final bool isReturn;
  final bool isSelected;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
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
                      CachedNetworkImage(
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 100),

                        imageUrl:
                            "https://static.vecteezy.com/system/resources/thumbnails/055/210/906/small/garuda-indonesia-logo-square-rounded-garuda-indonesia-logo-garuda-indonesia-logo-free-download-free-png.png",
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => ShimmerLoading(radius: 4),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      width(6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Garuda Indonesia", style: AppFont.reguler12),

                          Text(
                            "GA-123",
                            style: AppFont.reguler10.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: isSelected,
                  child: Container(
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
                ),
              ],
            ),

            height(8),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isReturn ? "DPS" : "CGK", style: AppFont.medium14),
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
                            child: Iconify(Bx.bxs_plane, color: AppColor.secondaryColor, size: 20),
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
                    Text(isReturn ? "CGK" : "DPS", style: AppFont.medium14),
                    height(2),
                    Text(
                      isReturn ? "Jakarta" : "Denpasar",
                      style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ],
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
          ],
        ),
      ),
    );
  }
}
