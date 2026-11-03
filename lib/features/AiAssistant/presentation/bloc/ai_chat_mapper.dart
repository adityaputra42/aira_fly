import '../../domain/entities/ai_assistant_entity.dart';
import '../../domain/entities/chat_entity.dart';

/// Turns server payloads into the bubbles the chat UI already knows.
abstract final class AiChatMapper {
  static int _n = 0;
  static String _id(String p) => '$p-${DateTime.now().microsecondsSinceEpoch}-${_n++}';

  static ChatMessageType typeOf(AiTurnEntity t) {
    final c = t.confirmation;
    if (c != null) {
      return c.isPayment ? ChatMessageType.paymentConfirmation : ChatMessageType.bookingDetails;
    }
    if (t.payment != null) return ChatMessageType.paymentStatus;
    if (t.can(AiAction.submitPassengers)) return ChatMessageType.passengerForm;
    final o = t.offers;
    if (o != null && !o.isEmpty) return ChatMessageType.flightResults;
    if (t.state == AiState.failed) return ChatMessageType.error;
    return ChatMessageType.text;
  }

  static bool isStructured(AiTurnEntity t) => typeOf(t) != ChatMessageType.text;

  static ChatMessageEntity fromTurn(AiTurnEntity t) => ChatMessageEntity(
    id: _id('ai'),
    text: t.message,
    isUser: false,
    type: typeOf(t),
    createdAt: DateTime.now(),
    turn: t,
  );

  static ChatMessageEntity user(String text) =>
      ChatMessageEntity(id: _id('me'), text: text, isUser: true, createdAt: DateTime.now());

  static ChatMessageEntity error(String text) => ChatMessageEntity(
    id: _id('err'),
    text: text,
    isUser: false,
    type: ChatMessageType.error,
    createdAt: DateTime.now(),
  );

  static List<ChatMessageEntity> fromConversation(AiConversationEntity c) {
    final list = c.messages
        .map(
          (m) => ChatMessageEntity(
            id: _id('h'),
            text: m.content,
            isUser: m.isUser,
            createdAt: m.createdAt,
          ),
        )
        .toList();

    final turn = c.turn;
    if (list.isEmpty) {
      list.add(fromTurn(turn));
    } else if (isStructured(turn)) {
      final last = list.last;
      if (!last.isUser && last.text == turn.message) {
        list[list.length - 1] = fromTurn(turn);
      } else {
        list.add(fromTurn(turn));
      }
    }
    return list;
  }
}
