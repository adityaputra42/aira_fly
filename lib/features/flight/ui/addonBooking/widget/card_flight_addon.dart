import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:intl/intl.dart';

import '../../../../../core/common/widget/card_general.dart';
import '../../../../../core/theme/theme.dart';
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
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${isReturn ? "Return" : "Departure"} Flight", style: AppFont.medium14),
                Text(
                  DateFormat(
                    'dd MMM yyyy',
                  ).format(isReturn ? DateTime.now().add(Duration(days: 5)) : DateTime.now()),
                  style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                ),
              ],
            ),
            height(12),
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
            height(12),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Iconify(Mdi.person, size: 16, color: AppColor.secondaryColor),
                      width(4),
                      Text("2 Adult", style: AppFont.medium12),
                      width(8),
                      SizedBox(
                        width: 1,
                        height: 16,
                        child: VerticalDivider(
                          thickness: 1,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      width(8),
                      Iconify(Mdi.human_child, size: 16, color: AppColor.secondaryColor),
                      width(4),
                      Text("1 Child", style: AppFont.medium12),
                      width(8),
                      SizedBox(
                        width: 1,
                        height: 16,
                        child: VerticalDivider(
                          thickness: 1,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      width(8),
                      Iconify(Mdi.emoticon_baby_outline, size: 16, color: AppColor.secondaryColor),
                      width(4),
                      Text("0 Infant", style: AppFont.medium12),
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
          ],
        ),
      ),
    );
  }
}
