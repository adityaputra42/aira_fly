import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/theme/theme.dart';

import '../../../../../core/common/widget/primary_button.dart';
import '../../../../../core/routes/route_names.dart';
import '../../../../../core/utils/dashed_divider.dart';
import '../../../../../core/utils/size_extension.dart';
import '../../../../../core/utils/widget_helper.dart';

part '../widget/card_detail_flight.dart';
part '../widget/card_menu_addon.dart';

class AddonBookingScreen extends StatelessWidget {
  const AddonBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "Addon Booking Flight",
        color: AppColor.primaryColor,
        titleColor: AppColor.darkText1,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardDetailFlight(),
            Text("Addon Service", style: AppFont.medium14),
            height(12),
            CardMenuAddon(
              onTap: () {
                context.pushNamed(RouteNames.addonBaggage);
              },
              title: 'Baggage',
              description: 'Permit 20kg baggage for each passenger',
              icon: Mdi.bag_suitcase,
              isSelected: true,
            ),
            height(16),
            CardMenuAddon(
              onTap: () {
                context.pushNamed(RouteNames.addonMeal);
              },
              title: 'In-flight Meal',
              description: 'Pre-order your meal and enjoy it on board',
              icon: Mdi.food,
            ),
            height(16),
            CardMenuAddon(
              onTap: () {
                context.pushNamed(RouteNames.addonSeat);
              },
              title: 'Seat Selection',
              description: 'Select your preferred seat',
              icon: Mdi.seat_passenger,
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
                        ).format(4500000),
                        style: AppFont.medium14,
                      ),
                    ],
                  ),
                  width(4),
                  Iconify(
                    Mdi.expand_more,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 28,
                  ),
                ],
              ),
              PrimaryButton(
                title: "Book Now",
                onPressed: () {},
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
