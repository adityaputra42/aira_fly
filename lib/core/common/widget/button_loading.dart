import 'package:flutter/material.dart';

import '../../theme/app_color.dart';

class ButtonLoading extends StatelessWidget {
  const ButtonLoading({
    super.key,
    this.width = double.infinity,
    this.margin = EdgeInsets.zero,
    this.height = 48,
  });
  final double width;
  final EdgeInsets margin;

  final double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {},
        child: const Padding(
          padding: EdgeInsets.all(2),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColor.darkText1,
              strokeWidth: 2,
            ),
          ),
        ),
      ),
    );
  }
}
