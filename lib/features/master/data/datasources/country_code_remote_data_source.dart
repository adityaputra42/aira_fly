import 'package:pss_app/core/constants/enpoint.dart';
import 'package:pss_app/core/network/network.dart';

abstract interface class CountryCodeRemoteDataSource {
  Future<ApiResponse?> listCountryCodes({String? search});
}

class CountryCodeRemoteDataSourceImpl implements CountryCodeRemoteDataSource {
  final DioClient dio = DioClient();

  @override
  Future<ApiResponse?> listCountryCodes({String? search}) async {
    try {
      var response = await dio.get(
        Endpoint.countryCodes,
        queryParameters: (search != null && search.isNotEmpty) ? {'search': search} : null,
      );
      if (response.data == null) {
        return ApiResponse.withError(response, response.statusMessage, null);
      }
      return ApiResponse.withSuccess(response, response.data);
    } catch (e) {
      return null;
    }
  }
}
