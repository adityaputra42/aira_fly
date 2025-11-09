
import 'package:flutter/material.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../config/theme/app_font.dart';

class AppBarHome extends StatelessWidget {
  const AppBarHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      toolbarHeight: 60,
      expandedHeight: 60,
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, Aditya",
                  style: AppFont.semibold16.copyWith(
                    color: AppColor.darkText1,
                  ),
                ),
                Text(
                  "Let's start your journey",
                  style: AppFont.reguler12.copyWith(
                    color: AppColor.darkText1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColor.cardLight.withValues(alpha: .25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications,
              size: 20,
              color: AppColor.cardLight,
            ),
          ),
        ],
      ),
    );
  }
}
