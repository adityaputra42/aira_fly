import 'package:flutter/material.dart';
import 'package:pss_app/core/utils/size_extension.dart';

import '../../../app/theme/theme.dart';
import 'primary_button.dart';

class Empty extends StatelessWidget {
  const Empty({super.key, required this.title, this.width = 140, this.actionLabel, this.onAction});
  final String title;
  final double width;

  /// Optional retry/action button label. Both this and [onAction] must
  /// be set for the button to render -- added so error states (failed
  /// search, failed load) can offer a way forward instead of a dead
  /// end, without changing any of the existing call sites that only
  /// pass [title].
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
            // Image.asset(
            //   AppImage.empty,
            //   width: width,
            // ),
            height(8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppFont.medium16.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              height(16),
              PrimaryButton(title: actionLabel!, onPressed: onAction!, width: 160),
            ],
          ],
        ),
      ),
    );
  }
}
