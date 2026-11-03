part of 'ai_assistant_bloc.dart';

sealed class AiAssistantEvent extends Equatable {
  const AiAssistantEvent();

  @override
  List<Object?> get props => [];
}

/// Screen opened: resume the unfinished conversation or start a new one.
class AiChatStarted extends AiAssistantEvent {
  const AiChatStarted();
}

/// Free text typed or dictated. [inputType] = voiceTranscript for speech.
class AiMessageSent extends AiAssistantEvent {
  final String text;
  final AiInputType inputType;

  const AiMessageSent(this.text, {this.inputType = AiInputType.text});

  @override
  List<Object?> get props => [text, inputType];
}

/// Re-send the message that failed, without a second user bubble.
class AiRetryRequested extends AiAssistantEvent {
  const AiRetryRequested();
}

class AiFlightSelected extends AiAssistantEvent {
  final String departureOptionId;
  final int fareClassId;
  final String? returnOptionId;

  const AiFlightSelected({
    required this.departureOptionId,
    required this.fareClassId,
    this.returnOptionId,
  });

  @override
  List<Object?> get props => [departureOptionId, fareClassId, returnOptionId];
}

class AiPassengersSubmitted extends AiAssistantEvent {
  final AiContactEntity contact;
  final List<AiPassengerEntity> passengers;

  const AiPassengersSubmitted({required this.contact, required this.passengers});

  @override
  List<Object?> get props => [contact, passengers];
}

/// Uses the summary_hash of the CURRENT confirmation in state.
class AiBookingConfirmed extends AiAssistantEvent {
  const AiBookingConfirmed();
}

/// Uses the summary_hash of the CURRENT confirmation in state.
class AiPaymentConfirmed extends AiAssistantEvent {
  final String channel;

  const AiPaymentConfirmed(this.channel);

  @override
  List<Object?> get props => [channel];
}

class AiPaymentRefreshed extends AiAssistantEvent {
  const AiPaymentRefreshed();
}

class AiConversationCancelled extends AiAssistantEvent {
  const AiConversationCancelled();
}

/// Drop the current conversation (cancelling it if still allowed) and start over.
class AiNewChatRequested extends AiAssistantEvent {
  const AiNewChatRequested();
}

/// Load a specific conversation by id (e.g. from a history list).
class AiConversationOpened extends AiAssistantEvent {
  final String id;

  const AiConversationOpened(this.id);

  @override
  List<Object?> get props => [id];
}
