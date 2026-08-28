import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/app/routes/route_names.dart';
import 'package:pss_app/features/flight/presentation/addonBooking/widget/card_flight_addon.dart';

import '../../../../../../core/common/widget/primary_button.dart';
import '../../../../../../app/theme/theme.dart';
import '../../../../../../core/utils/size_extension.dart';
import '../../../../../../core/utils/widget_helper.dart';

class AddonBagageScreen extends StatelessWidget {
  const AddonBagageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "Addon Baggage",
        color: AppColor.primaryColor,
        titleColor: AppColor.darkText1,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Departure Flight", style: AppFont.medium14),
                height(8),
                CardFlightAddon(
                  onTap: () {
                    context.pushNamed(RouteNames.selectingBaggage);
                  },
                ),
              ],
            ),
            height(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Return Flight", style: AppFont.medium14),
                height(8),
                CardFlightAddon(
                  isReturn: true,
                  onTap: () {
                    context.pushNamed(RouteNames.selectingBaggage);
                  },
                ),
              ],
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                blurRadius: 0.5,
                offset: Offset(0, 0.5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Total Price", style: AppFont.reguler12),
                      Text(
                        NumberFormat.currency(
                          locale: "id_ID",
                          symbol: "Rp ",
                          decimalDigits: 0,
                        ).format(0),
                        style: AppFont.medium14,
                      ),
                    ],
                  ),
                ],
              ),
              PrimaryButton(
                title: "Add Baggage",
                onPressed: () {
                  context.pop();
                },
                width: context.w(0.4),
                borderRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
