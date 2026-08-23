import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pss_app/core/utils/logger.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    AppLog.log("${options.method} REQUEST ====================================", '');
    AppLog.log("HEADER =>", options.headers);
    AppLog.log("URL", options.uri);
    if (options.data is FormData) {
      final formData = options.data as FormData;

      AppLog.log('FormData Fields:');
      for (final field in formData.fields) {
        AppLog.log('${field.key}: ${field.value}');
      }

      AppLog.log('FormData Files:');
      for (final file in formData.files) {
        AppLog.log(
          '${file.key}: ${file.value.filename} '
          '(${file.value.contentType})',
        );
      }
    } else {
      if (options.method == 'GET') {
        AppLog.log("PARAMS", options.queryParameters);
      } else {
        AppLog.log("DATA", jsonEncode(options.data));
      }
    }

    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    AppLog.log(
      "${response.requestOptions.method} RESPONSE ====================================",
      '',
    );
    AppLog.log("${response.statusCode} URL", response.realUri);
    AppLog.log("DATA", response.data);

    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    AppLog.log("ERROR ====================================", '');
    AppLog.log("${err.response?.statusCode} URL", err.requestOptions.uri);

    return super.onError(err, handler);
  }

  static final LoggingInterceptor _instance = LoggingInterceptor._internal();

  factory LoggingInterceptor() {
    return _instance;
  }

  LoggingInterceptor._internal();
}
