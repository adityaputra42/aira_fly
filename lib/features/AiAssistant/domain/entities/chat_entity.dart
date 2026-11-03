import 'ai_assistant_entity.dart';

enum ChatMessageType {
  text,
  flightResults,
  bookingDetails,
  paymentConfirmation,
  /// Virtual account / payment status after the user confirmed payment.
  paymentStatus,
  /// Server wants passenger data; collected by a form, never by chat.
  passengerForm,
  error,
}

class ChatMessageEntity {
  final String id;
  final String text;
  final bool isUser;
  final ChatMessageType type;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  /// Server payload behind this bubble (offers, confirmation, payment...).
  final AiTurnEntity? turn;

  const ChatMessageEntity({
    required this.id,
    required this.text,
    required this.isUser,
    this.type = ChatMessageType.text,
    required this.createdAt,
    this.data,
    this.turn,
  });

  List<Object?> get props => [id, text, isUser, type, createdAt, data, turn];
}

class ChatConversationEntity {
  final String id;
  final String title;
  final String preview;
  final DateTime updatedAt;

  const ChatConversationEntity({
    required this.id,
    required this.title,
    required this.preview,
    required this.updatedAt,
  });

  List<Object?> get props => [id, title, preview, updatedAt];
}
