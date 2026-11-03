import 'package:flutter/material.dart';
import 'package:pss_app/app/theme/app_font.dart';
import 'package:pss_app/core/common/widget/card_general.dart';
import 'package:pss_app/core/common/widget/empty.dart';
import 'package:pss_app/core/constants/images.dart';
import 'package:pss_app/features/AiAssistant/domain/entities/chat_entity.dart';

import '../../../../app/theme/app_color.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/utils/widget_helper.dart';

class ChatHistoryScreen extends StatelessWidget {
  final List<ChatConversationEntity> conversations;
  final ValueChanged<ChatConversationEntity> onConversationSelected;

  const ChatHistoryScreen({
    super.key,
    required this.conversations,
    required this.onConversationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context);

    return Scaffold(
      appBar: WidgetHelper.appBar(
        context: context,
        title: "Chat History",
        color: AppColor.primaryColor,
        titleColor: AppColor.darkText1,
      ),
      body: conversations.isEmpty
          ? const Center(child: Empty(title: 'No chat history yet'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: conversations.length,
              separatorBuilder: (_, _) => height(12),
              itemBuilder: (context, index) {
                final item = conversations[index];
                return CardGeneral(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(spacing: 12,
                    children: [
                      CircleAvatar(
                        backgroundColor: colors.colorScheme.primary.withAlpha(30),
                        child: Image.asset(AppImages.aiIcon, width: 24),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppFont.medium14,
                            ),
                            Text(
                              item.preview,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppFont.reguler12.copyWith(color: colors.hintColor),
                            ),
                          ],
                        ),
                      ),  Icon(Icons.chevron_right_rounded,size: 24,color: colors.colorScheme.onSurface,),
                    ],
                  ),
                );


              },
            ),
    );
  }
}
