import 'package:flutter/material.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/utils/size_extension.dart';

class GlobalFunction {
  static bool isMultiLine(BuildContext context, String firstString, String? secondString) {
    final maxWidth = context.w(0.4);

    final textSpanFrom = TextSpan(text: firstString, style: AppFont.medium14);

    final textSpaTo = TextSpan(text: secondString, style: AppFont.medium14);

    final textPainterFrom = TextPainter(
      text: textSpanFrom,
      textDirection: TextDirection.ltr,
      maxLines: 2, // Set the max lines to 2
    );

    final textPainterTo = TextPainter(
      text: textSpaTo,
      textDirection: TextDirection.ltr,
      maxLines: 2,
    );

    textPainterFrom.layout(maxWidth: maxWidth);
    textPainterTo.layout(maxWidth: maxWidth);
    final bool isMultiline = textPainterFrom.didExceedMaxLines || textPainterTo.didExceedMaxLines;
    return isMultiline;
  }
}
