import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/theme.dart';
import '../../utils/size_extension.dart';

class DropDownCustom extends StatelessWidget {
  const DropDownCustom({
    super.key,
    required this.listData,
    this.title,
    required this.hint,
    this.value,
    this.onChange,
    this.color,
    this.hintStyle,
    this.textStyle,
    this.contentPadding,
    this.borderColor,
    this.borderRadius,
    this.filledColor,
    this.filled = true,
    this.heightWidget,
    this.prefixIcon,
    this.enable = true,
    this.prefix,
    this.suffix,
    this.icon,
  });
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? filledColor;
  final bool filled;
  final String hint;
  final String? title;
  final dynamic value;
  final double? heightWidget;
  final Widget? icon;
  final Widget? suffix;
  final Widget? prefix;
  final List<DropdownItem>? listData;
  final Function(dynamic)? onChange;
  final Color? color;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final bool enable;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        title == null
            ? const SizedBox()
            : Column(
                children: [
                  Text(
                    title ?? '',
                    style: AppFont.medium12.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  height(8),
                ],
              ),
        SizedBox(
          height: heightWidget,
          child: DropdownButtonFormField2<dynamic>(
            isExpanded: true,
            isDense: true,

            style: AppFont.medium14,
            decoration: InputDecoration(
              enabled: enable,
              isDense: true,
              contentPadding: contentPadding ?? const EdgeInsets.symmetric(vertical: 8),
              suffixIcon: icon,
              suffix: suffix,
              prefixIcon: prefixIcon,
              prefixIconConstraints: BoxConstraints(
                maxHeight: 24,
                minHeight: 12,
                maxWidth: 72,
                minWidth: 36,
              ),
              suffixIconConstraints: BoxConstraints(
                maxHeight: 24,
                minHeight: 12,
                maxWidth: 72,
                minWidth: 36,
              ),
              prefix: prefix,
              hintText: hint,
              filled: filled,
              fillColor: filledColor ?? Theme.of(context).colorScheme.surface,
              hintStyle:
                  hintStyle ??
                  AppFont.reguler12.copyWith(
                    color: Theme.of(context).hintColor,
                    overflow: TextOverflow.ellipsis,
                  ),
              border: OutlineInputBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: borderColor ?? Theme.of(context).colorScheme.outline,
                  width: 0.5,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: borderColor ?? Theme.of(context).colorScheme.outline,
                  width: 0.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: borderColor ?? Theme.of(context).colorScheme.outline,
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColor.secondaryColor),
              ),
            ),

            menuItemStyleData: MenuItemStyleData(padding: EdgeInsets.only(left: 16, right: 12)),

            items: listData,

            onChanged: onChange,
            valueListenable: value == "" || value == null
                ? ValueNotifier(null)
                : ValueNotifier<dynamic>(value),
            iconStyleData: IconStyleData(
              openMenuIcon: Icon(Icons.expand_less),
              icon: Icon(Icons.expand_more),
              iconSize: 16,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                color: color ?? Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
