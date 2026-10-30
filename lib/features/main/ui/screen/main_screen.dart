import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:pss_app/app/routes/route_names.dart';
import 'package:pss_app/app/theme/app_color.dart';
import 'package:pss_app/features/home/presentation/screen/home_screen.dart';
import 'package:pss_app/features/setting/ui/screen/setting_screen.dart';
import 'package:pss_app/features/ticket/presentation/screen/ticket_screen.dart';
import 'package:pss_app/features/wallet/presentation/screen/wallet_screen.dart';

import '../../../../core/common/cubit/user_cubit.dart';
import '../cubit/main_cubit.dart';
import '../widget/custom_bottom_navbar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    body(int selectedIndex) {
      switch (selectedIndex) {
        case 0:
          return HomeScreen();
        case 1:
          return TicketScreen();
        case 3:
          return WalletScreen();
        case 4:
          return SettingScreen();

        default:
          return HomeScreen();
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:  Container(margin: EdgeInsets.only(bottom: 80),
        width: 54,
        height: 54,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color:AppColor.secondaryColor.withValues(alpha: 0.2),
            blurRadius: 0.5,
            offset: Offset(0, 1),
          ),
        ],
            shape: BoxShape.circle, color: AppColor.primaryColor),
        child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.cardLight
                    .withValues(alpha: 0.15)),
            child:
            Iconify(
              Ph.microphone_duotone,
              color: AppColor.secondaryColor,
              size: 20,
            )),),
      body: BlocBuilder<MainCubit, int>(
        builder: (context, selectedIndex) {
          return Stack(
            children: [
              body(selectedIndex),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: BlocSelector<UserCubit, UserState, bool>(
                    selector: (state) {
                      return state is UserLoggedIn;
                    },
                    builder: (ctx, isLoggedIn) {
                      return CustomBottomNavbar(
                        onTap: (index) {
                          if (!isLoggedIn && index == 2) {
                            ctx.goNamed(RouteNames.signin);
                          } else {
                            context.read<MainCubit>().setTab(index);
                          }
                        },
                        selectedIndex: selectedIndex,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
