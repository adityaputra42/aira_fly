import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/input_text.dart';

import '../../../../../core/common/widget/primary_button.dart';
import '../../../../../core/routes/route_names.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/utils/dashed_divider.dart';
import '../../../../../core/utils/size_extension.dart';
import '../../../../../core/utils/widget_helper.dart';

part "../widget/appbar_pax_booking.dart";

class PaxBookingScreen extends StatelessWidget {
  const PaxBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "Passenger Booking Flight",
        height: 132,
        color: AppColor.primaryColor,
        titleColor: AppColor.darkText1,
        bottomWidet: AppbarPaxBooking(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height(16),
              Text("Contact Information", style: AppFont.semibold16),
              height(8),
              CardGeneral(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Aditya Pratama", style: AppFont.medium14),
                          height(4),
                          Text(
                            "aditya27@gmail.com",
                            style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                          ),
                          height(4),
                          Text(
                            "(+62) 812 3456 7890",
                            style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColor.secondaryColor.withValues(alpha: 0.2),
                        ),
                        child: Text(
                          "Edit",
                          style: AppFont.medium14.copyWith(color: AppColor.secondaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              height(16),
              Text("Passenger Information", style: AppFont.semibold16),
              height(12),
              InputText(
                hintText: "Please input adult 1",
                title: "Adult 1",
                controller: TextEditingController(text: "Mr. Aditya Pratama"),
                filled: true,
                readOnly: true,
                cursor: false,
                icon: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                filledColor: Theme.of(context).cardColor,
              ),
              height(12),
              InputText(
                hintText: "Please input adult 2",
                title: "Adult 2",
                controller: TextEditingController(text: "Mrs. Gita Prigi"),
                filled: true,
                readOnly: true,
                cursor: false,
                icon: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                filledColor: Theme.of(context).cardColor,
              ),
              height(12),
              InputText(
                hintText: "Please input child 1",
                title: "Child 1",
                controller: TextEditingController(text: "Mstr. Zayn Rayyan"),
                filled: true,
                readOnly: true,
                cursor: false,
                icon: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                filledColor: Theme.of(context).cardColor,
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
                  width(4),
                  Iconify(
                    Mdi.expand_more,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 28,
                  ),
                ],
              ),
              PrimaryButton(
                title: "Continue",
                onPressed: () {
                  context.pushNamed(RouteNames.addonBooking);
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
