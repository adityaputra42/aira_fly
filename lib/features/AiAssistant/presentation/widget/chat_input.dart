import 'package:flutter/material.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/input_text.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onAttachment;
  final bool enabled;

  final VoidCallback? onMic;
  final bool listening;


  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.onAttachment,
    this.enabled = true,
    this.onMic,
    this.listening = false,
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


                Expanded(
                  child: InputText(
                    controller: controller,
                    enable: enabled,
                    hintText: listening ? "Mendengarkan..." : "Type Message...",
                    textInputAction: TextInputAction.send,
                    onSubmited: (_) => onSend(),
                  ),
                ),

                ListenableBuilder(
                  listenable: controller,
                  builder: (context, _) {
                    final showMic = onMic != null && (listening || controller.text.trim().isEmpty);
                    final active = enabled || (showMic && listening);
                    return Tooltip(
                      message: showMic ? (listening ? 'Berhenti merekam' : 'Bicara') : 'Kirim',
                      child: InkWell(
                        onTap: active ? (showMic ? onMic : onSend) : null,
                        child: CardGeneral(
                          background: listening ? colors.colorScheme.error : AppColor.primaryColor,
                          padding: const EdgeInsets.all(8),
                          margin: EdgeInsets.zero,
                          child: Icon(
                            showMic ? (listening ? Icons.stop_rounded : Icons.mic_rounded) : Icons.send_rounded,
                            size: 24,
                            color: listening ? colors.colorScheme.onError : AppColor.darkText1,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
