import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_font.dart';

class WidgetHelper {
  static AppBar appBar({
    required BuildContext context,
    Function()? onTap,
    Function()? onTapTitle,
    required String title,
    Widget? icon,
    Widget? iconTitle,
    Widget? bottomWidet,
    Color? color,
    Color? titleColor,
    double? fontSize,
    double height = 60,
    bool isCanBack = true,
    bool titleCenter = false,
  }) {
    return AppBar(
      elevation: 0.1,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              isCanBack
                  ? InkWell(
                      onTap:
                          onTap ??
                          () {
                            context.pop();
                          },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: (titleColor ?? Theme.of(context).hintColor).withValues(alpha: 0.2),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: titleColor ?? Theme.of(context).colorScheme.onSurface,
                            size: 18,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(width: isCanBack ? 12 : 0),
              Expanded(
                child: InkWell(
                  onTap: onTapTitle ?? () {},
                  child: iconTitle != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: AppFont.medium16.copyWith(
                                fontSize: fontSize ?? 16,
                                color: titleColor ?? Theme.of(context).colorScheme.onSurface,
                              ),

                              overflow: TextOverflow.ellipsis,
                            ),
                            iconTitle,
                          ],
                        )
                      : Text(
                          title,
                          style: AppFont.medium16.copyWith(
                            fontSize: fontSize ?? 16,
                            color: titleColor ?? Theme.of(context).colorScheme.onSurface,
                          ),

                          overflow: TextOverflow.ellipsis,
                          textAlign: titleCenter ? TextAlign.center : TextAlign.start,
                        ),
                ),
              ),
              const SizedBox(width: 16),
              icon ?? const SizedBox(),
            ],
          ),
          bottomWidet ?? const SizedBox(),
        ],
      ),
      automaticallyImplyLeading: false,
      backgroundColor: color ?? Theme.of(context).colorScheme.surface,
      surfaceTintColor: color ?? Theme.of(context).colorScheme.surface,
      shadowColor: Theme.of(context).canvasColor.withValues(alpha: 0.3),
      toolbarHeight: height,
    );
  }
}
