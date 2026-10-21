import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pss_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:pss_app/features/notifications/presentations/bloc/notification_bloc.dart';

import '../../../../app/init_dependencies.dart';
import '../../../../app/theme/theme.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/utils/widget_helper.dart';
import '../widget/notification_tile.dart';

class NotificationScreen extends StatelessWidget {
  final void Function(BuildContext context, NotificationEntity item)? onItemTap;

  const NotificationScreen({super.key, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>.value(
      value: serviceLocator<NotificationBloc>(),
      child: _NotificationView(onItemTap: onItemTap),
    );
  }
}

class _NotificationView extends StatefulWidget {
  final void Function(BuildContext context, NotificationEntity item)? onItemTap;

  const _NotificationView({this.onItemTap});

  @override
  State<_NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<_NotificationView> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    context.read<NotificationBloc>().add(const NotificationRefreshed());
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      context.read<NotificationBloc>().add(const NotificationLoadedMore());
    }
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final bloc = context.read<NotificationBloc>()
      ..add(const NotificationRefreshed());
    await bloc.stream.firstWhere(
          (s) => s.status != NotificationStatus.loading,
      orElse: () => bloc.state,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar(
          context: context,
          title: "Notification",
          color: AppColor.primaryColor,
          titleColor: AppColor.darkText1,
          icon: BlocSelector<NotificationBloc, NotificationState, int>(
              selector: (s) => s.unreadCount,
              builder: (context, unread) {
                return InkWell(onTap: unread == 0
                    ? null
                    : () =>
                    context.read<NotificationBloc>().add(
                        const NotificationReadAllRequested()), child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: (Theme
                          .of(context)
                          .hintColor).withValues(alpha: 0.2),
                    ),
                    child: Center(child: Icon(Icons.checklist_rounded,color: AppColor.darkText1,),)));
              }
          )
      ),

      body: BlocConsumer<NotificationBloc, NotificationState>(
        listenWhen: (p, c) =>
        p.errorMessage != c.errorMessage && c.errorMessage != null &&
            c.items.isNotEmpty,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        },
        builder: (context, state) {
          if (state.items.isEmpty &&
              (state.status == NotificationStatus.initial ||
                  state.status == NotificationStatus.loading)) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.items.isEmpty &&
              state.status == NotificationStatus.failure) {
            return Message(
              icon: Icons.error_outline,
              text: state.errorMessage ?? 'Gagal memuat notifikasi',
              actionLabel: 'Coba lagi',
              onAction: () =>
                  context.read<NotificationBloc>().add(
                      const NotificationRefreshed()),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: state.items.isEmpty
                ? ListView(
              // ListView supaya pull-to-refresh tetap jalan di empty state.
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Message(icon: Icons.notifications_none,
                    text: 'Belum ada notifikasi'),
              ],
            )
                : ListView.separated(
              controller: _scroll,padding: EdgeInsets.only(top: 16),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
              separatorBuilder: (_, _) => widget.height(12),
              itemBuilder: (context, i) {
                if (i >= state.items.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final item = state.items[i];
                return NotificationTile(
                  item: item,
                  onTap: () {
                    if (item.id != null) {
                      context.read<NotificationBloc>().add(
                        NotificationReadRequested(item.id!),
                      );
                    }
                    widget.onItemTap?.call(context, item);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
