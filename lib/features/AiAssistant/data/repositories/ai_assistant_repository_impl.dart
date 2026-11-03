import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/utils/connection_checker.dart';
import '../../domain/entities/ai_assistant_entity.dart';
import '../../domain/repository/ai_assistant_repository.dart';
import '../ai_api_exception.dart';
import '../datasources/ai_assistant_remote_data_sources.dart';
import '../models/ai_assistant_model.dart';

class AiAssistantRepositoryImpl implements AiAssistantRepository {
  final AiAssistantRemoteDataSources remoteDataSource;
  final ConnectionChecker connectionChecker;

  const AiAssistantRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  // ------------------------------------------------------------ conversation

  @override
  Future<Either<Failure, AiTurnEntity>> startConversation() {
    return _turn(() => remoteDataSource.startConversation(), 'Gagal memulai percakapan');
  }

  @override
  Future<Either<Failure, AiConversationEntity?>> getActiveConversation() async {
    final result = await _run<AiConversationEntity?>(
      () => remoteDataSource.getActiveConversation(),
      (json) => AiConversationModel.fromJson(json),
      'Gagal memuat percakapan',
    );
    // 404 = nothing to resume. That is a normal outcome, not an error.
    return result.fold<Either<Failure, AiConversationEntity?>>((f) {
      if (f is AiFailure && f.statusCode == 404) return right(null);
      return left(f);
    }, (v) => right(v));
  }

  @override
  Future<Either<Failure, AiConversationEntity>> getConversation(String id) {
    return _run(
      () => remoteDataSource.getConversationById(id: id),
      (json) => AiConversationModel.fromJson(json),
      'Gagal memuat percakapan',
    );
  }

  // ------------------------------------------------------------------ turns

  @override
  Future<Either<Failure, AiTurnEntity>> sendMessage({
    required String id,
    required String message,
    AiInputType inputType = AiInputType.text,
  }) {
    return _turn(
      () => remoteDataSource.sendMessages(id: id, typeInput: inputType.wire, message: message),
      'Gagal mengirim pesan',
    );
  }

  @override
  Future<Either<Failure, AiTurnEntity>> selectFlight({
    required String id,
    required String departureOptionId,
    required int fareClassId,
    String? returnOptionId,
  }) {
    return _turn(
      () => remoteDataSource.selectFlightConversations(
        id: id,
        departurOptionId: departureOptionId,
        fareClassId: fareClassId,
        returnOptionId: returnOptionId,
      ),
      'Gagal memilih penerbangan',
    );
  }

  @override
  Future<Either<Failure, AiTurnEntity>> submitPassengers({
    required String id,
    required AiContactEntity contact,
    required List<AiPassengerEntity> passengers,
  }) {
    return _turn(
      () => remoteDataSource.submitPassangerConversations(
        id: id,
        contactPassenger: AiPassengerRequest.body(contact: contact, passengers: passengers),
      ),
      'Gagal mengirim data penumpang',
    );
  }

  @override
  Future<Either<Failure, AiTurnEntity>> confirmBooking({
    required String id,
    required String summaryHash,
  }) {
    return _turn(
      () => remoteDataSource.confirmBookingConversation(id: id, summaryHash: summaryHash),
      'Gagal mengonfirmasi booking',
    );
  }

  @override
  Future<Either<Failure, AiTurnEntity>> confirmPayment({
    required String id,
    required String summaryHash,
    required String channel,
  }) {
    return _turn(
      () => remoteDataSource.confirmPaymentConversation(
        id: id,
        summaryHash: summaryHash,
        channel: channel,
      ),
      'Gagal membuat pembayaran',
    );
  }

  @override
  Future<Either<Failure, AiTurnEntity>> refreshPayment(String id) {
    return _turn(() => remoteDataSource.checkPaymentConversation(id: id), 'Gagal memeriksa pembayaran');
  }

  @override
  Future<Either<Failure, AiTurnEntity>> cancelConversation(String id) {
    return _turn(() => remoteDataSource.cancelConversation(id: id), 'Gagal membatalkan percakapan');
  }

  // ---------------------------------------------------------------- helpers

  Future<Either<Failure, AiTurnEntity>> _turn(
    Future<ApiResponse?> Function() request,
    String errorMessage,
  ) {
    return _run(request, (json) => AiTurnModel.fromJson(json), errorMessage);
  }

  Future<Either<Failure, T>> _run<T>(
    Future<ApiResponse?> Function() request,
    T Function(Map<String, dynamic> json) parse,
    String errorMessage,
  ) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(AiFailure('Tidak ada koneksi internet', retryable: true));
      }

      final response = await request();
      final data = response?.data;
      if (data is! Map) {
        return left(AiFailure(errorMessage));
      }

      return right(parse(Map<String, dynamic>.from(data)));
    } on AiApiException catch (e) {
      return left(_toFailure(e));
    } catch (_) {
      // Do not leak raw exception text (TypeError etc.) to the chat.
      return left(AiFailure(errorMessage));
    }
  }

  AiFailure _toFailure(AiApiException e) {
    final status = e.statusCode;
    final data = e.data;
    final map = data is Map ? data : const {};

    return AiFailure(
      e.message,
      statusCode: status,
      retryAfterSeconds: e.retryAfterSeconds,
      retryable: map['retryable'] == true || status == 429,
      fallbackToForm: map['fallback_to_form'] == true,
      conversationGone: status == 404 || status == 410,
      // 409 on a confirmation carries the NEW summary (e.g. price changed).
      turn: AiTurnModel.looksLikeTurn(data)
          ? AiTurnModel.fromJson(Map<String, dynamic>.from(data as Map))
          : null,
    );
  }
}
