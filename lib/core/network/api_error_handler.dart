// ignore_for_file: strict_top_level_inference

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pss_app/core/utils/logger.dart';

import 'error_response.dart';
import 'exceptions.dart';

class ApiErrorHandler {
  static String getMessage(error) {
    String errorDescription = "";
    try {
      if (error is DioException) {
        switch (error.type) {
          case DioExceptionType.cancel:
            errorDescription = "Request cancelled. Please try again later.";
            break;
          case DioExceptionType.connectionTimeout:
            errorDescription =
                "Request timed out. Please check your internet connection and try again.";
            break;
          case DioExceptionType.receiveTimeout:
            errorDescription = "Server response timed out. Please try again later.";
            break;
          case DioExceptionType.badResponse:
            ErrorResponse errorResponse = ErrorResponse.fromJson(error.response!.data);
            errorDescription = errorResponse.message ?? 'Bad Response';
            break;
          case DioExceptionType.sendTimeout:
            errorDescription = "Server did not respond. Please try again later.";
            break;
          case DioExceptionType.badCertificate:
            errorDescription = "Server SSL certificate error. Please contact support.";
            break;
          case DioExceptionType.connectionError:
            errorDescription = "Could not connect to the server. Please try again later.";
            break;
          case DioExceptionType.unknown:
            errorDescription = "Something went wrong. Please try again later.";

            if (error.error is FormatException) {
              errorDescription = "FormatException: Invalid data received. Please contact support.";
            } else if (error.error is TypeError) {
              errorDescription = "TypeError: Invalid data received. Please contact support.";
            } else if (error.error is SocketException) {
              errorDescription =
                  "Unable to connect to the network. Please check your internet connection and try again.";
            }
            break;
          case DioExceptionType.transformTimeout:
            throw UnimplementedError();
        }
      } else if (error is FormatException) {
        errorDescription = "FormatException: Invalid data received. Please contact support.";
      } else if (error is TypeError) {
        errorDescription = "TypeError: Invalid data received. Please contact support.";
      } else if (error is SocketException) {
        errorDescription =
            "Unable to connect to the network. Please check your internet connection and try again.";
      } else if (error is BadResponse) {
        errorDescription = error.message;
      } else {
        errorDescription = "Unexpected error occurred. Please contact support.";
      }
    } catch (e) {
      errorDescription = "Unexpected error occurred. Please contact support.";
    }
    AppLog.log('ERROR ${error.runtimeType}', error);
    return errorDescription;
  }
}
