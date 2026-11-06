import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  SpeechToTextService._();

  static final SpeechToTextService instance = SpeechToTextService._();

  final SpeechToText _speech = SpeechToText();

  final ValueNotifier<bool> listeningNotifier = ValueNotifier(false);

  final ValueNotifier<bool> availableNotifier = ValueNotifier(false);

  final ValueNotifier<bool> hasPermissionNotifier = ValueNotifier(false);

  final ValueNotifier<String> recognizedTextNotifier = ValueNotifier('');

  final ValueNotifier<String> errorNotifier = ValueNotifier('');

  final ValueNotifier<double> soundLevelNotifier = ValueNotifier(0.0);

  final ValueNotifier<String> statusNotifier = ValueNotifier('notInitialized');

  final StreamController<SpeechRecognitionResult> _resultController =
      StreamController<SpeechRecognitionResult>.broadcast();

  final StreamController<SpeechRecognitionError> _errorController =
      StreamController<SpeechRecognitionError>.broadcast();

  final StreamController<String> _statusController = StreamController<String>.broadcast();

  final StreamController<double> _soundLevelController = StreamController<double>.broadcast();

  Stream<SpeechRecognitionResult> get results => _resultController.stream;

  Stream<SpeechRecognitionError> get errors => _errorController.stream;

  Stream<String> get statuses => _statusController.stream;

  Stream<double> get soundLevels => _soundLevelController.stream;

  bool _initialized = false;
  bool _initializing = false;
  bool _disposed = false;

  Completer<bool>? _initializeCompleter;

  String _localeId = 'id_ID';

  bool _partialResults = true;
  bool _onDevice = false;
  bool _autoPunctuation = true;

  Duration _listenFor = const Duration(seconds: 60);
  Duration _pauseFor = const Duration(seconds: 3);

  ListenMode _listenMode = ListenMode.dictation;

  bool get isInitialized => _initialized;

  bool get isAvailable => _speech.isAvailable;

  bool get isListening => _speech.isListening;

  Future<bool> hasPermission() async {
    return await _speech.hasPermission;
  }

  String get localeId => _localeId;

  String get recognizedText => recognizedTextNotifier.value;


  Future<bool> initialize({
    bool debugLogging = false,
    Duration finalTimeout = const Duration(seconds: 2),
  }) async {
    if (_disposed) {
      throw StateError('SpeechToTextService has been disposed.');
    }

    if (_initialized) {
      return _speech.isAvailable;
    }

    if (_initializing) {
      return _initializeCompleter!.future;
    }

    _initializing = true;
    _initializeCompleter = Completer<bool>();

    try {
      final available = await _speech.initialize(
        debugLogging: debugLogging,
        finalTimeout: finalTimeout,
        onStatus: _onStatus,
        onError: _onError,
      );

      _initialized = true;

      availableNotifier.value = available;
      hasPermissionNotifier.value = await _speech.hasPermission;

      log('[STT] Initialized: $available');
      log('[STT] Permission: ${_speech.hasPermission}');

      _initializeCompleter!.complete(available);

      return available;
    } catch (e, s) {
      errorNotifier.value = e.toString();

      log('[STT] Initialize error: $e', stackTrace: s);

      if (!_initializeCompleter!.isCompleted) {
        _initializeCompleter!.complete(false);
      }

      return false;
    } finally {
      _initializing = false;
      _initializeCompleter = null;
    }
  }

  Future<bool> startListening({
    String? localeId,
    Duration? listenFor,
    Duration? pauseFor,
    ListenMode? listenMode,
    bool? partialResults,
    bool? onDevice,
    bool? autoPunctuation,
    List<String>? contextualPhrases,
  }) async {
    if (_disposed) return false;

    final available = await initialize();

    if (!available) {
      errorNotifier.value = 'Speech recognition is not available.';
      return false;
    }

    if (_speech.isListening) {
      await _speech.stop();
    }

    recognizedTextNotifier.value = '';
    errorNotifier.value = '';
    soundLevelNotifier.value = 0;

    _localeId = localeId ?? _localeId;
    _listenFor = listenFor ?? _listenFor;
    _pauseFor = pauseFor ?? _pauseFor;
    _listenMode = listenMode ?? _listenMode;

    _partialResults = partialResults ?? _partialResults;
    _onDevice = onDevice ?? _onDevice;
    _autoPunctuation = autoPunctuation ?? _autoPunctuation;

    try {
      await _speech.listen(
        onResult: _onResult,
        onSoundLevelChange: _onSoundLevelChange,
        listenOptions: SpeechListenOptions(
          localeId: _localeId,
          listenFor: _listenFor,
          pauseFor: _pauseFor,
          listenMode: _listenMode,
          partialResults: _partialResults,
          onDevice: _onDevice,
          autoPunctuation: _autoPunctuation,
          cancelOnError: true,
          contextualPhrases: contextualPhrases,
        ),
      );

      listeningNotifier.value = _speech.isListening;

      log('[STT] Start listening: $_localeId');

      return _speech.isListening;
    } catch (e, s) {
      errorNotifier.value = e.toString();

      listeningNotifier.value = false;

      log('[STT] Start error: $e', stackTrace: s);

      return false;
    }
  }

  void _onResult(SpeechRecognitionResult result) {
    if (_disposed) return;

    recognizedTextNotifier.value = result.recognizedWords;

    if (!_resultController.isClosed) {
      _resultController.add(result);
    }

    log(
      '[STT] Result: ${result.recognizedWords} '
      '| final: ${result.finalResult}',
    );
  }

  void _onStatus(String status) {
    if (_disposed) return;

    statusNotifier.value = status;
    listeningNotifier.value = _speech.isListening;

    if (!_statusController.isClosed) {
      _statusController.add(status);
    }

    log('[STT] Status: $status');
  }

  void _onError(SpeechRecognitionError error) {
    if (_disposed) return;

    errorNotifier.value = error.errorMsg;
    listeningNotifier.value = _speech.isListening;

    if (!_errorController.isClosed) {
      _errorController.add(error);
    }

    log(
      '[STT] Error: ${error.errorMsg} '
      '| permanent: ${error.permanent}',
    );
  }

  void _onSoundLevelChange(double level) {
    if (_disposed) return;

    soundLevelNotifier.value = level;

    if (!_soundLevelController.isClosed) {
      _soundLevelController.add(level);
    }
  }

  Future<String> stopListening() async {
    if (!_initialized || !_speech.isListening) {
      return recognizedText;
    }

    try {
      await _speech.stop();

      listeningNotifier.value = false;

      log('[STT] Stopped');

      return recognizedText;
    } catch (e) {
      errorNotifier.value = e.toString();

      log('[STT] Stop error: $e');

      return recognizedText;
    }
  }

  Future<void> cancelListening() async {
    if (!_initialized || !_speech.isListening) return;

    try {
      await _speech.cancel();

      recognizedTextNotifier.value = '';
      listeningNotifier.value = false;

      log('[STT] Cancelled');
    } catch (e) {
      errorNotifier.value = e.toString();

      log('[STT] Cancel error: $e');
    }
  }

  Future<bool> toggleListening({String? localeId}) async {
    if (isListening) {
      await stopListening();
      return false;
    }

    return startListening(localeId: localeId);
  }

  Future<List<LocaleName>> getAvailableLocales() async {
    final available = await initialize();

    if (!available) return [];

    try {
      return await _speech.locales();
    } catch (e) {
      log('[STT] Get locales error: $e');
      return [];
    }
  }

  Future<LocaleName?> getSystemLocale() async {
    final available = await initialize();

    if (!available) return null;

    try {
      return await _speech.systemLocale();
    } catch (e) {
      log('[STT] System locale error: $e');
      return null;
    }
  }

  Future<bool> setLocale(String locale) async {
    if (isListening) {
      await stopListening();
    }

    final locales = await getAvailableLocales();

    final exists = locales.any((item) => item.localeId == locale);

    if (!exists) {
      errorNotifier.value = 'Locale $locale is unavailable.';
      return false;
    }

    _localeId = locale;

    return true;
  }

  void setListenDuration({Duration? listenFor, Duration? pauseFor}) {
    if (listenFor != null) {
      _listenFor = listenFor;
    }

    if (pauseFor != null) {
      _pauseFor = pauseFor;
    }
  }

  void setListenMode(ListenMode mode) {
    _listenMode = mode;
  }

  void setPartialResults(bool enabled) {
    _partialResults = enabled;
  }

  void setOnDevice(bool enabled) {
    _onDevice = enabled;
  }

  void reset() {
    recognizedTextNotifier.value = '';
    errorNotifier.value = '';
    soundLevelNotifier.value = 0;
  }

  Future<void> dispose() async {
    if (_disposed) return;

    await cancelListening();

    _disposed = true;

    await _resultController.close();
    await _errorController.close();
    await _statusController.close();
    await _soundLevelController.close();

    listeningNotifier.dispose();
    availableNotifier.dispose();
    hasPermissionNotifier.dispose();
    recognizedTextNotifier.dispose();
    errorNotifier.dispose();
    soundLevelNotifier.dispose();
    statusNotifier.dispose();

    log('[STT] Disposed');
  }
}
