part of 'ai_assistant_bloc.dart';

enum AiChatStatus {
  /// Nothing loaded yet.
  initial,

  /// Starting / resuming / loading a conversation.
  starting,

  /// Idle, waiting for the user.
  ready,

  /// A request is in flight (show the typing indicator, block input).
  sending,

  /// Last request failed; see [AiAssistantState.failure].
  failure,
}

class AiAssistantState extends Equatable {
  final AiChatStatus status;
  final String? conversationId;

  /// Latest server turn. Drives which buttons are allowed and which
  /// summary_hash is valid.
  final AiTurnEntity? turn;
  final List<ChatMessageEntity> messages;
  final AiFailure? failure;

  /// What to re-send on retry.
  final String? retryText;
  final AiInputType retryInputType;

  const AiAssistantState({
    this.status = AiChatStatus.initial,
    this.conversationId,
    this.turn,
    this.messages = const [],
    this.failure,
    this.retryText,
    this.retryInputType = AiInputType.text,
  });

  bool get isBusy => status == AiChatStatus.starting || status == AiChatStatus.sending;
  bool get isTyping => status == AiChatStatus.sending;

  /// Free text allowed? (false during the passenger form, confirmations, ...)
  bool get canSendMessage =>
      !isBusy && conversationId != null && (turn?.can(AiAction.sendMessage) ?? false);

  bool get isTerminal => turn?.isTerminal ?? false;

  /// Server told us to give up on the assistant.
  bool get shouldFallbackToForm => failure?.fallbackToForm == true || turn?.fallbackToForm == true;

  AiAssistantState copyWith({
    AiChatStatus? status,
    String? conversationId,
    AiTurnEntity? turn,
    List<ChatMessageEntity>? messages,
    AiFailure? failure,
    bool clearFailure = false,
    String? retryText,
    AiInputType? retryInputType,
    bool clearRetry = false,
    bool clearConversation = false,
  }) {
    return AiAssistantState(
      status: status ?? this.status,
      conversationId: clearConversation ? null : (conversationId ?? this.conversationId),
      turn: clearConversation ? null : (turn ?? this.turn),
      messages: messages ?? this.messages,
      failure: clearFailure ? null : (failure ?? this.failure),
      retryText: clearRetry ? null : (retryText ?? this.retryText),
      retryInputType: clearRetry ? AiInputType.text : (retryInputType ?? this.retryInputType),
    );
  }

  @override
  List<Object?> get props => [status, conversationId, turn, messages, failure, retryText];
}
