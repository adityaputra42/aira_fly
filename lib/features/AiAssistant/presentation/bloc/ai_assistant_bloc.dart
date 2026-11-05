import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/ai_assistant_entity.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/usecases/cancel_ai_conversation.dart';
import '../../domain/usecases/confirm_ai_booking.dart';
import '../../domain/usecases/confirm_ai_payment.dart';
import '../../domain/usecases/get_active_ai_conversation.dart';
import '../../domain/usecases/get_ai_conversation.dart';
import '../../domain/usecases/refresh_ai_payment.dart';
import '../../domain/usecases/select_ai_flight.dart';
import '../../domain/usecases/send_ai_message.dart';
import '../../domain/usecases/start_ai_conversation.dart';
import '../../domain/usecases/submit_ai_passengers.dart';
import 'ai_chat_mapper.dart';

part 'ai_assistant_event.dart';
part 'ai_assistant_state.dart';

class AiAssistantBloc extends Bloc<AiAssistantEvent, AiAssistantState> {
  final StartAiConversation startConversationUseCase;
  final GetActiveAiConversation getActiveConversationUseCase;
  final GetAiConversation getConversationUseCase;
  final SendAiMessage sendMessageUseCase;
  final SelectAiFlight selectFlightUseCase;
  final SubmitAiPassengers submitPassengersUseCase;
  final ConfirmAiBooking confirmBookingUseCase;
  final ConfirmAiPayment confirmPaymentUseCase;
  final RefreshAiPayment refreshPaymentUseCase;
  final CancelAiConversation cancelConversationUseCase;

  AiAssistantBloc({
    required this.startConversationUseCase,
    required this.getActiveConversationUseCase,
    required this.getConversationUseCase,
    required this.sendMessageUseCase,
    required this.selectFlightUseCase,
    required this.submitPassengersUseCase,
    required this.confirmBookingUseCase,
    required this.confirmPaymentUseCase,
    required this.refreshPaymentUseCase,
    required this.cancelConversationUseCase,
  }) : super(const AiAssistantState()) {
    on<AiChatStarted>(_onStarted);
    on<AiMessageSent>(_onMessageSent);
    on<AiRetryRequested>(_onRetry);
    on<AiFlightSelected>(_onFlightSelected);
    on<AiPassengersSubmitted>(_onPassengersSubmitted);
    on<AiBookingConfirmed>(_onBookingConfirmed);
    on<AiPaymentConfirmed>(_onPaymentConfirmed);
    on<AiPaymentRefreshed>(_onPaymentRefreshed);
    on<AiConversationCancelled>(_onCancelled);
    on<AiNewChatRequested>(_onNewChat);
    on<AiConversationOpened>(_onOpened);
  }


  Future<void> _onStarted(AiChatStarted event, Emitter<AiAssistantState> emit) async {
    if (state.conversationId != null && !state.isTerminal) return;
    if (state.isBusy) return;

    emit(state.copyWith(status: AiChatStatus.starting, clearFailure: true));

    final active = await getActiveConversationUseCase(NoParams());
    await active.fold(
      (failure) async => _emitFailure(emit, failure),
      (conversation) async {
        if (conversation != null && !conversation.turn.isTerminal) {
          emit(
            state.copyWith(
              status: AiChatStatus.ready,
              conversationId: conversation.turn.conversationId,
              turn: conversation.turn,
              messages: AiChatMapper.fromConversation(conversation),
              clearFailure: true,
              clearRetry: true,
            ),
          );
        } else {
          await _startNew(emit);
        }
      },
    );
  }

