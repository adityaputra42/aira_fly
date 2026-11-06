import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/utils/stt_service.dart';
import '../../../../core/utils/tts_service.dart';
/// What the chat needs from speech recognition. Kept tiny on purpose so the
/// controller can be tested with fakes (the real services are singletons).
class VoiceTranscript {
  final String text;
  final bool isFinal;
  const VoiceTranscript(this.text, {required this.isFinal});
}

abstract interface class VoiceInput {
  Stream<VoiceTranscript> get transcripts;

  ValueListenable<bool> get listening;

  ValueListenable<double> get soundLevel;

  Future<bool> start();

  Future<void> stop();

  Future<void> cancel();
}

abstract interface class VoiceOutput {
  ValueListenable<bool> get speaking;

  Future<void> speak(String text);
  Future<void> stop();
}

class SttVoiceInput implements VoiceInput {
  SttVoiceInput({SpeechToTextService? service, this.localeId = 'id_ID'})
    : _service = service ?? SpeechToTextService.instance;

  final SpeechToTextService _service;
  final String localeId;

  @override
  Stream<VoiceTranscript> get transcripts =>
      _service.results.map((r) => VoiceTranscript(r.recognizedWords, isFinal: r.finalResult));

  @override
  ValueListenable<bool> get listening => _service.listeningNotifier;

  @override
  ValueListenable<double> get soundLevel => _service.soundLevelNotifier;

  @override
  Future<bool> start() async {
    if (await _service.startListening(localeId: localeId)) return true;
    if (!_service.isAvailable) return false;
    return _waitUntilListening(const Duration(milliseconds: 800));
  }

  Future<bool> _waitUntilListening(Duration timeout) {
    final notifier = _service.listeningNotifier;
    if (notifier.value) return Future.value(true);
    final done = Completer<bool>();
    void onChange() {
      if (notifier.value && !done.isCompleted) done.complete(true);
    }

    notifier.addListener(onChange);
    return done.future
        .timeout(timeout, onTimeout: () => false)
        .whenComplete(() => notifier.removeListener(onChange));
  }

  @override
  Future<void> stop() async {
    await _service.stopListening();
  }

  @override
  Future<void> cancel() => _service.cancelListening();
}

class TtsVoiceOutput implements VoiceOutput {
  TtsVoiceOutput({TtsService? service}) : _service = service ?? TtsService.instance;

  final TtsService _service;

  @override
  ValueListenable<bool> get speaking => _service.speakingNotifier;

  @override
  Future<void> speak(String text) => _service.speak(text, flush: true);

  @override
  Future<void> stop() => _service.stop();
}
