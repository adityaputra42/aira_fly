import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/core/common/widget/card_general.dart';

import '../../../../../../core/common/widget/primary_button.dart';
import '../../../../../../core/common/widget/selectable_box.dart';
import '../../../../../../app/theme/theme.dart';
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
                    value: "E3",
                    price: 115000,
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                  Expanded(
                    child: CardGeneral(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SelectableBox(
                                    text: "",
                                    onTap: () {},
                                    width: 16,
                                    height: 16,
                                    radius: 4,
                                  ),
                                  widget.width(4),
                                  Text(
                                    "Available",
                                    style: AppFont.reguler12.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SelectableBox(
                                    text: "",
                                    onTap: () {},
                                    width: 16,
                                    height: 16,
                                    isEnable: false,
                                    radius: 4,
                                  ),
                                  widget.width(4),
                                  Text(
                                    "Reversed",
                                    style: AppFont.reguler12.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SelectableBox(
                                    text: "",
                                    onTap: () {},
                                    width: 16,
                                    height: 16,
                                    isSelected: true,
                                    radius: 4,
                                  ),
                                  widget.width(4),
                                  Text(
                                    "Selected",
                                    style: AppFont.reguler12.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          widget.height(8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              6,
                              (index) => Padding(
                                padding: EdgeInsets.only(
                                  right: index < 6 - 1 ? 12 : 0,

                                  left: (index == 3) ? 24 : 0,
                                ),
                                child: SizedBox(
                                  width: 40,
                                  child: Center(
                                    child: Text(
                                      String.fromCharCode(index + 65),
                                      style: AppFont.medium14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          widget.height(8),
                          Expanded(child: SingleChildScrollView(child: generateSeats())),
                        ],
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

  Column generateSeats() {
    List<Widget> widgets = [];

    for (int i = 0; i < 10; i++) {
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            6,
            (index) => Padding(
              padding: EdgeInsets.only(
                right: index < 6 - 1 ? 12 : 0,
                bottom: 16,
                left: (index == 3) ? 24 : 0,
              ),
              child: SelectableBox(
                text: "${String.fromCharCode(index + 65)}${i + 1}",
                width: 40,
                height: 40,
                fontsize: 13,
                isEnable: index == 1 && i == 5 ? false : true,
                isSelected: index == 4 && i == 2 ? true : false,
                onTap: () {},
              ),
            ),
          ),
        ),
      );
    }

    return Column(children: widgets);
  }
}
