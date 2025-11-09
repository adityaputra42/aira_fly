class BaseResponse {
  int? statusCode;
  String? body;
  Map<String, String>? headers;

  BaseResponse(this.statusCode, this.body, {this.headers});
}
