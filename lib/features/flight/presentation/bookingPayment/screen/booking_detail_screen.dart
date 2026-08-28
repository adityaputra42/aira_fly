import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:intl/intl.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/input_text.dart';
import 'package:pss_app/core/common/widget/secondary_button.dart';
import 'package:pss_app/core/utils/size_extension.dart';

import '../../../../../core/common/widget/primary_button.dart';
import '../../../../../core/common/widget/shimmer_loading.dart';
import '../../../../../app/theme/theme.dart';
import '../../../../../core/utils/clipper.dart';
import '../../../../../core/utils/dashed_divider.dart';
import '../../../../../core/utils/widget_helper.dart';

part '../widget/card_ticket_booking_detail.dart';
part '../widget/carousel_ticket.dart';
part '../widget/price_detail.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "Booking Payment",
        color: AppColor.primaryColor,
        titleColor: AppColor.darkText1,
      ),
      body: ListView(
        children: [
          height(8),
          CarouselTicket(),
          PriceDetail(),
          CardGeneral(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Payment Method", style: AppFont.semibold16),
                height(8),
                InputText(
                  hintText: "Select payment Method",
                  readOnly: true,
                  cursor: false,
                  prefixIcon: Iconify(Mdi.bank_add, size: 16, color: AppColor.secondaryColor),
                  icon: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ),
              ],
            ),
          ),

          height(8),
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
                        ).format(8400000),
                        style: AppFont.medium14,
                      ),
                    ],
                  ),
                ],
              ),
              PrimaryButton(
                title: "Pay Now",
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
