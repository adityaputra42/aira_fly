import 'package:flutter/material.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/empty.dart';
import 'package:pss_app/core/constants/images.dart';
import 'package:pss_app/core/utils/size_extension.dart';
import 'package:pss_app/features/AiAssistant/domain/entities/chat_entity.dart';

class ChatDrawer extends StatelessWidget {
  final List<ChatConversationEntity> conversations;
  final String? activeConversationId;
  final ValueChanged<ChatConversationEntity> onConversationSelected;
  final VoidCallback onNewChat;
  final VoidCallback onViewAll;

  const ChatDrawer({
    super.key,
    required this.conversations,
    required this.activeConversationId,
    required this.onConversationSelected,
    required this.onNewChat,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context);

    return Drawer(
      surfaceTintColor: AppColor.darkText1,
      backgroundColor: colors.cardColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 12, 14),
              child: Row(
                children: [
                  Image.asset(AppImages.aiIcon, width: 28),
                  width(8),
                  const Expanded(
                    child: Text('AI Assistant', style: AppFont.semibold18),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      color: colors.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onNewChat,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('New Chat', style: AppFont.medium12),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text('Recent Conversations', style: AppFont.medium14),
            ),
            Expanded(
              child: conversations.isEmpty
                  ? Center(child: Empty(title: 'No conversations yet'))
                  : ListView.builder(
                      itemCount: conversations.length,
                      itemBuilder: (context, index) {
                        final item = conversations[index];
                        final selected = item.id == activeConversationId;
                        return ListTile(
                          minLeadingWidth: 12,
                          minVerticalPadding: 0,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                          selected: selected,
                          selectedTileColor: colors.colorScheme.secondary
                              .withAlpha(30),
                          leading: Icon(
                            Icons.chat_bubble_rounded,
                            size: 20,
                            color: colors.colorScheme.onSurface,
                          ),
                          title: Text(
                            item.title,
                            maxLines: 1,
                            style: AppFont.medium14.copyWith(
                              color: colors.colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            item.preview,
                            maxLines: 1,
                            style: AppFont.reguler12.copyWith(
                              color: colors.hintColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => onConversationSelected(item),
                        );
                      },
                    ),
            ),
            SizedBox(height: 1, child: const Divider(thickness: 1)),
            ListTile(
              leading: Icon(
                Icons.history_rounded,
                color: colors.colorScheme.onSurface,
              ),
              title: const Text('View All History', style: AppFont.medium12),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: colors.colorScheme.onSurface,
              ),
              onTap: onViewAll,
            ),
          ],
        ),
      ),
    );
  }
}
