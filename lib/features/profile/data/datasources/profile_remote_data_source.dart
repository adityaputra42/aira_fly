import 'package:pss_app/core/network/network.dart';

import '../../../../core/constants/enpoint.dart';

abstract interface class ProfileRemoteDataSource {
  Future<ApiResponse?> getProfile();

  Future<ApiResponse?> updateProfile({String? fullName, String? email});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dio = DioClient();

  @override
  Future<ApiResponse?> getProfile() async {
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
  Future<ApiResponse?> updateProfile({String? fullName, String? email}) async {
    try {
      var body = <String, dynamic>{};
      if (fullName != null) body['full_name'] = fullName;
      if (email != null) body['email'] = email;

      var response = await dio.put(Endpoint.updateUser, data: body);
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }
}
