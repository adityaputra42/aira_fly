import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pss_app/app/routes/route_names.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/input_text.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/core/constants/images.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/utils/show_snackbar.dart';
import '../../../../core/utils/widget_helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool disable = true;
  bool obscurePassword = true;
  bool obscureConfirm = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void validateDisable() {
    setState(() {
      if (nameController.text != "" &&
          usernameController.text != "" &&
          emailController.text != "" &&
          passwordController.text != "" &&
          confirmPasswordController.text == passwordController.text) {
        disable = false;
      } else {
        disable = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "Sign Up",

        color: AppColor.primaryColor,
        titleColor: AppColor.darkText1,
      ),
      body: Stack(
        children: [
          Container(
            width: context.w(1),
            height: context.w(0.75),
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
                  Center(child: Image.asset(AppImages.whiteLogo, width: context.w(0.2))),

                  widget.height(24),
                  Text(
                    "Create Account",
                    style: AppFont.medium18.copyWith(color: AppColor.darkText1),
                  ),
                  widget.height(2),
                  Text(
                    "Create an account to get started",
                    style: AppFont.reguler12.copyWith(color: AppColor.darkText1),
                  ),
                  widget.height(16),
                  Expanded(
                    child: BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthLoading) {
                          context.loaderOverlay.show();
                        } else {
                          context.loaderOverlay.hide();
                        }
                        if (state is AuthError) {
                          showSnackBar(context, state.message);
                        } else if (state is Authenticated) {
                          context.goNamed(RouteNames.main);
                        }
                      },
                      builder: (context, state) {
                        return CardGeneral(
                          margin: EdgeInsets.zero,
                          radius: 16,
                          child: LayoutBuilder(
                            builder: (context, constraints) => SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      InputText(
                                        hintText: "Input your full name",
                                        title: "Full Name",
                                        controller: nameController,
                                        onChange: (p0) {
                                          validateDisable();
                                        },
                                      ),
                                      widget.height(12),
                                      InputText(
                                        hintText: "Input your username",
                                        title: "Username",
                                        controller: usernameController,
                                        onChange: (p0) {
                                          validateDisable();
                                        },
                                      ),
                                      widget.height(12),
                                      InputText(
                                        hintText: "Input your email address!",
                                        title: "Email",
                                        controller: emailController,
                                        onChange: (p0) {
                                          validateDisable();
                                        },
                                      ),
                                      widget.height(12),
                                      InputText(
                                        hintText: "Input your password",
                                        title: "Password",
                                        controller: passwordController,
                                        obscureText: obscurePassword,
                                        onChange: (p0) {
                                          validateDisable();
                                        },
                                        icon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              obscurePassword = !obscurePassword;
                                            });
                                          },
                                          child: Icon(
                                            obscurePassword
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            size: 20,
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                      widget.height(12),
                                      InputText(
                                        hintText: "confirm your password",
                                        title: "Confirm Password",
                                        controller: confirmPasswordController,
                                        obscureText: obscureConfirm,
                                        onChange: (p0) {
                                          validateDisable();
                                        },
                                        icon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              obscureConfirm = !obscureConfirm;
                                            });
                                          },
                                          child: Icon(
                                            obscureConfirm
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            size: 20,
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                      ),

                                      widget.height(24),
                                      PrimaryButton(
                                        disable: disable,
                                        title: "Sign Up",
                                        onPressed: () {
                                          if (formKey.currentState!.validate()) {
                                            context.read<AuthBloc>().add(
                                              SignUpRequested(
                                                email: emailController.text.trim(),
                                                password: passwordController.text.trim(),
                                                name: nameController.text.trim(),
                                                username: usernameController.text.trim(),
                                              ),
                                            );
                                          }
                                        },
                                      ),

                                      widget.height(24),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "already have an account? ",
                                              style: AppFont.reguler10.copyWith(
                                                color: Theme.of(context).hintColor,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "Sign In",
                                              style: AppFont.medium10.copyWith(
                                                color: AppColor.secondaryColor,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  context.pop();
                                                },
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
                        );
                      },
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
