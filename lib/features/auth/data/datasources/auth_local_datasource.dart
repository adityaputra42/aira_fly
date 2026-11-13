import '../../../../core/utils/secure_storage_helper.dart';

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
    await SecureStorageHelper.instance.saveAccessToken(token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await SecureStorageHelper.instance.saveRefreshToken(token);
  }

  @override
  Future<String?> getAccessToken() async {
    return SecureStorageHelper.instance.accessToken;
  }

  @override
  Future<String?> getRefreshToken() async {
    return SecureStorageHelper.instance.refreshToken;
  }

  @override
  Future<void> clearTokens() async {
    await SecureStorageHelper.instance.removeAccessToken();
    await SecureStorageHelper.instance.removeRefreshToken();
  }
}
