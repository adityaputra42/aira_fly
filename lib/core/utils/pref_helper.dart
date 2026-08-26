import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  late final SharedPreferences _pref;

  static PrefHelper instance = PrefHelper();

  Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  // AccessToken
  Future<bool> saveAccessToken(String token) async {
    return await _pref.setString('accessToken', token);
  }

  String get accessToken => _pref.getString('accessToken') ?? '';

  Future<bool> removeAccessToken() async {
    return await _pref.remove('accessToken');
  }

  // RefreshToken
  Future<bool> saveRefreshToken(String token) async {
    return await _pref.setString('RefreshToken', token);
  }

  String get refreshToken => _pref.getString('RefreshToken') ?? '';

  Future<bool> removeRefreshToken() async {
    return await _pref.remove('RefreshToken');
  }

  // First install
  Future<bool> setFirstInstall() async {
    return await _pref.setBool("firstInstall", false);
  }

  bool get isFirstInstall => _pref.getBool("firstInstall") ?? true;
  // First install
  Future<bool> setRememberMe(bool value) async {
    return await _pref.setBool("rememberMe", value);
  }

  bool get isRememberMe => _pref.getBool("rememberMe") ?? false;

  Future<void> setDarkTheme(bool value) async {
    await _pref.setBool("theme", value);
  }

  bool getTheme() {
    var phoneTheme = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = phoneTheme == Brightness.dark;
    return _pref.getBool("theme") ?? isDarkMode;
  }

  // Token
  Future<bool> saveEmail(String email) async {
    return await _pref.setString('email', email);
  }

  String get email => _pref.getString('email') ?? '';

  Future<bool> removeEmail() async {
    return await _pref.remove('email');
  }

  // Token
  Future<bool> savePassword(String password) async {
    return await _pref.setString('password', password);
  }

  String get password => _pref.getString('password') ?? '';

  Future<bool> removePassword() async {
    return await _pref.remove('password');
  }
}
