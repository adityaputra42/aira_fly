import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/features/flight/ui/addonBooking/widget/custom_tab_bar_pax.dart';
import 'package:pss_app/features/flight/ui/flightResult/screen/flight_result_screen.dart';

import '../../../../../../core/common/widget/primary_button.dart';
import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/utils/size_extension.dart';
import '../../../../../../core/utils/widget_helper.dart';

class SelectingBaggageScreen extends StatefulWidget {
  const SelectingBaggageScreen({super.key, this.isReturn = false});
  final bool isReturn;

  @override
  State<SelectingBaggageScreen> createState() => _SelectingBaggageScreenState();
}

class _SelectingBaggageScreenState extends State<SelectingBaggageScreen> {
  var selectedIndex = 0;
  List<String> passengger = ["Mr. Aditya Pratama", "Mrs. Gita Prigi", "Mstr. Zayn Rayyan"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "Selecting Baggage",
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
                  Expanded(child: CardListBaggage()),
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

class CardListBaggage extends StatelessWidget {
  const CardListBaggage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> baggage = ["5 Kg", "10 Kg", "15 Kg", "20 Kg", "25 Kg", "30 Kg", "35 Kg"];
    return CardGeneral(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.45,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) => CardBaggage(baggage: baggage[index]),
        itemCount: baggage.length,
      ),
    );
  }
}

class CardBaggage extends StatelessWidget {
  const CardBaggage({super.key, required this.baggage});

  final String baggage;

  @override
  Widget build(BuildContext context) {
    return CardGeneral(
      border: Border.all(width: 1, color: Theme.of(context).canvasColor),
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      radius: 6,
      useShadow: false,
      background: Theme.of(context).colorScheme.surface.withValues(alpha: 1),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              baggage,
              style: AppFont.semibold14.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            height(2),
            Text(
              NumberFormat.currency(
                locale: "id_ID",
                symbol: "Rp ",
                decimalDigits: 0,
              ).format(150000),
              style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
            ),
          ],
        ),
      ),
    );
  }
}
