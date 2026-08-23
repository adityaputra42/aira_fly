class ErrorResponse {
  String? get code => _code;
  String? _code;

  String? get message => _message;
  String? _message;

  ErrorResponse({
    String? code,
    String? message,
  }) {
    _code = code;
    _message = message;
  }

  ErrorResponse.fromJson(dynamic json) {
    _code = json["responseCode"];
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["responseCode"] = _code;
    map["message"] = _message;
    return map;
  }
}
