import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'logging_interceptor.dart';

class DioClient {
  DioClient._() : onForceLogout = null {
    _dio = _createDio();
    _authDio = _createDio();

    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(LoggingInterceptor());
  }

  static final DioClient _instance = DioClient._();

  factory DioClient() => _instance;

  late final Dio _dio;
  late final Dio _authDio;

  final void Function()? onForceLogout;

  Future<String>? _refreshFuture;

  static const String _refreshPath = '';

  static const String _bypassInterceptor = 'X-Bypass-Interceptor';
  static const String _retryHeader = 'X-Retry';

  static Dio _createDio() {
    return Dio(
      BaseOptions(
        baseUrl: '',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        headers: const {'Accept': 'application/json'},
      ),
    );
  }

  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(onRequest: _onRequest, onResponse: _onResponse, onError: _onError);
  }

  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.data is! FormData) {
      options.headers['Content-Type'] = 'application/json; charset=UTF-8';
    }

    // Jika nanti token disimpan di local storage/preferences,
    // inject Authorization di sini.
    //
    // final token = Preferences.getString(Preferences.accessToken);
    //
    // if (token != null && token.isNotEmpty) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }

    handler.next(options);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_isSessionInvalidResponse(response.data)) {
      _forceLogout();
    }

    handler.next(response);
  }

  Future<void> _onError(DioException error, ErrorInterceptorHandler handler) async {
    final statusCode = error.response?.statusCode;

    log(
      'Dio error: '
      '${error.requestOptions.method} '
      '${error.requestOptions.uri} '
      'status=$statusCode',
    );

    if (statusCode != 401) {
      return handler.next(error);
    }

    final requestOptions = error.requestOptions;

    if (_isBypassInterceptor(requestOptions)) {
      return handler.next(error);
    }

    if (_isSessionInvalidResponse(error.response?.data)) {
      _forceLogout();
      return handler.reject(error);
    }

    if (_isRetryRequest(requestOptions)) {
      log('Refresh/retry request failed. Force logout.');

      _forceLogout();
      return handler.reject(error);
    }

    try {
      log('401 detected. Refreshing token...');

      final newToken = await _getValidToken();

      final retryResponse = await _retryRequest(requestOptions, newToken);

      return handler.resolve(retryResponse);
    } catch (e, stackTrace) {
      log('Token refresh failed', error: e, stackTrace: stackTrace);

      _forceLogout();

      return handler.reject(error);
    }
  }

  // ---------------------------------------------------------------------------
  // Token Refresh
  // ---------------------------------------------------------------------------

  Future<String> _getValidToken() {
    final existingRefresh = _refreshFuture;

    if (existingRefresh != null) {
      return existingRefresh;
    }

    final refreshFuture = _handleTokenRefresh();

    _refreshFuture = refreshFuture;

    refreshFuture.whenComplete(() {
      if (identical(_refreshFuture, refreshFuture)) {
        _refreshFuture = null;
      }
    });

    return refreshFuture;
  }

  Future<String> _handleTokenRefresh() async {
    log('Token refresh started');

    try {
      final response = await _authDio.post(
        _refreshPath,
        data: const {},
        options: Options(
          headers: {
            'Authorization': '',
            _retryHeader: true,
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      final data = _extractData(response.data);
      final token = data['token']?.toString();

      if (token == null || token.isEmpty) {
        throw const FormatException('Refresh response did not contain a valid token');
      }

      log('Token refreshed successfully');

      return token;
    } catch (e, stackTrace) {
      log('Token refresh failed', error: e, stackTrace: stackTrace);

      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Retry
  // ---------------------------------------------------------------------------

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions, String newToken) {
    final headers = Map<String, dynamic>.from(requestOptions.headers);

    headers['Authorization'] = 'Bearer $newToken';
    headers[_retryHeader] = true;

    // Jangan override Content-Type untuk FormData.
    if (requestOptions.data is! FormData) {
      headers['Content-Type'] = 'application/json; charset=UTF-8';
    }

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      cancelToken: requestOptions.cancelToken,
      onSendProgress: requestOptions.onSendProgress,
      onReceiveProgress: requestOptions.onReceiveProgress,
      options: Options(
        method: requestOptions.method,
        headers: headers,
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        extra: Map<String, dynamic>.from(requestOptions.extra),
        followRedirects: requestOptions.followRedirects,
        maxRedirects: requestOptions.maxRedirects,
        receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
        validateStatus: requestOptions.validateStatus,
        requestEncoder: requestOptions.requestEncoder,
        responseDecoder: requestOptions.responseDecoder,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  bool _isBypassInterceptor(RequestOptions options) {
    return options.headers[_bypassInterceptor] == true;
  }

  bool _isRetryRequest(RequestOptions options) {
    return options.headers[_retryHeader] == true;
  }

  bool _isSessionInvalidResponse(dynamic responseData) {
    final data = _extractData(responseData);

    final message = data['message']?.toString().toLowerCase() ?? '';
    final errorCode = data['errorCode'];

    return errorCode == 401 && message.contains('session invalid');
  }

  Map<String, dynamic> _extractData(dynamic responseData) {
    final decoded = _safeDecode(responseData);

    final data = decoded['data'];

    if (data is Map<String, dynamic>) {
      return data;
    }

    return decoded;
  }

  Map<String, dynamic> _safeDecode(dynamic data) {
    if (data == null) {
      return {};
    }

    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    if (data is String) {
      try {
        final decoded = jsonDecode(data);

        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
        // Ignore malformed JSON.
      }
    }

    return {};
  }

  void _forceLogout() {
    log('Force logout triggered');

    onForceLogout?.call();
  }

  // ---------------------------------------------------------------------------
  // HTTP Methods
  // ---------------------------------------------------------------------------

  Future<Response<T>> get<T>(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.get<T>(
      uri,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> query<T>(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.query<T>(
      uri,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> post<T>(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.post<T>(
      uri,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> put<T>(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.put<T>(
      uri,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(
      uri,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
