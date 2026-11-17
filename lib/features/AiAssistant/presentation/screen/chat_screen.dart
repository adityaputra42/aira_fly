import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/features/AiAssistant/domain/entities/ai_assistant_entity.dart';
import 'package:pss_app/features/AiAssistant/domain/entities/chat_entity.dart';

import '../../../../app/init_dependencies.dart';
import '../../../../app/theme/theme.dart';
import '../../../../core/common/widget/card_general.dart';
import '../../../../core/utils/top_snackbar_helper.dart';
import '../../../../core/utils/widget_helper.dart';
import '../bloc/ai_assistant_bloc.dart';
import '../voice/ai_voice_controller.dart';
import '../voice/ai_voice_overlay.dart';
import '../voice/ai_voice_ports.dart';
import '../widget/chat_input.dart';
import '../widget/chat_message_bubble.dart';
import '../widget/chat_typing_indicator.dart';
import 'passanger_contact_form_screen.dart';

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

class _ChatViewState extends State<_ChatView> with WidgetsBindingObserver {
  static const _autoSendVoice = true;

  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late final AiVoiceController _voice;
  String? _voiceConversationId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _voice = AiVoiceController(
      input: SttVoiceInput(),
      output: TtsVoiceOutput(),
      onPartial: _showTranscript,
      onFinal: _onVoiceFinal,
      onCancel: _messageController.clear,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) unawaited(_voice.stopAll());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _voice.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  AiAssistantBloc get _bloc => context.read<AiAssistantBloc>();

  void _sendMessage([String? value, bool voice = false]) {
    final text = (value ?? _messageController.text).trim();
    if (text.isEmpty || !_bloc.state.canSendMessage) return;

    _voice.noteSent(voice: voice);
    _bloc.add(
      AiMessageSent(text, inputType: voice ? AiInputType.voiceTranscript : AiInputType.text),
    );
    _messageController.clear();
  }

  void _showTranscript(String text) {
    _messageController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _onVoiceFinal(String text) {
    if (_autoSendVoice && _bloc.state.canSendMessage) {
      _sendMessage(text, true);
    } else {
      _showTranscript(text);
    }
  }

  Future<void> _openPassengerForm(AiTurnEntity? turn) async {
    unawaited(_voice.stopAll()); // never talk over a form
    final search = turn?.search;
    if (turn == null || search == null) {
      TopSnackbarHelper.error(
        context,
        message:
            'Data pencarian tidak tersedia, jumlah penumpang tidak diketahui. Mulai chat baru.',
      );
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: _bloc,
          child: PassangerContactFormScreen(
            pax: search.passengers,
            totalText: passengerFormTotalText(turn),
            firstTravel: search.departureDate,
            lastTravel: search.returnDate ?? search.departureDate,
          ),
        ),
      ),
    );
  }

  Future<void> _onMic() async {
    FocusScope.of(context).unfocus();
    final problem = await _voice.toggleMic();
    if (problem != null && mounted) TopSnackbarHelper.error(context, message: problem);
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AiAssistantBloc, AiAssistantState>(
      listenWhen: (a, b) =>
          a.messages.length != b.messages.length ||
          a.status != b.status ||
          a.failure != b.failure ||
          a.conversationId != b.conversationId,
      listener: (context, state) {
        _scrollToBottom();

        if (state.conversationId != _voiceConversationId) {
          _voiceConversationId = state.conversationId;
          unawaited(_voice.stopAll());
        }

        final last = state.messages.isEmpty ? null : state.messages.last;
        if (last != null && !last.isUser && last.type != ChatMessageType.error && !state.isBusy) {
          final spoken = last.turn?.speakable ?? '';
          unawaited(_voice.onAssistantMessage(spoken.isNotEmpty ? spoken : last.text));
        }

        final failure = state.failure;
        if (state.status == AiChatStatus.failure && failure != null) {
          TopSnackbarHelper.error(context, message: failure.message);

          if (failure.conversationGone) {
            context.read<AiAssistantBloc>().add(const AiNewChatRequested());
          }
        }
      },
      builder: (context, state) {
        final lastIndex = state.messages.length - 1;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: WidgetHelper.appBar(
            context: context,
            title: 'AI Assistant',
            color: AppColor.primaryColor,
            titleColor: AppColor.darkText1,
              icon:
              Tooltip(
                message: _voice.voiceReplies
                    ? 'Suara balasan: aktif'
                    : 'Suara balasan: mati',
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _voice.setVoiceReplies(!_voice.voiceReplies);
                    });
                  },

                  child: CardGeneral(
                    background:  Theme
                        .of(context)
                        .hintColor
                        .withValues(alpha: 0.2),
                    radius: 6,
                    padding: const EdgeInsets.all(6),
                    margin: EdgeInsets.zero,
                    child: Icon(
                      _voice.voiceReplies ? Icons.volume_up_rounded : Icons
                          .volume_off_rounded,
                      size: 20,
                      color: _voice.voiceReplies ? AppColor.darkText1 : Theme
                          .of(context)
                          .hintColor,
                    ),
                  ),
                ),
              )
          ),
          bottomNavigationBar: ListenableBuilder(
            listenable: _voice,
            builder: (context, _) =>
                ChatInput(
                  controller: _messageController,
                  onSend: _sendMessage,
                  onMic: _onMic,
                  listening: _voice.listening,

                  onAttachment: () =>
                      TopSnackbarHelper.error(context,
                          message: 'Attachment is not available yet.'),
                  enabled: state.canSendMessage,
                ),
          ),

          body: Stack(
            children: [
              Column(
                children: [
                  if (state.shouldFallbackToForm)
                    MaterialBanner(
                      content: const Text(
                        'Asisten sedang tidak tersedia. Gunakan pemesanan biasa.',
                        style: AppFont.medium12,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          child: const Text(
                            'Pemesanan biasa', style: AppFont.medium12,),
                        ),
                      ],
                    ),
                  Expanded(
                    child: state.messages.isEmpty && !state.isBusy
                        ? const Center(child: Text(
                      'Start a conversation', style: AppFont.medium12,))
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                            itemCount: state.messages.length + (state.isBusy ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == state.messages.length) {
                                return const ChatTypingIndicator();
                              }

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
                  if (state.turn?.can(AiAction.startNew) ?? false)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          disable: state.isBusy,
                          onPressed: () =>
                              _bloc.add(const AiNewChatRequested()),
                          title: "Start new chat",
                        ),
                      ),
                    ),
                ],
              ),
              Positioned.fill(child: AiVoiceOverlay(controller: _voice)),
            ],
          ),

        );
      },
    );
  }
}
