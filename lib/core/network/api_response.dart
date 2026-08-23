import 'package:dio/dio.dart';

class ApiResponse {
  final int? statusCode;
  final dynamic error;
  String? responseMessage;
  dynamic data;
  dynamic meta;
  dynamic success;

  ApiResponse(this.statusCode, this.error, this.responseMessage, this.data, this.meta, this.success);

  ApiResponse.withError(Response? responseData, dynamic errorValue, dynamic data)
    : statusCode = responseData?.statusCode,
      error = errorValue,
      responseMessage = data['message'],
      success = data['success'],
      data = data['data'];

  ApiResponse.withSuccess(Response responseData, dynamic data)
    : statusCode = responseData.statusCode,
      error = null,
      responseMessage = data['message'],
      data = data['data'],
      success = data['success'],
      meta = data["meta"];
}
