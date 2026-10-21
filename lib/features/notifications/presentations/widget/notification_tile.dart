import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/init_dependencies.dart';
import '../../../../app/theme/theme.dart';
import '../../../../core/common/widget/card_general.dart';
import '../../../../core/utils/size_extension.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notification_bloc.dart';

class NotificationTile extends StatelessWidget {
  final NotificationEntity item;
  final VoidCallback onTap;

  const NotificationTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unread = item.isRead != true;

    return CardGeneral(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: unread? Border.all(width: 1,color: AppColor.secondaryColor):null,
      useShadow: false,
      background: unread
          ? theme.colorScheme.secondary.withValues(alpha: 0.25)
          : null,
      child: Row(
        spacing: 16,
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            child: Icon(
              _iconFor(item.type),
              size: 24,
              color: AppColor.darkText1,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFont.semibold16
                ),
                if ((item.body ?? '').isNotEmpty)
                  Text(
                    item.body!,style: AppFont.reguler12.copyWith(color: theme.hintColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                height(4),
                Text(
                  _timeAgo(item.createdAt),
                  style: AppFont.medium12
                ),
              ],
            ),
          ),
          unread
              ? Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColor.greenColor,
                    shape: BoxShape.circle,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  static IconData _iconFor(String? type) {
    return Icons.notifications;
  }

  static String _timeAgo(String? iso) {
    final t = DateTime.tryParse(iso ?? '')?.toLocal();
    if (t == null) return '';
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'Baru saja';
    if (d.inMinutes < 60) return '${d.inMinutes} menit lalu';
    if (d.inHours < 24) return '${d.inHours} jam lalu';
    if (d.inDays < 7) return '${d.inDays} hari lalu';
    return '${t.day.toString().padLeft(2, '0')}/${t.month.toString().padLeft(2, '0')}/${t.year}';
  }
}

class Message extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  const Message({
    super.key,
    required this.icon,
    required this.text,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 36, color: Theme.of(context).disabledColor),
          height(8),
          Text(text, textAlign: TextAlign.center),
          if (actionLabel != null) ...[
            height(8),
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

class NotificationBadge extends StatelessWidget {
  final Widget child;

  const NotificationBadge({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NotificationBloc, NotificationState, int>(
      bloc: serviceLocator<NotificationBloc>(),
      selector: (s) => s.unreadCount,
      builder: (context, count) => Badge(
        isLabelVisible: count > 0,
        label: Text(count > 99 ? '99+' : '$count'),
        child: child,
      ),
    );
  }
}