  Future<void> _onOpened(AiConversationOpened event, Emitter<AiAssistantState> emit) async {
    if (state.isBusy) return;
    emit(state.copyWith(status: AiChatStatus.starting, clearFailure: true));

    final result = await getConversationUseCase(GetAiConversationParams(id: event.id));
    result.fold(
      (failure) => _emitFailure(emit, failure),
      (conversation) => emit(
        state.copyWith(
          status: AiChatStatus.ready,
          conversationId: conversation.turn.conversationId,
          turn: conversation.turn,
          messages: AiChatMapper.fromConversation(conversation),
          clearFailure: true,
          clearRetry: true,
        ),
      ),
    );
  }

  Future<void> _onNewChat(AiNewChatRequested event, Emitter<AiAssistantState> emit) async {
    if (state.isBusy) return;

    final id = state.conversationId;
    final turn = state.turn;
    emit(state.copyWith(status: AiChatStatus.starting, clearFailure: true));

    if (id != null && turn != null && !turn.isTerminal && turn.payment == null) {
      await cancelConversationUseCase(CancelAiConversationParams(id: id));
    }

    emit(state.copyWith(clearConversation: true, messages: const [], clearRetry: true));
    await _startNew(emit);
  }

  Future<void> _startNew(Emitter<AiAssistantState> emit) async {
    final result = await startConversationUseCase(NoParams());
    result.fold(
      (failure) => _emitFailure(emit, failure),
      (turn) => emit(
        state.copyWith(
          status: AiChatStatus.ready,
          conversationId: turn.conversationId,
          turn: turn,
          messages: [AiChatMapper.fromTurn(turn)],
          clearFailure: true,
          clearRetry: true,
        ),
      ),
    );
  }

  Future<void> _onMessageSent(AiMessageSent event, Emitter<AiAssistantState> emit) async {
    final text = event.text.trim();
    if (text.isEmpty || !state.canSendMessage) return;

    emit(
      state.copyWith(
        status: AiChatStatus.sending,
        messages: [...state.messages, AiChatMapper.user(text)],
        clearFailure: true,
        retryText: text,
        retryInputType: event.inputType,
      ),
    );
    await _sendMessage(text, event.inputType, emit);
  }

  Future<void> _onRetry(AiRetryRequested event, Emitter<AiAssistantState> emit) async {
    final text = state.retryText;
    if (text == null || state.isBusy || state.conversationId == null) return;

    final msgs = [...state.messages];
    if (msgs.isNotEmpty && msgs.last.type == ChatMessageType.error) msgs.removeLast();

    emit(state.copyWith(status: AiChatStatus.sending, messages: msgs, clearFailure: true));
    await _sendMessage(text, state.retryInputType, emit);
  }

  Future<void> _sendMessage(String text, AiInputType type, Emitter<AiAssistantState> emit) async {
    final result = await sendMessageUseCase(
      SendAiMessageParams(id: state.conversationId!, message: text, inputType: type),
    );
    result.fold(
      (failure) => _emitFailure(emit, failure),
      (turn) => _emitTurn(emit, turn, clearRetry: true),
    );
  }


  Future<void> _onFlightSelected(AiFlightSelected event, Emitter<AiAssistantState> emit) async {
    final id = state.conversationId;
    if (id == null || state.isBusy) return;
    emit(state.copyWith(status: AiChatStatus.sending, clearFailure: true));

    final result = await selectFlightUseCase(
      SelectAiFlightParams(
        id: id,
        departureOptionId: event.departureOptionId,
        fareClassId: event.fareClassId,
        returnOptionId: event.returnOptionId,
      ),
    );
    result.fold((f) => _emitFailure(emit, f), (t) => _emitTurn(emit, t));
  }

  Future<void> _onPassengersSubmitted(
    AiPassengersSubmitted event,
    Emitter<AiAssistantState> emit,
  ) async {
    final id = state.conversationId;
    if (id == null || state.isBusy) return;
    emit(state.copyWith(status: AiChatStatus.sending, clearFailure: true));

    final result = await submitPassengersUseCase(
      SubmitAiPassengersParams(id: id, contact: event.contact, passengers: event.passengers),
    );
    result.fold((f) => _emitFailure(emit, f), (t) => _emitTurn(emit, t));
  }

