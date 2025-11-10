import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:pss_app/config/routes/route_names.dart';
import 'package:pss_app/config/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/input_text.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/core/constants/images.dart';
import 'package:pss_app/core/utils/size_extension.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: context.w(1),
            height: context.h(0.4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              color: AppColor.primaryColor,
            ),
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  AppImages.map,
                  width: context.w(1),
                  color: AppColor.cardLight.withValues(alpha: .5),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        widget.height(32),
                        Image.asset(
                          AppImages.logo,
                          width: context.w(0.2),
                          color: AppColor.cardLight,
                        ),
                        widget.height(8),

                        Text(
                          "Aira Fly",
                          style: AppFont.semibold16.copyWith(
                            color: AppColor.cardLight,
                          ),
                        ),
                      ],
                    ),
                  ),

                  widget.height(24),
                  Text(
                    "Welcome Back",
                    style: AppFont.medium18.copyWith(
                      color: AppColor.lightText1,
                    ),
                  ),
                  widget.height(2),
                  Text(
                    "Sign in to continue",
                    style: AppFont.reguler12.copyWith(
                      color: AppColor.lightText1,
                    ),
                  ),
                  widget.height(16),
                  Expanded(
                    child: CardGeneral(
                      margin: EdgeInsets.zero,
                      radius: 16,
                      child: LayoutBuilder(
                        builder: (context, constraints) =>
                            SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InputText(
                                      hintText: "Input your email address!",
                                      title: "Email",
                                    ),
                                    widget.height(12),
                                    InputText(
                                      hintText: "Input your password",
                                      title: "Password",
                                      obscureText: obscureText,
                                      icon: InkWell(
                                        onTap: () {
                                          setState(() {
                                            obscureText = !obscureText;
                                          });
                                        },
                                        child: Icon(
                                          obscureText
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          size: 20,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    widget.height(12),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "Forgot Password?",
                                        style: AppFont.reguler12.copyWith(
                                          color: AppColor.primaryColor,
                                        ),
                                      ),
                                    ),
                                    widget.height(24),
                                    PrimaryButton(
                                      title: "Sign In",
                                      onPressed: () {
                                        context.goNamed(RouteNames.main);
                                      },
                                    ),
                                    widget.height(16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 1,
                                            child: Divider(
                                              thickness: 1,
                                              color: Theme.of(
                                                context,
                                              ).hintColor,
                                            ),
                                          ),
                                        ),
                                        widget.width(8),
                                        Text(
                                          "Or",
                                          style: AppFont.medium14.copyWith(
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        widget.width(8),
                                        Expanded(
                                          child: SizedBox(
                                            height: 1,
                                            child: Divider(
                                              thickness: 1,
                                              color: Theme.of(
                                                context,
                                              ).hintColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    widget.height(16),
                                    PrimaryButton(
                                      bgColor: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                      textColor: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      title: "Continue With Google",
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Iconify(
                                            Mdi.google,
                                            size: 18,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                          ),
                                          widget.width(8),
                                          Text(
                                            "Continue With Google",
                                            style: AppFont.medium12.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {},
                                    ),
                                    widget.height(16),
                                    PrimaryButton(
                                      bgColor: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                      textColor: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      title: "Continue With Apple Id",
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Iconify(
                                            Mdi.apple,
                                            size: 18,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                          ),
                                          widget.width(8),
                                          Text(
                                            "Continue With Apple Id",
                                            style: AppFont.medium12.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {},
                                    ),
                                    widget.height(24),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Don't have an account? ",
                                            style: AppFont.reguler10.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).hintColor,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "Sign Up",
                                            style: AppFont.medium10.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
