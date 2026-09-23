import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';
import '../../../../core/utils/widget_helper.dart';
import '../widget/ticket_booking_body.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "My Ticket Booking",
        isCanBack: false,
        color: AppColor.primaryColor,
        titleColor: AppColor.darkText1,
      ),

      body: const SafeArea(child: TicketBookingBody()),
    );
  }
}