  Future<void> _onBookingConfirmed(AiBookingConfirmed event, Emitter<AiAssistantState> emit) async {
    final id = state.conversationId;
    final confirmation = state.turn?.confirmation;
    if (id == null || state.isBusy) return;

    if (confirmation == null || !confirmation.isBooking) {
      return _emitFailure(emit, AiFailure('Ringkasan booking sudah tidak berlaku. Muat ulang percakapan.'));
    }
    emit(state.copyWith(status: AiChatStatus.sending, clearFailure: true));

    final result = await confirmBookingUseCase(
      ConfirmAiBookingParams(id: id, summaryHash: confirmation.summaryHash),
    );
    result.fold((f) => _emitFailure(emit, f), (t) => _emitTurn(emit, t));
  }

  Future<void> _onPaymentConfirmed(AiPaymentConfirmed event, Emitter<AiAssistantState> emit) async {
    final id = state.conversationId;
    final confirmation = state.turn?.confirmation;
    if (id == null || state.isBusy) return;

    if (confirmation == null || !confirmation.isPayment) {
      return _emitFailure(emit, AiFailure('Ringkasan pembayaran sudah tidak berlaku. Muat ulang percakapan.'));
    }
    emit(state.copyWith(status: AiChatStatus.sending, clearFailure: true));

    final result = await confirmPaymentUseCase(
      ConfirmAiPaymentParams(
        id: id,
        summaryHash: confirmation.summaryHash,
        channel: event.channel,
      ),
    );
    result.fold((f) => _emitFailure(emit, f), (t) => _emitTurn(emit, t));
  }

  Future<void> _onPaymentRefreshed(AiPaymentRefreshed event, Emitter<AiAssistantState> emit) async {
    final id = state.conversationId;
    if (id == null || state.isBusy) return;
    emit(state.copyWith(status: AiChatStatus.sending, clearFailure: true));

    final result = await refreshPaymentUseCase(RefreshAiPaymentParams(id: id));
    result.fold((f) => _emitFailure(emit, f), (t) => _emitTurn(emit, t, replacePayment: true));
  }

  Future<void> _onCancelled(AiConversationCancelled event, Emitter<AiAssistantState> emit) async {
    final id = state.conversationId;
    if (id == null || state.isBusy) return;
    emit(state.copyWith(status: AiChatStatus.sending, clearFailure: true));

    final result = await cancelConversationUseCase(CancelAiConversationParams(id: id));
    result.fold((f) => _emitFailure(emit, f), (t) => _emitTurn(emit, t));
  }

  // ----------------------------------------------------------------- helpers

  void _emitTurn(
    Emitter<AiAssistantState> emit,
    AiTurnEntity turn, {
    bool replacePayment = false,
    bool clearRetry = false,
  }) {
    final msgs = [...state.messages];
    final bubble = AiChatMapper.fromTurn(turn);

    final idx = replacePayment && turn.payment != null
        ? msgs.lastIndexWhere((m) => m.type == ChatMessageType.paymentStatus)
        : -1;
    if (idx >= 0) {
      msgs[idx] = bubble;
    } else {
      msgs.add(bubble);
    }

    emit(
      state.copyWith(
        status: AiChatStatus.ready,
        conversationId: turn.conversationId,
        turn: turn,
        messages: msgs,
        clearFailure: true,
        clearRetry: clearRetry,
      ),
    );
  }

  void _emitFailure(Emitter<AiAssistantState> emit, Failure failure) {
    final ai = failure is AiFailure ? failure : AiFailure(failure.message);

    final newTurn = ai.turn;
    if (newTurn != null) {
      return _emitTurn(emit, newTurn);
    }

    emit(
      state.copyWith(
        status: AiChatStatus.failure,
        failure: ai,
        messages: [...state.messages, AiChatMapper.error(ai.message)],
      ),
    );
  }
}
