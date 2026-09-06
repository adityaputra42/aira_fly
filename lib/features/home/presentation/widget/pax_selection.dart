import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';

enum PaxType { adult, child, infant }

class PaxSelectionDialog extends StatefulWidget {
  final int amountAdult;
  final int amountChild;
  final int amountInfant;

  const PaxSelectionDialog({
    super.key,
    required this.amountAdult,
    required this.amountChild,
    required this.amountInfant,
  });

  @override
  State<PaxSelectionDialog> createState() => PaxSelectionDialogState();
}

class PaxSelectionDialogState extends State<PaxSelectionDialog> {
  late int amountAdult;
  late int amountChild;
  late int amountInfant;

  void onAdd({required PaxType type}) {
    switch (type) {
      case PaxType.adult:
        amountAdult++;
        break;
      case PaxType.child:
        amountChild++;
        break;
      case PaxType.infant:
        amountInfant++;
        break;
    }
    setState(() {});
  }

  void onRemove({required PaxType type}) {
    switch (type) {
      case PaxType.adult:
        if (amountInfant == amountAdult) {
          amountInfant--;
        }
        amountAdult--;
        break;
      case PaxType.child:
        amountChild--;
        break;
      case PaxType.infant:
        amountInfant--;
        break;
    }
    setState(() {});
  }

  int maxChildAndChildNoBed() {
    int max = 0;
    if (amountAdult == 0) {
      max = 0;
    } else {
      max = 20;
    }
    return max;
  }

  void onMax({required PaxType type}) {
    if (type != PaxType.infant && amountAdult + amountChild >= 9) {
      // AppMessage.showToast(AppLocalizations.of(context)!.passengerLimit);
      return;
    }
    if (type == PaxType.infant && amountInfant <= amountAdult) {
      // AppMessage.showToast(AppLocalizations.of(context)!.infantLimit);
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    amountAdult = widget.amountAdult;
    amountChild = widget.amountChild;
    amountInfant = widget.amountInfant;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: CardGeneral(
        margin: EdgeInsets.zero,
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Passanger",
              style: AppFont.medium16,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            PaxQuantitySelector(
              title: "Adult",
              subtitle: "16++",
              amount: amountAdult,
              maxAmount: 10,
              minAmount: 0,
              onAdd: () {
                onAdd(type: PaxType.adult);
              },
              onRemove: () {
                onRemove(type: PaxType.adult);
              },
              onMax: () {
                onMax(type: PaxType.adult);
              },
            ),

            PaxQuantitySelector(
              title: "Child",
              subtitle: "Child",
              amount: amountChild,
              maxAmount: maxChildAndChildNoBed(),
              minAmount: 0,
              onAdd: () {
                onAdd(type: PaxType.child);
              },
              onRemove: () {
                onRemove(type: PaxType.child);
              },
              onMax: () {
                onMax(type: PaxType.child);
              },
            ),

            PaxQuantitySelector(
              title: "Infant",
              subtitle: "Infant",
              amount: amountInfant,
              maxAmount: amountAdult,
              minAmount: 0,
              onAdd: () {
                onAdd(type: PaxType.infant);
              },
              onRemove: () {
                onRemove(type: PaxType.infant);
              },
              onMax: () {
                onMax(type: PaxType.infant);
              },
            ),
            PrimaryButton(
              title: "Save",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PaxQuantitySelector extends StatefulWidget {
  final String title;
  final String subtitle;
  final int amount;
  final int? maxAmount;
  final int minAmount;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onMax;

  const PaxQuantitySelector({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.maxAmount,
    required this.minAmount,
    required this.onAdd,
    required this.onRemove,
    required this.onMax,
  });

  @override
  State<PaxQuantitySelector> createState() => _PaxQuantitySelectorState();
}

class _PaxQuantitySelectorState extends State<PaxQuantitySelector> {
  Timer? timer;

  void _onAdd() {
    if (widget.maxAmount != null) {
      widget.amount < widget.maxAmount! ? widget.onAdd() : widget.onMax();
    } else {
      widget.onAdd();
    }
  }

  void _onRemove() {
    if (widget.amount > widget.minAmount) {
      widget.onRemove();
    }
  }

  IconData _buildAddIcon() {
    IconData icon = Icons.add_circle_rounded;
    if (widget.maxAmount != null) {
      if (widget.amount < widget.maxAmount!) {
        icon = Icons.add_circle_rounded;
      } else {
        icon = Icons.add_circle_outline_rounded;
      }
    }
    return icon;
  }

  IconData _buildRemoveIcon() {
    IconData icon = Icons.remove_circle_outline_rounded;
    if (widget.amount > widget.minAmount) {
      icon = Icons.remove_circle_rounded;
    }
    return icon;
  }

  double _getNumberWidth() {
    double width = 8;
    if (widget.amount.toString().length >= 2) {
      width = 20;
    }
    if (widget.amount.toString().length >= 3) {
      width = 35;
    }
    return width;
  }

  double _getButtonSpaceWidth() {
    double width = 20;
    if (widget.amount.toString().length >= 2) {
      width = 14;
    }
    if (widget.amount.toString().length >= 3) {
      width = 6.5;
    }
    return width;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: AppFont.medium14,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                widget.subtitle,
                style: AppFont.reguler14.copyWith(color: Theme.of(context).hintColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: _onRemove,
          onLongPressStart: (detail) {
            setState(() {
              timer = Timer.periodic(const Duration(milliseconds: 150), (t) async {
                _onRemove();
              });
            });
          },
          onLongPressEnd: (detail) {
            if (timer != null) {
              timer!.cancel();
            }
          },
          child: Icon(_buildRemoveIcon(), color: AppColor.primaryColor),
        ),
        SizedBox(width: _getButtonSpaceWidth()),
        SizedBox(
          width: _getNumberWidth(),
          child: Text(
            widget.amount.toString(),
            style: AppFont.reguler14,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(width: _getButtonSpaceWidth()),
        GestureDetector(
          onTap: _onAdd,
          onLongPressStart: (detail) {
            timer = Timer.periodic(const Duration(milliseconds: 150), (t) async {
              _onAdd();
            });
          },
          onLongPressEnd: (detail) {
            if (timer != null) {
              timer!.cancel();
            }
          },
          child: Icon(_buildAddIcon(), color: AppColor.primaryColor),
        ),
      ],
    );
  }
}
