import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsStatus {
  idle,
  speaking,
  paused,
  stopped,
  error,
}

class TtsService {
  TtsService._();

  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();

  // --------------------------------------------------
  // STATE
  // --------------------------------------------------

  final ValueNotifier<TtsStatus> statusNotifier =
  ValueNotifier(TtsStatus.idle);

  final ValueNotifier<bool> speakingNotifier =
  ValueNotifier(false);

  final ValueNotifier<bool> pausedNotifier =
  ValueNotifier(false);

  final ValueNotifier<String> errorNotifier =
  ValueNotifier('');

  final ValueNotifier<String> currentTextNotifier =
  ValueNotifier('');

  final ValueNotifier<String> currentWordNotifier =
  ValueNotifier('');

  final ValueNotifier<int> progressNotifier =
  ValueNotifier(0);

  // --------------------------------------------------
  // CONFIGURATION
  // --------------------------------------------------

  String language = 'id-ID';

  double speechRate = 0.45;
  double pitch = 1.0;
  double volume = 1.0;

  Map<String, String>? selectedVoice;

  // --------------------------------------------------
  // CALLBACKS
  // --------------------------------------------------

  VoidCallback? onStartSpeaking;
  VoidCallback? onFinishSpeaking;
  VoidCallback? onPauseSpeaking;
  VoidCallback? onContinueSpeaking;
  VoidCallback? onCancelSpeaking;

  ValueChanged<String>? onError;

  void Function(
      String text,
      int startOffset,
      int endOffset,
      String word,
      )? onProgress;

  // --------------------------------------------------
  // INTERNAL
  // --------------------------------------------------

  bool _initialized = false;
  bool _initializing = false;
  bool _disposed = false;

  Completer<void>? _initializeCompleter;

  Future<void> _queue = Future.value();

  int _generation = 0;

  String _activeText = '';

  int _currentOffset = 0;

  bool _isPaused = false;

  // --------------------------------------------------
  // GETTERS
  // --------------------------------------------------

  bool get isInitialized => _initialized;

  bool get isSpeaking =>
      statusNotifier.value == TtsStatus.speaking;

  bool get isPaused => _isPaused;

  bool get isBusy =>
      isSpeaking || isPaused;

  // --------------------------------------------------
  // INITIALIZE
  // --------------------------------------------------

  Future<void> init() async {
    if (_disposed) {
      throw StateError('TtsService has been disposed.');
    }

    if (_initialized) return;

    if (_initializing) {
      return _initializeCompleter!.future;
    }

    _initializing = true;
    _initializeCompleter = Completer<void>();

    try {
      // Wait until speech finishes.
      await _tts.awaitSpeakCompletion(true);

      // Default configuration.
      await _tts.setLanguage(language);
      await _tts.setSpeechRate(speechRate);
      await _tts.setPitch(pitch);
      await _tts.setVolume(volume);

      // iOS configuration.
      if (Platform.isIOS) {
        await _tts.setSharedInstance(true);

        await _tts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          ],
          IosTextToSpeechAudioMode.spokenAudio,
        );
      }

      _registerHandlers();

      _initialized = true;

      log('[TTS] Initialized successfully');

