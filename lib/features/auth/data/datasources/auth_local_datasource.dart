import 'package:pss_app/core/utils/pref_helper.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveAccessToken(String token);

  Future<void> saveRefreshToken(String token);

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> clearTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl();

  @override
  Future<void> saveAccessToken(String token) async {
    await PrefHelper.instance.saveAccessToken(token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await PrefHelper.instance.saveRefreshToken(token);
  }

  @override
  Future<String?> getAccessToken() async {
    return PrefHelper.instance.accessToken;
  }

  @override
  Future<String?> getRefreshToken() async {
    return PrefHelper.instance.refreshToken;
  }

  @override
  Future<void> clearTokens() async {
    await PrefHelper.instance.removeAccessToken();
    await PrefHelper.instance.removeRefreshToken();
  }
}
