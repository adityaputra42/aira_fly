import 'package:flutter/material.dart';
import 'package:pss_app/core/utils/size_extension.dart';

import '../../../config/theme/theme.dart';

class Numpadcustom extends StatelessWidget {
  final TextEditingController controller;
  final Function delete;
  final double? heightWidget;
  final EdgeInsets? margin;
  final Color? color;
  const Numpadcustom({
    super.key,
    required this.controller,
    this.heightWidget,
    required this.delete,
    this.color,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              NumbButton(
                number: 1,
                color: color,
                controller: controller,
                heightWidget: heightWidget,
              ),
              width(12),
              NumbButton(
                number: 2,
                color: color,
                controller: controller,
                heightWidget: heightWidget,
              ),
              width(12),
              NumbButton(
                number: 3,
                color: color,
                controller: controller,
                heightWidget: heightWidget,
              ),
            ],
          ),
          height(12),
          Row(
            children: [
              NumbButton(
                number: 4,
                color: color,
                controller: controller,
                heightWidget: heightWidget,
              ),
              width(12),
              NumbButton(
                number: 5,
                color: color,
                controller: controller,
                heightWidget: heightWidget,
              ),
              width(12),
              NumbButton(
                number: 6,
                color: color,
                controller: controller,
                heightWidget: heightWidget,
              ),
            ],
          ),
          height(12),
          Row(
            children: [
              NumbButton(
                number: 7,
                color: color,
                controller: controller,
                heightWidget: heightWidget,
              ),
              width(12),
              NumbButton(
                number: 8,
                color: color,
                controller: controller,
                heightWidget: heightWidget,
              ),
              width(12),
              NumbButton(
                number: 9,
                color: color,
                controller: controller,
                heightWidget: heightWidget,
              ),
            ],
          ),
          height(12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: heightWidget ?? 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: color ?? Theme.of(context).cardColor,
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Center(
                      child: Text(
                        ".",
                        style: AppFont.semibold18.copyWith(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              width(12),
              NumbButton(
                number: 0,
                color: color,
                heightWidget: heightWidget,
                controller: controller,
              ),
              width(12),
              Expanded(
                child: Container(
                  height: heightWidget ?? 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: color ?? Theme.of(context).cardColor,
                  ),
                  child: TextButton(
                    onPressed: () => delete(),
                    child: Center(
                      child: Icon(
                        Icons.backspace_outlined,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NumbButton extends StatelessWidget {
  final int number;
  final TextEditingController controller;
  final double? heightWidget;
  final Color? color;
  const NumbButton({
    super.key,
    required this.number,
    this.heightWidget,
    this.color,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: heightWidget ?? 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color ?? Theme.of(context).cardColor,
        ),
        child: TextButton(
          onPressed: () {
            controller.text += number.toString();
          },
          child: Center(
            child: Text(
              number.toString(),
              style: AppFont.medium18.copyWith(
                fontSize: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
