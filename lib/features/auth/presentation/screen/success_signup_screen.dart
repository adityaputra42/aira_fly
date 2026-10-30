import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pss_app/app/routes/route_names.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';

import '../../../../core/constants/images.dart';
import '../../../../core/utils/size_extension.dart';

class SuccessSignupScreen extends StatelessWidget {
  const SuccessSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppImages.successSignUp3, width: context.w(1),fit: BoxFit.cover),
              height(24),
              Text("Yeay..🎉", style: AppFont.bold20),
              height(8),
              Text(
                "successfully created a new account",
                style: AppFont.medium14.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
              height(24),
              PrimaryButton(
                title: "Login to Conitue",
                onPressed: () {
                  context.goNamed(RouteNames.signin);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
