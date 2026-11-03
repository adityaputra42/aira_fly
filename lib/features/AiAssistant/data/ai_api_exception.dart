import 'package:dio/dio.dart';

import '../../../core/network/api_error_handler.dart';

/// Thrown by the AI datasource instead of swallowing the error.
///
/// Why it exists: the backend puts decisions in error responses -- 409 carries
/// the NEW confirmation summary when a price changed, 429 carries Retry-After,
/// 503/504 carry `fallback_to_form`, 404/410 mean "start a new conversation".
/// Returning `null` on every exception throws all of that away.
class AiApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic data;
  final int? retryAfterSeconds;

  const AiApiException({
    this.statusCode,
    required this.message,
    this.data,
    this.retryAfterSeconds,
  });

  factory AiApiException.from(Object error) {
    if (error is AiApiException) return error;

    if (error is DioException) {
      final res = error.response;
      final body = res?.data;

      String? serverMessage;
      dynamic data;
      if (body is Map) {
        serverMessage = body['message']?.toString();
        data = body['data'];
      }

      return AiApiException(
        statusCode: res?.statusCode,
        message: (serverMessage != null && serverMessage.isNotEmpty)
            ? serverMessage
            : ApiErrorHandler.getMessage(error),
        data: data,
        retryAfterSeconds: int.tryParse(res?.headers.value('retry-after') ?? ''),
      );
    }

    return AiApiException(message: ApiErrorHandler.getMessage(error));
  }

  @override
  String toString() => 'AiApiException($statusCode): $message';
}
