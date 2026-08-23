import 'dart:developer' as developer;

class AppLog {
  static void log([String tag = "LOGGER", dynamic msg]) {
    developer.log('$msg', name: tag);
    // if (Application.debug) {}
  }

  ///Singleton factory
  static final _instance = AppLog._internal();

  factory AppLog() {
    return _instance;
  }

  AppLog._internal();
}
