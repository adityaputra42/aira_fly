import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  SecureStorageHelper._();

  static final SecureStorageHelper instance = SecureStorageHelper._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage(aOptions: AndroidOptions());

  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'RefreshToken';
  static const String _firstInstallKey = 'firstInstall';
  static const String _rememberMeKey = 'rememberMe';
  static const String _themeKey = 'theme';
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';

  Future<void> init() async {}

  Future<bool> saveAccessToken(String token) async {
    try {
      await _storage.write(key: _accessTokenKey, value: token);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String> get accessToken async {
    return await _storage.read(key: _accessTokenKey) ?? '';
  }

  Future<bool> removeAccessToken() async {
    try {
      await _storage.delete(key: _accessTokenKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String> get refreshToken async {
    return await _storage.read(key: _refreshTokenKey) ?? '';
  }

  Future<bool> removeRefreshToken() async {
    try {
      await _storage.delete(key: _refreshTokenKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setFirstInstall() async {
    try {
      await _storage.write(key: _firstInstallKey, value: 'false');
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> get isFirstInstall async {
    final value = await _storage.read(key: _firstInstallKey);

    return value == null || value == 'true';
  }

  Future<bool> setRememberMe(bool value) async {
    try {
      await _storage.write(key: _rememberMeKey, value: value.toString());
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> get isRememberMe async {
    final value = await _storage.read(key: _rememberMeKey);

    return value == 'true';
  }

  Future<void> setDarkTheme(bool value) async {
    await _storage.write(key: _themeKey, value: value.toString());
  }

  Future<bool> getTheme() async {
    final phoneTheme = SchedulerBinding.instance.platformDispatcher.platformBrightness;

    final isDarkMode = phoneTheme == Brightness.dark;

    final savedTheme = await _storage.read(key: _themeKey);

    return savedTheme == null ? isDarkMode : savedTheme == 'true';
  }

  Future<bool> saveEmail(String email) async {
    try {
      await _storage.write(key: _emailKey, value: email);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String> get email async {
    return await _storage.read(key: _emailKey) ?? '';
  }

  Future<bool> removeEmail() async {
    try {
      await _storage.delete(key: _emailKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> savePassword(String password) async {
    try {
      await _storage.write(key: _passwordKey, value: password);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String> get password async {
    return await _storage.read(key: _passwordKey) ?? '';
  }

  Future<bool> removePassword() async {
    try {
      await _storage.delete(key: _passwordKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> clearAuthenticationData() async {
    await _storage.deleteAll();
  }
}
