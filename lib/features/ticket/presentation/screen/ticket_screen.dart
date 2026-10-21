import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pss_app/core/utils/show_dialog_zoom.dart';
import 'package:pss_app/features/ticket/presentation/widget/dialog_search_code.dart';

import '../../../../app/theme/theme.dart';
import '../../../../core/common/cubit/user_cubit.dart';
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
        icon: BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            final isLoggedIn = userState is UserLoggedIn;
            return Visibility(
              visible: isLoggedIn,
              child: InkWell(onTap: () {
                showZoomDialog(context: context,
                    barrierDismissible: false,
                    child: DialogSearchCode());
              },
                  child: Icon(
                      Icons.search, size: 24, color: AppColor.darkText1)),
            );
          },
        ),
      ),

      body: const SafeArea(child: TicketBookingBody()),
    );
  }
}
