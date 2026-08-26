import 'package:pss_app/core/network/network.dart';

import '../../../../core/constants/enpoint.dart';

abstract interface class AuthRemoteDataSource {
  Future<ApiResponse?> signUp({
    required String name,
    required String email,
    required String password,
    required String username,
  });
  Future<ApiResponse?> login({required String email, required String password});
  Future<ApiResponse?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dio = DioClient();

  @override
  Future<ApiResponse?> getCurrentUserData() async {
    try {
      var response = await dio.get(Endpoint.getUser);
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> login({required String email, required String password}) async {
    try {
      var param = {"email": email, "password": password};
      var response = await dio.post(Endpoint.login, data: param);
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }

      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse?> signUp({
    required String name,
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      var param = {"username": username, "full_name": name, "email": email, "password": password};
      var response = await dio.post(Endpoint.register, data: param);
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }

      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }
}