      _initializeCompleter!.complete();
    } catch (e, s) {
      errorNotifier.value = e.toString();

      log(
        '[TTS] Initialization error: $e',
        stackTrace: s,
      );

      if (!_initializeCompleter!.isCompleted) {
        _initializeCompleter!.completeError(e, s);
      }

      rethrow;
    } finally {
      _initializing = false;
      _initializeCompleter = null;
    }
  }

  // --------------------------------------------------
  // HANDLERS
  // --------------------------------------------------

  void _registerHandlers() {
    _tts.setStartHandler(() {
      if (_disposed) return;

      statusNotifier.value = TtsStatus.speaking;
      speakingNotifier.value = true;
      pausedNotifier.value = false;
      _isPaused = false;

      onStartSpeaking?.call();

      log('[TTS] Started');
    });

    _tts.setCompletionHandler(() {
      if (_disposed) return;

      statusNotifier.value = TtsStatus.idle;
      speakingNotifier.value = false;
      pausedNotifier.value = false;

      _isPaused = false;
      _currentOffset = 0;

      onFinishSpeaking?.call();

      log('[TTS] Completed');
    });

    _tts.setPauseHandler(() {
      if (_disposed) return;

      statusNotifier.value = TtsStatus.paused;
      speakingNotifier.value = false;
      pausedNotifier.value = true;

      _isPaused = true;

      onPauseSpeaking?.call();

      log('[TTS] Paused');
    });

    _tts.setContinueHandler(() {
      if (_disposed) return;

      statusNotifier.value = TtsStatus.speaking;
      speakingNotifier.value = true;
      pausedNotifier.value = false;

      _isPaused = false;

      onContinueSpeaking?.call();

      log('[TTS] Continued');
    });

    _tts.setCancelHandler(() {
      if (_disposed) return;

      statusNotifier.value = TtsStatus.stopped;
      speakingNotifier.value = false;
      pausedNotifier.value = false;

      _isPaused = false;

      onCancelSpeaking?.call();

      log('[TTS] Cancelled');
    });

    _tts.setErrorHandler((message) {
      if (_disposed) return;

      errorNotifier.value = message;

      statusNotifier.value = TtsStatus.error;
      speakingNotifier.value = false;
      pausedNotifier.value = false;

      _isPaused = false;

      onError?.call(message);

      log('[TTS] Error: $message');
    });

    _tts.setProgressHandler((
        String text,
        int startOffset,
        int endOffset,
        String word,
        ) {
      if (_disposed) return;

      _activeText = text;

      _currentOffset = endOffset.clamp(0, text.length);

      currentWordNotifier.value = word;

      currentTextNotifier.value = text;

      progressNotifier.value = text.isEmpty
          ? 0
          : ((_currentOffset / text.length) * 100)
          .round()
          .clamp(0, 100);

      onProgress?.call(
        text,
        startOffset,
        endOffset,
        word,
      );
    });
  }

  // --------------------------------------------------
  // SPEAK
  // --------------------------------------------------

  Future<void> speak(
      String text, {
        bool flush = false,
      }) async {
    if (_disposed || text.trim().isEmpty) return;

    if (flush) {
      await stop();
    }

    final generation = _generation;

    _queue = _queue.catchError((_) {}).then((_) async {
      if (generation != _generation || _disposed) return;

      try {
        await init();

        if (generation != _generation || _disposed) return;

        await _speakNow(text.trim(), generation);
      } catch (e, s) {
        log(
          '[TTS] Speak error: $e',
          stackTrace: s,
        );
      }
    });

    await _queue;
  }

  Future<void> _speakNow(
      String text,
      int generation,
      ) async {
    if (generation != _generation || _disposed) return;

    _activeText = text;
    _currentOffset = 0;

    currentTextNotifier.value = text;
    currentWordNotifier.value = '';
    progressNotifier.value = 0;

    errorNotifier.value = '';

    try {
      log('[TTS] Speaking: $text');

      await _tts.speak(text);
    } catch (e, s) {
      errorNotifier.value = e.toString();

      statusNotifier.value = TtsStatus.error;
      speakingNotifier.value = false;

      log(
        '[TTS] Playback error: $e',
        stackTrace: s,
      );
    }
  }

  // --------------------------------------------------
  // SPEAK ALL
  // --------------------------------------------------

  Future<void> speakAll(
      List<String> texts, {
        bool flush = false,
      }) async {
    if (_disposed) return;

    if (flush) {
      await stop();
    }

    final generation = _generation;

    _queue = _queue.catchError((_) {}).then((_) async {
      await init();

      for (final text in texts) {
        if (generation != _generation || _disposed) break;

        if (text.trim().isEmpty) continue;

        await _speakNow(text.trim(), generation);
      }
    });

    await _queue;
  }

  // --------------------------------------------------
  // PAUSE
  // --------------------------------------------------

  Future<void> pause() async {
    if (!_initialized || !isSpeaking) return;

    try {
      await _tts.pause();

      log('[TTS] Pause requested');
    } catch (e) {
      log('[TTS] Pause error: $e');
    }
  }

  // --------------------------------------------------
  // RESUME
  // --------------------------------------------------

  Future<void> resume() async {
    if (!_initialized || !_isPaused || _disposed) return;

    try {
      final text = _activeText;

      if (text.isEmpty) return;

      final offset = _currentOffset.clamp(0, text.length);

      final remainingText = text.substring(offset).trimLeft();

      if (remainingText.isEmpty) {
        _isPaused = false;
        pausedNotifier.value = false;
        statusNotifier.value = TtsStatus.idle;
        return;
      }

      _isPaused = false;

      pausedNotifier.value = false;

      await _tts.speak(remainingText);

      log('[TTS] Resumed');
    } catch (e) {
      errorNotifier.value = e.toString();

      log('[TTS] Resume error: $e');
    }
  }


  Future<void> stop() async {
    _generation++;

    try {
      if (_initialized) {
        await _tts.stop();
      }

      _isPaused = false;

      statusNotifier.value = TtsStatus.stopped;
      speakingNotifier.value = false;
      pausedNotifier.value = false;

      progressNotifier.value = 0;

      _currentOffset = 0;
      _activeText = '';

      log('[TTS] Stopped');
    } catch (e) {
      log('[TTS] Stop error: $e');
    }
  }


  Future<List<dynamic>> getAvailableLanguages() async {
    await init();

    try {
      final result = await _tts.getLanguages;

      return result is List ? result : [];
    } catch (e) {
      log('[TTS] Get languages error: $e');
      return [];
    }
  }

  Future<bool> isLanguageAvailable(String locale) async {
    await init();

    try {
      final result = await _tts.isLanguageAvailable(locale);

      return result == true || result == 1;
    } catch (e) {
      log('[TTS] Language check error: $e');
      return false;
    }
  }

  Future<bool> setLanguage(String locale) async {
    await init();

    final available = await isLanguageAvailable(locale);

    if (!available) {
      errorNotifier.value = 'Language $locale is unavailable.';
      return false;
    }

    try {
      final result = await _tts.setLanguage(locale);

      language = locale;

      return result == 1 || result == true;
    } catch (e) {
      errorNotifier.value = e.toString();
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableVoices() async {
    await init();

    try {
      final result = await _tts.getVoices;

      if (result is! List) return [];

      return result
          .whereType<Map>()
          .map((voice) => Map<String, dynamic>.from(voice))
          .toList();
    } catch (e) {
      log('[TTS] Get voices error: $e');
      return [];
    }
  }

  Future<bool> setVoice(
      Map<String, String> voice,
      ) async {
    await init();

    try {
      await _tts.setVoice(voice);

      selectedVoice = voice;

      return true;
    } catch (e) {
      errorNotifier.value = e.toString();
      return false;
    }
  }

  Future<void> resetVoice() async {
    await init();

    await _tts.clearVoice();

    selectedVoice = null;
  }

  Future<void> setSpeechRate(double rate) async {
    speechRate = rate.clamp(0.0, 1.0);

    await init();

    await _tts.setSpeechRate(speechRate);
  }


  Future<void> setPitch(double value) async {
    pitch = value.clamp(0.5, 2.0);

    await init();

    await _tts.setPitch(pitch);
  }


  Future<void> setVolume(double value) async {
    volume = value.clamp(0.0, 1.0);

    await init();

    await _tts.setVolume(volume);
  }

  Future<List<dynamic>> getAvailableEngines() async {
    if (!Platform.isAndroid) return [];

    await init();

    try {
      final result = await _tts.getEngines;

      return result is List ? result : [];
    } catch (e) {
      log('[TTS] Get engines error: $e');
      return [];
    }
  }

  Future<bool> setEngine(String engine) async {
    if (!Platform.isAndroid) return false;

    await init();

    try {
      await stop();

      await _tts.setEngine(engine);

      return true;
    } catch (e) {
      errorNotifier.value = e.toString();
      return false;
    }
  }

  Future<dynamic> getDefaultEngine() async {
    if (!Platform.isAndroid) return null;

    await init();

    return _tts.getDefaultEngine;
  }

  Future<dynamic> getDefaultVoice() async {
    if (!Platform.isAndroid) return null;

    await init();

    return _tts.getDefaultVoice;
  }

  Future<void> setSilence(int milliseconds) async {
    if (!Platform.isAndroid) return;

    await init();

    await _tts.setSilence(milliseconds);
  }

  Future<dynamic> getMaxSpeechInputLength() async {
    if (!Platform.isAndroid) return null;

    await init();

    return _tts.getMaxSpeechInputLength;
  }


  Future<void> setAudioAttributesForNavigation() async {
    await init();

    await _tts.setAudioAttributesForNavigation();
  }


  Future<bool> synthesizeToFile(
      String text,
      String filePath,
      ) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return false;
    }

    if (text.trim().isEmpty) return false;

    await init();

    try {
      await _tts.awaitSynthCompletion(true);

      final fileName = filePath;

      final result = await _tts.synthesizeToFile(
        text,
        fileName,
        true,
      );

      return result == 1 || result == true;
    } catch (e) {
      errorNotifier.value = e.toString();

      log('[TTS] Synthesize error: $e');

      return false;
    }
  }

  void reset() {
    currentTextNotifier.value = '';
    currentWordNotifier.value = '';

    progressNotifier.value = 0;

    errorNotifier.value = '';
  }

  Future<void> dispose() async {
    if (_disposed) return;

    await stop();

    _disposed = true;

    statusNotifier.dispose();
    speakingNotifier.dispose();
    pausedNotifier.dispose();
    errorNotifier.dispose();
    currentTextNotifier.dispose();
    currentWordNotifier.dispose();
    progressNotifier.dispose();

    log('[TTS] Disposed');
  }
}