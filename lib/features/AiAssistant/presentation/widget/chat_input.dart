import 'package:flutter/material.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/input_text.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onAttachment;
  final bool enabled;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.onAttachment,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.only(top: 12),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(color: colors.cardColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: enabled ? onAttachment : null,
                  child: CardGeneral(
                    background: AppColor.primaryColor,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.zero,
                    child: const Icon(Icons.add_rounded, size: 24,color: AppColor.darkText1,),
                  ),
                ),

                Expanded(
                  child: InputText(
                    controller: controller,
                    enable: enabled,
                    hintText: "Type Message...",
                    textInputAction: TextInputAction.send,
                    onSubmited: (_) => onSend(),
                  ),
                ),
                InkWell(
                  onTap: enabled ? onSend : null,
                  child: CardGeneral(
                    background: AppColor.primaryColor,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.zero,
                    child: const Icon(Icons.send_rounded, size: 24,color: AppColor.darkText1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
