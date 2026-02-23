import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/core/theme/theme.dart';
import 'package:pss_app/core/utils/widget_helper.dart';

import '../../../../../core/utils/dashed_divider.dart';
import '../../../../../core/utils/size_extension.dart';

part '../widget/widget_appbar_result.dart';
part '../widget/card_info_flight.dart';
part '../widget/price_detail.dart';
part '../widget/flight_timeline.dart';

class FlightResultScreen extends StatelessWidget {
  const FlightResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "Flight Result",
        height: 132,
        color: AppColor.primaryColor,
        titleColor: AppColor.darkText1,
        bottomWidet: WidgetAppBarResult(),
      ),
      body: SafeArea(
        top: false,
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              height(8),
              CardGeneral(
                margin: EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                height: 42,
                padding: EdgeInsets.all(2),

                child: TabBar(
                  physics: const NeverScrollableScrollPhysics(),
                  automaticIndicatorColorAdjustment: false,
                  indicator: BoxDecoration(
                    color: AppColor.secondaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  isScrollable: false,
                  dividerColor: Colors.transparent,
                  indicatorColor: Theme.of(context).colorScheme.surface,
                  labelColor: AppColor.darkText1,
                  labelPadding: EdgeInsets.zero,
                  labelStyle: AppFont.medium14,
                  unselectedLabelColor: Theme.of(context).hintColor,
                  unselectedLabelStyle: AppFont.reguler12,
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (index) {},
                  tabs: const [
                    Tab(child: Text("Departure")),
                    Tab(child: Text("Return")),
                    Tab(child: Text("Price")),
                  ],
                ),
              ),
              height(8),
              Expanded(
                child: TabBarView(
                  children: [
                    Column(children: [CardInfoFlight(), FlightTimeline()]),
                    Column(children: [CardInfoFlight(isReturn: true), FlightTimeline()]),
                    PriceDetail(),
                  ],
                ),
              ),
            ],
          ),
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
                ],
              ),
              PrimaryButton(
                title: "Continue",
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
