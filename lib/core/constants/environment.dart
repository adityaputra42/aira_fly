import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String getApiBaseUrl() {
    String? url = dotenv.env['PRODUCTION_URL'];
    if (dotenv.env['APP_ENV'] == 'dev') {
      url = dotenv.env['DEV_URL'];
    }
    if (dotenv.env['APP_ENV'] == 'staging') {
      url = dotenv.env['STAGING_URL'];
    }
    if (dotenv.env['APP_ENV'] == 'prod') {
      url = dotenv.env['PRODUCTION_URL'];
    }
    return url!;
  }

  static String? getAppEnv() {
    return dotenv.env['APP_ENV'];
  }

  static String? getAppUsernameLogin() {
    return dotenv.env['APP_USERNAME_LOGIN'];
  }

  static String? getAppPasswordLogin() {
    return dotenv.env['APP_PASSWORD_LOGIN'];
  }
}
