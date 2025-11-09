import 'dart:convert';
import 'dart:developer' as dev;

import 'package:http/http.dart' as http;

import 'base_response.dart';

class ApiClient {
  final String baseUrl = "";
  final String appVersion = "";
  Map<String, String>? headers;

  Future<BaseResponse> get(String url) async {
    BaseResponse responseJson;
    try {
      dev.log("=======================REQUEST===========================");
      dev.log("Method GET => ${baseUrl + appVersion + url}");
      dev.log("Header => $headers");
      final response = await http.get(
        Uri.parse(baseUrl + appVersion + url),
        headers: headers,
      );
      dev.log("=======================RESPONSE===========================");
      dev.log("Status code => ${response.statusCode}");
      dev.log(response.body);
      dev.log("==========================================================");
      responseJson = BaseResponse(
        response.statusCode,
        response.body,
        headers: response.headers,
      );
      return responseJson;
    } catch (error) {
      dev.log("=======================Error===========================");
      dev.log("Error => $error");
      dev.log("==========================================================");
      throw Exception(error.toString());
    }
  }

  Future<BaseResponse> post(String url, dynamic body) async {
    BaseResponse responseJson;
    try {
      dev.log("=======================REQUEST===========================");
      dev.log("Method Post => ${baseUrl + appVersion + url}");
      dev.log("Payload Body => $body");
      dev.log("Header => $headers");
      final response = await http.post(
        Uri.parse(baseUrl + appVersion + url),
        body: jsonEncode(body),
        headers: headers,
      );
      dev.log("=======================RESPONSE===========================");
      dev.log("Status code => ${response.statusCode}");
      dev.log(response.body);
      dev.log("==========================================================");
      responseJson = BaseResponse(
        response.statusCode,
        response.body,
        headers: response.headers,
      );
      return responseJson;
    } catch (error) {
      dev.log("=======================Error===========================");
      dev.log("Error => $error");
      dev.log("==========================================================");
      throw Exception(error.toString());
    }
  }

  Future<BaseResponse> patch(String url, dynamic body) async {
    BaseResponse responseJson;
    try {
      dev.log("=======================REQUEST===========================");
      dev.log("Method Patch => ${baseUrl + appVersion + url}");
      dev.log("Payload Body => $body");
      dev.log("Header => $headers");
      final response = await http.patch(
        Uri.parse(baseUrl + appVersion + url),
        body: jsonEncode(body),
        headers: headers,
      );
      dev.log("=======================RESPONSE===========================");
      dev.log("Status code => ${response.statusCode}");
      dev.log(response.body);
      dev.log("==========================================================");
      responseJson = BaseResponse(
        response.statusCode,
        response.body,
        headers: response.headers,
      );
      return responseJson;
    } catch (error) {
      dev.log("=======================Error===========================");
      dev.log("Error => $error");
      dev.log("==========================================================");
      throw Exception(error.toString());
    }
  }

  Future<BaseResponse> put(String url, dynamic body) async {
    BaseResponse responseJson;
    try {
      dev.log("=======================REQUEST===========================");
      dev.log("Method Put => ${baseUrl + appVersion + url}");
      dev.log("Payload Body => $body");
      dev.log("Header => $headers");
      final response = await http.put(
        Uri.parse(baseUrl + appVersion + url),
        body: jsonEncode(body),
        headers: headers,
      );
      dev.log("=======================RESPONSE===========================");
      dev.log("Status code => ${response.statusCode}");
      dev.log(response.body);
      dev.log("==========================================================");
      responseJson = BaseResponse(
        response.statusCode,
        response.body,
        headers: response.headers,
      );
      return responseJson;
    } catch (error) {
      dev.log("=======================Error===========================");
      dev.log("Error => $error");
      dev.log("==========================================================");
      throw Exception(error.toString());
    }
  }

  Future<BaseResponse> delete(String url) async {
    BaseResponse responseJson;
    try {
      dev.log("=======================REQUEST===========================");
      dev.log("Method Delete => ${baseUrl + appVersion + url}");
      dev.log("Header => $headers");
      final response = await http.delete(
        Uri.parse(baseUrl + appVersion + url),
        headers: headers,
      );
      dev.log("=======================RESPONSE===========================");
      dev.log("Status code => ${response.statusCode}");
      dev.log(response.body);
      dev.log("==========================================================");
      responseJson = BaseResponse(
        response.statusCode,
        response.body,
        headers: response.headers,
      );
      return responseJson;
    } catch (error) {
      dev.log("=======================Error===========================");
      dev.log("Error => $error");
      dev.log("==========================================================");
      throw Exception(error.toString());
    }
  }

  Future<BaseResponse> deleteWithBody(String url, dynamic body) async {
    BaseResponse responseJson;
    try {
      dev.log("=======================REQUEST===========================");
      dev.log("Method Delete => ${baseUrl + appVersion + url}");
      dev.log("Header => $headers");
      final response = await http.delete(
        Uri.parse(baseUrl + appVersion + url),
        headers: headers,
        body: body,
      );
      dev.log("=======================RESPONSE===========================");
      dev.log("Status code => ${response.statusCode}");
      dev.log(response.body);
      dev.log("==========================================================");
      responseJson = BaseResponse(
        response.statusCode,
        response.body,
        headers: response.headers,
      );
      return responseJson;
    } catch (error) {
      dev.log("=======================Error===========================");
      dev.log("Error => $error");
      dev.log("==========================================================");
      throw Exception(error.toString());
    }
  }

  Future<BaseResponse> multiPart(http.MultipartRequest request) async {
    BaseResponse responseJson;
    try {
      final response = await request.send();
      final res = await http.Response.fromStream(response);
      dev.log("=======================RESPONSE===========================");
      dev.log("Status code => ${response.statusCode}");
      dev.log(res.body);
      dev.log("==========================================================");
      responseJson = BaseResponse(
        res.statusCode,
        res.body,
        headers: res.headers,
      );
      return responseJson;
    } catch (error) {
      dev.log("=======================Error===========================");
      dev.log("Error => $error");
      dev.log("==========================================================");
      throw Exception(error.toString());
    }
  }
}
