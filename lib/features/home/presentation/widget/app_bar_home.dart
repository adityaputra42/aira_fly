import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pss_app/core/common/cubit/user_cubit.dart';

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
      backgroundColor: Theme.of(context).colorScheme.primary,
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
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColor.cardLight.withValues(alpha: .25),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications, size: 20, color: AppColor.cardLight),
          ),
        ],
      ),
    );
  }
}
