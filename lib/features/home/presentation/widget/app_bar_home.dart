import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pss_app/app/routes/route_names.dart';
import 'package:pss_app/core/common/cubit/user_cubit.dart';
import 'package:pss_app/features/notifications/presentations/bloc/notification_bloc.dart';

import '../../../../app/theme/app_color.dart';
import '../../../../app/theme/app_font.dart';
import '../../../../core/utils/size_extension.dart';

class AppBarHome extends StatelessWidget {
  const AppBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      toolbarHeight: 60,
      expandedHeight: 60,
      automaticallyImplyLeading: false,
      backgroundColor:AppColor.primaryColor,
      title: Row(
        children: [
          Expanded(
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                final isLoggedIn = state is UserLoggedIn;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLoggedIn ? "Hi, ${state.user.fullName}" : "Welcome",
                      style: AppFont.semibold16.copyWith(color: AppColor.darkText1),
                    ),
                    height(2),
                    Text(
                      isLoggedIn
                          ? "Let's start your journey"
                          : "Sign in to make your journey easier",
                      style: AppFont.reguler12.copyWith(color: AppColor.darkText1),
                    ),
                  ],
                );
              },
            ),
          ),
          BlocSelector<UserCubit, UserState, bool>(
              selector: (state) {
                return state is UserLoggedIn;
              },
              builder: (ctx, isLoggedIn) {
                return BlocBuilder<NotificationBloc, NotificationState>(
                    builder: (context, state) {
                      int count = 0;
                      if (state.status == NotificationStatus.success) {
                        count = state.unreadCount;
                      }
                      return SizedBox(width: 40, height: 40,
                        child: Stack(
                          children: [
                            InkWell(onTap: () {
                              if (!isLoggedIn) {
                                ctx.goNamed(RouteNames.signin);
                              } else {
                                context.goNamed(RouteNames.notifications);
                              }
                            },
                                child: Align(alignment: Alignment.bottomRight,
                                  child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColor.cardLight.withValues(
                                            alpha: .25),
                                        shape: BoxShape.circle,
                                      ),

                                      child: Icon(Icons.notifications, size: 20,
                                          color: AppColor.cardLight)),
                                )
                            ), Visibility(visible: count > 0,
                              child: Align(alignment: Alignment.topLeft,

                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColor.redColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    count.toString(), style: AppFont.medium12
                                      .copyWith(color: AppColor.darkText1),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                );
              }
          ),
        ],
      ),
    );
  }
}
