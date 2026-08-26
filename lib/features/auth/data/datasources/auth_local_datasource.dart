import 'package:pss_app/core/utils/pref_helper.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveAccessToken(String token);

  Future<void> saveRefreshToken(String token);

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> clearTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final PrefHelper prefHelper;

  const AuthLocalDataSourceImpl(this.prefHelper);

  @override
  Future<void> saveAccessToken(String token) async {
    await prefHelper.saveAccessToken(token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await prefHelper.saveRefreshToken(token);
  }

  @override
  Future<String?> getAccessToken() async {
    return prefHelper.accessToken;
  }

  @override
  Future<String?> getRefreshToken() async {
    return prefHelper.refreshToken;
  }

  @override
  Future<void> clearTokens() async {
    await prefHelper.removeAccessToken();
    await prefHelper.removeRefreshToken();
  }
}
