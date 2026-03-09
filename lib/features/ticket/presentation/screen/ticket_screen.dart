import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/core/common/widget/input_text.dart';
import 'package:pss_app/core/routes/route_names.dart';

import '../../../../core/common/widget/card_general.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/clipper.dart';
import '../../../../core/utils/dashed_divider.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/utils/widget_helper.dart';
part '../widget/card_tikcet_list.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "My Ticket Booking",
        isCanBack: false,
        height: 84,
        color: AppColor.primaryColor,
        titleColor: AppColor.darkText1,
        bottomWidet: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: InputText(hintText: "Search"),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            CardGeneral(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              height: 42,
              padding: EdgeInsets.all(2),

              child: TabBar(
                physics: const NeverScrollableScrollPhysics(),
                automaticIndicatorColorAdjustment: false,
                indicator: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                isScrollable: false,
                dividerColor: Colors.transparent,
                indicatorColor: Theme.of(context).colorScheme.surface,
                labelColor: AppColor.darkText1,
                labelPadding: EdgeInsets.zero,
                labelStyle: AppFont.medium14,
                unselectedLabelColor: Theme.of(context).hintColor,
                unselectedLabelStyle: AppFont.reguler14,
                indicatorSize: TabBarIndicatorSize.tab,
                onTap: (index) {},
                tabs: const [
                  Tab(child: Text("Active Ticket")),
                  Tab(child: Text("Ticket History")),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: index == 0 ? 0 : 12,
                          bottom: index == 4 ? 126 : 0,
                        ),
                        child: CardTikcetList(),
                      );
                    },
                    itemCount: 1,
                  ),
                  ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: index == 0 ? 0 : 12,
                          bottom: index == 4 ? 126 : 0,
                        ),
                        child: CardTikcetList(),
                      );
                    },
                    itemCount: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
