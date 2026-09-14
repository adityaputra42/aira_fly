import 'package:flutter/material.dart';
import 'package:pss_app/core/constants/images.dart';
import 'package:pss_app/core/utils/size_extension.dart';

import '../../../app/theme/theme.dart';
import 'primary_button.dart';

class Empty extends StatelessWidget {
  const Empty({super.key, required this.title, this.width, this.actionLabel, this.onAction});
  final String title;
  final double? width;

  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppImages.empty, width: width ?? context.w(0.32)),
            height(8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppFont.medium16.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            if (actionLabel != null && onAction != null) ...[
              height(16),
              PrimaryButton(title: actionLabel!, onPressed: onAction!, width: context.w(0.5)),
            ],
          ],
        ),
      ),
    );
  }
}
