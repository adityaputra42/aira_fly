import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:pss_app/app/init_dependencies.dart';
import 'package:pss_app/app/routes/route_names.dart';
import 'package:pss_app/core/common/cubit/theme_cubit.dart';
import 'package:pss_app/core/common/cubit/user_cubit.dart';
import 'package:pss_app/core/common/entities/user.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/utils/size_extension.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          var user = User();
          var isLogin = false;
          if (state is UserLoggedIn) {
            user = state.user;
            isLogin = true;
          }
          return SafeArea(
            top: false,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                  ),
                  child: Column(
                    children: [
                      height(48),
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: AppColor.cardLight),
                        ),
                        child: Container(
                          width: 72,
                          height: 72,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.cardLight,
                          ),
                        ),
                      ),
                      height(12),
                      Text(
                        isLogin ? (user.fullName ?? "") : "Guest User",
                        style: AppFont.medium16.copyWith(color: AppColor.darkText1),
                      ),
                      height(2),
                      Text(
                        isLogin ? (user.email ?? "") : "Sign in to make your journey easier",
                        style: AppFont.reguler12.copyWith(color: AppColor.darkText1),
                      ),
                    ],
                  ),
                ),
                height(12),
                Visibility(
                  visible: isLogin,
                  child: Column(
                    children: [
                      CardMenu(icon: Mdi.person, title: "Edit Profile"),
                      CardMenu(icon: Mdi.account_lock_open, title: "Change Password"),
                      CardMenu(icon: Mdi.file_report_outline, title: "Report"),
                    ],
                  ),
                ),
                CardMenu(icon: Mdi.language, title: "Language"),
                BlocBuilder<ThemeCubit, bool>(
                  builder: (context, isDark) {
                    return CardMenu(
                      icon: MaterialSymbols.dark_mode_rounded,
                      title: "Dark Mode",
                      rightIcon: FlutterSwitch(
                        width: 42.0,
                        height: 24.0,
                        toggleSize: 20.0,
                        value: isDark,
                        activeColor: AppColor.secondaryColor,
                        inactiveColor: Theme.of(context).highlightColor,
                        padding: 2.0,
                        onToggle: (val) {
                          context.read<ThemeCubit>().toggleTheme(val);
                        },
                      ),
                    );
                  },
                ),
                isLogin
                    ? CardMenu(
                        icon: Mdi.logout,
                        title: "Log Out",
                        ontap: () {
                          serviceLocator<AuthBloc>().add(SignOutRequested());
                        },
                      )
                    : CardMenu(
                        icon: Mdi.login,
                        title: "Log In",
                        ontap: () {
                          context.goNamed(RouteNames.signin);
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CardMenu extends StatelessWidget {
  const CardMenu({super.key, required this.icon, required this.title, this.rightIcon, this.ontap});
  final String title;
  final String icon;
  final Widget? rightIcon;
  final Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDark) {
        return CardGeneral(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            onTap: ontap,
            child: Row(
              children: [
                Iconify(
                  icon,
                  size: 24,
                  color: isDark ? AppColor.secondaryColor : AppColor.primaryColor,
                ),
                width(8),
                Expanded(child: Text(title, style: AppFont.medium14)),
                rightIcon ??
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
