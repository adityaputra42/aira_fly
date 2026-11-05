import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pss_app/features/AiAssistant/domain/entities/ai_assistant_entity.dart';
import 'package:pss_app/features/AiAssistant/domain/entities/chat_entity.dart';
import 'package:pss_app/features/AiAssistant/presentation/screen/passanger_contact_form_screen.dart';

import '../../../../app/init_dependencies.dart';
import '../../../../app/theme/app_color.dart';
import '../../../../core/utils/top_snackbar_helper.dart';
import '../../../../core/utils/widget_helper.dart';
import '../bloc/ai_assistant_bloc.dart';
import '../widget/chat_drawer.dart';
import '../widget/chat_input.dart';
import '../widget/chat_message_bubble.dart';
import '../widget/chat_typing_indicator.dart';
import 'chat_history_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<AiAssistantBloc>()..add(const AiChatStarted()),
      child: const _ChatView(),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  AiAssistantBloc get _bloc => context.read<AiAssistantBloc>();

  void _sendMessage([String? value]) {
    final text = (value ?? _messageController.text).trim();
    if (text.isEmpty || !_bloc.state.canSendMessage) return;

    _bloc.add(AiMessageSent(text));
    _messageController.clear();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  List<ChatConversationEntity> _conversations(AiAssistantState s) {
    final id = s.conversationId;
    final users = s.messages.where((m) => m.isUser);
    if (id == null || users.isEmpty) return const [];
    return [
      ChatConversationEntity(
        id: id,
        title: users.first.text,
        preview: s.messages.last.text,
        updatedAt: s.messages.last.createdAt,
      ),
    ];
  }

  void _openPassengerForm(AiTurnEntity? turn) {
    final pax = turn?.search?.passengers;
    if (pax == null || pax.total == 0) {
      TopSnackbarHelper.error(
        context,
        message: 'Jumlah penumpang belum diterima dari asisten. Coba kirim ulang pesan.',
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: _bloc,
          child: PassangerContactFormScreen(pax: pax, totalText: passengerFormTotalText(turn!)),
        ),
      ),
    );
  }

  void _openHistory(List<ChatConversationEntity> conversations) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatHistoryScreen(
          conversations: conversations,
          onConversationSelected: (_) => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AiAssistantBloc, AiAssistantState>(
      listenWhen: (a, b) =>
          a.messages.length != b.messages.length || a.status != b.status || a.failure != b.failure,
      listener: (context, state) {
        _scrollToBottom();

        final failure = state.failure;
        if (state.status == AiChatStatus.failure && failure != null) {
          TopSnackbarHelper.error(context, message: failure.message);

          if (failure.conversationGone) {
            context.read<AiAssistantBloc>().add(const AiNewChatRequested());
          }
        }
      },
      builder: (context, state) {
        final conversations = _conversations(state);
        final lastIndex = state.messages.length - 1;

        return Scaffold(
          // endDrawer: ChatDrawer(
          //   conversations: conversations,
          //   activeConversationId: state.conversationId,
          //   onNewChat: () {
          //     Navigator.pop(context);
          //     _bloc.add(const AiNewChatRequested());
          //   },
          //   onViewAll: () => _openHistory(conversations),
          //   onConversationSelected: (_) => Navigator.pop(context),
          // ),
          appBar: WidgetHelper.appBar(
            context: context,
            title: 'AI Assistant',
            color: AppColor.primaryColor,
            titleColor: AppColor.darkText1,
          ),
          body: Column(
            children: [
              if (state.shouldFallbackToForm)
                MaterialBanner(
                  content: const Text('Asisten sedang tidak tersedia. Gunakan pemesanan biasa.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: const Text('Pemesanan biasa'),
                    ),
                  ],
                ),
              Expanded(
                child: state.messages.isEmpty && !state.isBusy
                    ? const Center(child: Text('Start a conversation'))
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                        itemCount: state.messages.length + (state.isBusy ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.messages.length) return const ChatTypingIndicator();

                          final message = state.messages[index];

                          final active = index == lastIndex && !state.isBusy;

                          return ChatMessageBubble(
                            message: message,
                            onSelectFlight: active
                                ? (offer, fare, ret) => _bloc.add(
                                    AiFlightSelected(
                                      departureOptionId: offer.optionId,
                                      fareClassId: fare.fareClassId,
                                      returnOptionId: ret?.optionId,
                                    ),
                                  )
                                : null,
                            onConfirmBooking: active
                                ? () => _bloc.add(const AiBookingConfirmed())
                                : null,
                            onPay: active
                                ? (channel) => _bloc.add(AiPaymentConfirmed(channel))
                                : null,
                            onRefreshPayment: active
                                ? () => _bloc.add(const AiPaymentRefreshed())
                                : null,
                            onFillPassengers: active
                                ? () => _openPassengerForm(message.turn ?? state.turn)
                                : null,
                            onRetry: index == lastIndex && !state.isBusy
                                ? () => state.conversationId == null
                                      ? _bloc.add(const AiChatStarted())
                                      : _bloc.add(const AiRetryRequested())
                                : null,
                          );
                        },
                      ),
              ),
              // finished / failed / cancelled: the server only allows "start new".
              if (state.turn?.can(AiAction.startNew) ?? false)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: state.isBusy ? null : () => _bloc.add(const AiNewChatRequested()),
                      child: const Text('Start new chat'),
                    ),
                  ),
                ),
              // if (state.canSendMessage) ChatSuggestions(onSelected: _sendMessage),
            ],
          ),
          bottomNavigationBar: ChatInput(
            controller: _messageController,
            onSend: _sendMessage,
            onAttachment: () =>
                TopSnackbarHelper.error(context, message: 'Attachment is not available yet.'),
            enabled: state.canSendMessage,
          ),
        );
      },
    );
  }
}
