import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';

import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/utils/size_extension.dart';
import '../../../../../../core/utils/widget_helper.dart';
import '../../../flightResult/screen/flight_result_screen.dart';
import '../../widget/custom_tab_bar_pax.dart';

class SelectingMealScreen extends StatefulWidget {
  const SelectingMealScreen({super.key});

  @override
  State<SelectingMealScreen> createState() => _SelectingMealScreenState();
}

class _SelectingMealScreenState extends State<SelectingMealScreen> {
  var selectedIndex = 0;
  List<String> passengger = ["Mr. Aditya Pratama", "Mrs. Gita Prigi", "Mstr. Zayn Rayyan"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "Selecting Meal",
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
                    value: "Chicken Katsu",
                    price: 25000,
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                  Expanded(
                    child: CardGeneral(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: EdgeInsets.all(12),
                      child: GridView.builder(
                        shrinkWrap: false,

                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.35,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          return CardGeneral(
                            background: index == 1
                                ? AppColor.secondaryColor.withValues(alpha: 0.05)
                                : Theme.of(context).colorScheme.surface,
                            margin: EdgeInsets.zero,
                            useShadow: false,
                            border: Border.all(
                              width: 1,
                              color: index == 1
                                  ? AppColor.primaryColor
                                  : Theme.of(context).canvasColor,
                            ),
                            padding: EdgeInsets.all(4),
                            radius: 6,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Chicken Katsu",
                                    style: AppFont.medium12.copyWith(
                                      color: index == 1
                                          ? AppColor.primaryColor
                                          : Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  widget.height(2),
                                  Text(
                                    NumberFormat.currency(
                                      locale: "id_ID",
                                      symbol: "Rp ",
                                      decimalDigits: 0,
                                    ).format(25000),
                                    style: AppFont.reguler10.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: 12,
                      ),
                    ),
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
                title: "Add Meal",
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
