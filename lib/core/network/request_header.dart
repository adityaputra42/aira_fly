class RequestHeaders {
  Map<String, String> setAuthHeaders() {
    String token = "";
    return {
      "Authorization": "Bearer $token",
      'Accept': "application/json",
      'Content-Type': 'application/json;encoding=utf-8',
    };
  }
}
