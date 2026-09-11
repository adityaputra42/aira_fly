import 'package:flutter/material.dart';
import 'package:pss_app/features/home/presentation/widget/search_flight_form.dart';

import '../../../../app/theme/theme.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/utils/size_extension.dart';

class HeaderHome extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Container(
            width: context.w(1),
            height: context.w(0.65),
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  AppImages.map,
                  width: context.w(1),
                  color: AppColor.cardLight.withValues(alpha: .5),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              height(8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Securely Book \nYour Flight Ticket",
                  style: AppFont.semibold24.copyWith(color: AppColor.darkText1),
                ),
              ),
              height(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SearchFlightForm(),
              ),
              height(16),
            ],
          ),
        ],
      ),
    );
  }
}
