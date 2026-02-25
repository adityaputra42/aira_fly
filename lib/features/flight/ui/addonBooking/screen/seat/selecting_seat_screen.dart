import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/common/widget/primary_button.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/utils/size_extension.dart';
import '../../../../../../core/utils/widget_helper.dart';
import '../../../flightResult/screen/flight_result_screen.dart';
import '../../widget/custom_tab_bar_pax.dart';

class SelectingSeatScreen extends StatefulWidget {
  const SelectingSeatScreen({super.key});

  @override
  State<SelectingSeatScreen> createState() => _SelectingSeatScreenState();
}

class _SelectingSeatScreenState extends State<SelectingSeatScreen> {
  var selectedIndex = 0;
  List<String> passengger = ["Mr. Aditya Pratama", "Mrs. Gita Prigi", "Mstr. Zayn Rayyan"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "Selecting Seat",
        color: AppColor.primaryColor,
        titleColor: AppColor.darkText1,
      ),
      body: Column(
        children: [
          widget.height(16),
          CardInfoFlight(),
          widget.height(12),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  CustomTabBarPassager(
                    titles: passengger,
                    selectedIndex: selectedIndex,
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
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
                title: "Add Seat",
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
