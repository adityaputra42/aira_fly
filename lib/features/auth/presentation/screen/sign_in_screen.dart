import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pss_app/app/routes/route_names.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/input_text.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/core/constants/images.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/constants/environment.dart';
import '../../../../core/utils/show_snackbar.dart';
import '../../../../core/utils/widget_helper.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool disable = true;
  bool obscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (Env.appEnv != "prod") {
      emailController.text = Env.appUsernameLogin;
      passwordController.text = Env.appPasswordLogin;
      disable = false;
    }
  }

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  void validateDisable() {
    setState(() {
      if (emailController.text != "" && passwordController.text != "") {
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
        title: "Sign In",
        onTap: () {
          context.pop();
        },
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
                  Text("Welcome Back", style: AppFont.medium18.copyWith(color: AppColor.darkText1)),
                  widget.height(2),
                  Text(
                    "Sign in to continue",
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
                                        obscureText: obscureText,
                                        onChange: (p0) {
                                          validateDisable();
                                        },
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
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                      widget.height(12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "Forgot Password?",
                                          style: AppFont.reguler12.copyWith(
                                            color: AppColor.secondaryColor,
                                          ),
                                        ),
                                      ),
                                      widget.height(24),
                                      PrimaryButton(
                                        disable: disable,
                                        title: "Sign In",
                                        onPressed: () {
                                          if (formKey.currentState!.validate()) {
                                            context.read<AuthBloc>().add(
                                              SignInRequested(
                                                email: emailController.text.trim(),
                                                password: passwordController.text.trim(),
                                              ),
                                            );
                                          }
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
                                                color: Theme.of(context).hintColor,
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
                                                color: Theme.of(context).hintColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      widget.height(16),
                                      PrimaryButton(
                                        bgColor: Theme.of(context).colorScheme.surface,
                                        textColor: Theme.of(context).colorScheme.onSurface,
                                        title: "Continue With Google",
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Iconify(
                                              Mdi.google,
                                              size: 18,
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                            widget.width(8),
                                            Text(
                                              "Continue With Google",
                                              style: AppFont.medium12.copyWith(
                                                color: Theme.of(context).colorScheme.onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {},
                                      ),
                                      widget.height(16),
                                      PrimaryButton(
                                        bgColor: Theme.of(context).colorScheme.surface,
                                        textColor: Theme.of(context).colorScheme.onSurface,
                                        title: "Continue With Apple Id",
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Iconify(
                                              Mdi.apple,
                                              size: 18,
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                            widget.width(8),
                                            Text(
                                              "Continue With Apple Id",
                                              style: AppFont.medium12.copyWith(
                                                color: Theme.of(context).colorScheme.onSurface,
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
                                                color: Theme.of(context).hintColor,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "Sign Up",
                                              style: AppFont.medium10.copyWith(
                                                color: AppColor.secondaryColor,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  context.goNamed(RouteNames.signup);
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
