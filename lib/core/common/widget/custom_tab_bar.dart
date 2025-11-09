import 'package:flutter/material.dart';

import '../../../config/theme/app_color.dart';
import '../../../config/theme/app_font.dart';

class CustomTabBar extends StatelessWidget {
  final int? selectedIndex;
  final List<String> titles;
  final Function(int)? onTap;
  final double fonsize;

  const CustomTabBar({
    super.key,
    required this.titles,
    this.selectedIndex,
    this.fonsize = 14,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: titles
          .map(
            (e) => Padding(
              padding: EdgeInsets.only(left: (e == titles.first ? 0 : 8)),
              child: GestureDetector(
                onTap: () {
                  if (onTap != null) {
                    onTap!(titles.indexOf(e));
                  }
                },
                child: Container(
                  height: 36,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: titles.indexOf(e) == selectedIndex
                        ? AppColor.primaryColor
                        : Colors.transparent,
                    border: Border.all(width: 1, color: AppColor.primaryColor),
                  ),
                  child: Center(
                    child: Text(
                      e,
                      style: (titles.indexOf(e) == selectedIndex
                          ? AppFont.medium14.copyWith(
                              color: AppColor.lightText1,
                            )
                          : AppFont.reguler14.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
