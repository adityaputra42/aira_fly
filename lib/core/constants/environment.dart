import 'package:envied/envied.dart';

part 'environment.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'APP_ENV')
  static const String appEnv = _Env.appEnv;

  @EnviedField(varName: 'DEV_URL')
  static const String devUrl = _Env.devUrl;

  @EnviedField(varName: 'STAGING_URL')
  static const String stagingUrl = _Env.stagingUrl;

  @EnviedField(varName: 'PRODUCTION_URL')
  static const String productionUrl = _Env.productionUrl;

  @EnviedField(varName: 'APP_USERNAME_LOGIN')
  static const String appUsernameLogin = _Env.appUsernameLogin;

  @EnviedField(varName: 'APP_PASSWORD_LOGIN')
  static const String appPasswordLogin = _Env.appPasswordLogin;

  static String getApiBaseUrl() {
    switch (appEnv) {
      case 'dev':
        return devUrl;

      case 'staging':
        return stagingUrl;

      case 'prod':
        return productionUrl;

      default:
        throw StateError('Invalid APP_ENV: $appEnv');
    }
  }
}
