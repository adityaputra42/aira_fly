import 'package:flutter/material.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';

import '../../../../app/theme/theme.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/utils/widget_helper.dart';
import '../../../flight/presentation/bookingPayment/screen/booking_detail_screen.dart';

class TicketDetailScreen extends StatelessWidget {
  const TicketDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "Detail Ticket",
        color: AppColor.primaryColor,
        titleColor: AppColor.darkText1,
      ),
      body: ListView(
        children: [
          height(12),
          CarouselTicket(),
          PriceDetail(),
          PrimaryButton(
            title: "Print Ticket",
            onPressed: () {},
            margin: EdgeInsets.fromLTRB(16, 8, 16, 24),
          ),
        ],
      ),
    );
  }
}
