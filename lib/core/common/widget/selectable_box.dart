import 'package:flutter/material.dart';
import 'package:pss_app/app/theme/theme.dart';

class SelectableBox extends StatelessWidget {
  final bool isSelected;
  final bool isEnable;
  final double width;
  final double height;
  final String text;
  final double radius;
  final Function() onTap;
  final double fontsize;

  const SelectableBox({
    super.key,
    this.radius = 6,
    required this.text,
    this.isSelected = false,
    this.isEnable = true,
    this.width = 144,
    this.height = 60,
    required this.onTap,
    this.fontsize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            width: 0.5,
            color: (!isEnable)
                ? (Theme.of(context).hintColor)
                : isSelected
                ? AppColor.primaryColor
                : Theme.of(context).canvasColor,
          ),
          color: (!isEnable)
              ? (Theme.of(context).highlightColor)
              : isSelected
              ? AppColor.primaryColor
              : Theme.of(context).colorScheme.surface,
        ),
        child: Center(
          child: Text(
            (text),
            style: (isSelected)
                ? AppFont.medium12.copyWith(color: AppColor.darkText1, fontSize: fontsize)
                : AppFont.reguler12.copyWith(
                    fontSize: fontsize,
                    color: Theme.of(context).hintColor,
                  ),
          ),
        ),
      ),
    );
  }
}
