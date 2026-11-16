import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/constants/endpoint.dart';
import '../../../../core/network/network.dart';
import '../ai_api_exception.dart';

abstract interface class AiAssistantRemoteDataSources {
  Future<ApiResponse?> startConversation({CancelToken? cancelToken});

  Future<ApiResponse?> getActiveConversation({CancelToken? cancelToken});

  Future<ApiResponse?> getConversationById({
    CancelToken? cancelToken,
    required String id,
  });

  Future<ApiResponse?> cancelConversation({
    CancelToken? cancelToken,
    required String id,
  });

  Future<ApiResponse?> confirmBookingConversation({
    CancelToken? cancelToken,
    required String id,
    required String summaryHash,
  });

  Future<ApiResponse?> confirmPaymentConversation({
    CancelToken? cancelToken,
    required String id,
    required String summaryHash,
    required String channel,
  });

  Future<ApiResponse?> sendMessages({
    CancelToken? cancelToken,
    required String id,
    required String typeInput,
    required String message,
  });

  Future<ApiResponse?> submitPassangerConversations({
    CancelToken? cancelToken,
    required String id,
    required Map<String, dynamic> contactPassenger,
  });

  Future<ApiResponse?> checkPaymentConversation({
    CancelToken? cancelToken,
    required String id,
  });

  Future<ApiResponse?> selectFlightConversations({
    CancelToken? cancelToken,
    required String id,
    required String departurOptionId,
    required int fareClassId,
    String? returnOptionId,
  });
}

class AiAssistantRemoteDataSourcesImpl implements AiAssistantRemoteDataSources {
  final DioClient dio = DioClient();

  @override
  Future<ApiResponse?> startConversation({CancelToken? cancelToken}) async {
    try {
      var response = await dio.post(
        Endpoint.startAiConversation,
        cancelToken: cancelToken,
      );
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      throw AiApiException.from(e);
    }
  }

  @override
  Future<ApiResponse?> cancelConversation({
    CancelToken? cancelToken,
    required String id,
  }) async {
    try {
      var response = await dio.post(

        "${Endpoint.startAiConversation}/$id/${Endpoint.cancelConversation}",
        cancelToken: cancelToken,
      );
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      throw AiApiException.from(e);
    }
  }

  @override
  Future<ApiResponse?> checkPaymentConversation({
    CancelToken? cancelToken,
    required String id,
  }) async {
    try {
      var response = await dio.post(

        "${Endpoint.startAiConversation}/$id/${Endpoint.checkPaymentConversation}",
        cancelToken: cancelToken,
      );
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      throw AiApiException.from(e);
    }
  }

  @override
  Future<ApiResponse?> confirmBookingConversation({
    CancelToken? cancelToken,
    required String id,
    required String summaryHash,
  }) async {
    try {
      var response = await dio.post(
        "${Endpoint.startAiConversation}/$id/${Endpoint.confirmBookingConversation}",
        cancelToken: cancelToken,
        data: {"summary_hash": summaryHash},
      );
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      throw AiApiException.from(e);
    }
  }

  @override
  Future<ApiResponse?> confirmPaymentConversation({
    CancelToken? cancelToken,
    required String id,
    required String summaryHash,
    required String channel,
  }) async {
    try {
      var response = await dio.post(
        "${Endpoint.startAiConversation}/$id/${Endpoint.confirmPaymentConversation}",
        cancelToken: cancelToken,
        data: {"channel": channel, "summary_hash": summaryHash},
      );
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      throw AiApiException.from(e);
    }
  }

  @override
  Future<ApiResponse?> getActiveConversation({CancelToken? cancelToken}) async {
    try {
      var response = await dio.get(
        Endpoint.getActiveConversation,
        cancelToken: cancelToken,
      );
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      throw AiApiException.from(e);
    }
  }

  @override
  Future<ApiResponse?> getConversationById({
    CancelToken? cancelToken,
    required String id,
  }) async {
    try {
      var response = await dio.get(
        "${Endpoint.startAiConversation}/$id",
        cancelToken: cancelToken,
      );
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      throw AiApiException.from(e);
    }
  }

  @override
  Future<ApiResponse?> selectFlightConversations({
    CancelToken? cancelToken,
    required String id,
    required String departurOptionId,
    required int fareClassId,
    String? returnOptionId,
  }) async {
    try {
      var response = await dio.post(
        "${Endpoint.startAiConversation}/$id/${Endpoint.selectFlightConversations}",
        cancelToken: cancelToken,
        data: {
          "departure_option_id": departurOptionId,
          "fare_class_id": fareClassId,
          "return_option_id": returnOptionId,
        },
      );
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      throw AiApiException.from(e);
    }
  }

  @override
  Future<ApiResponse?> sendMessages({
    CancelToken? cancelToken,
    required String id,
    required String typeInput,
    required String message,
  }) async {
    try {
      var response = await dio.post(
        "${Endpoint.startAiConversation}/$id/${Endpoint.sendMessages}",
        cancelToken: cancelToken,
        data: {"input_type": typeInput, "message": message},
      );
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      throw AiApiException.from(e);
    }
  }

  @override
  Future<ApiResponse?> submitPassangerConversations({
    CancelToken? cancelToken,
    required String id,
    required Map<String, dynamic> contactPassenger,
  }) async {
    try {
      var response = await dio.post(
        "${Endpoint.startAiConversation}/$id/${Endpoint.submitPassangerConversations}",
        cancelToken: cancelToken,
        data: contactPassenger,
      );
      log('reponse submit ==> ${response.data}');
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      throw AiApiException.from(e);
    }
  }
}
