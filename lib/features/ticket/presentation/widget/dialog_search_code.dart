import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pss_app/core/utils/size_extension.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_font.dart';
import '../../../../core/common/widget/card_general.dart';
import '../../../../core/common/widget/input_text.dart';
import '../../../../core/common/widget/primary_button.dart';

class DialogSearchCode extends StatefulWidget {
  const DialogSearchCode({super.key});

  @override
  State<DialogSearchCode> createState() => _DialogSearchCodeState();
}

class _DialogSearchCodeState extends State<DialogSearchCode> {
  final _codeController = TextEditingController();
  bool isDisable = true;

  void setDisable() {
    final code = _codeController.text.trim();
    setState(() {
      if (code.isNotEmpty) {
        isDisable = false;
      } else {
        isDisable = true;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: CardGeneral(width: context.w(0.8),margin: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Find your booking', style: AppFont.medium16),
                ),
                InkWell(
                  onTap: () => context.pop(),
                  child: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ), widget.height(4),
            Text(
              "Enter the booking code from your confirmation to look it up.",
              style: AppFont.reguler12.copyWith(color: Theme.of(context).hintColor),
            ),
           widget.height(16),
            InputText(
              filled: true,
              filledColor: Theme.of(context).colorScheme.surface,
              controller: _codeController,
              onChange: (p0) {
                setDisable();
              },
              hintText: 'e.g. BF47S8',
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              disable: isDisable,
              title: 'Search',
              onPressed: () {
                context.pop();
                context.goNamed(
                  RouteNames.ticketDetail,
                  extra: _codeController.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
