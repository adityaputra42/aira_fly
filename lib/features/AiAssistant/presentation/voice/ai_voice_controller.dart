import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'ai_voice_ports.dart';

enum VoicePhase { idle, listening, speaking }

class AiVoiceController extends ChangeNotifier {
  AiVoiceController({
    required this._input,
    required this._output,
    this.onPartial,
    this.onFinal,
    this.onCancel,
  }) {
    _sub = _input.transcripts.listen(_onTranscript);
    _input.listening.addListener(_onListeningChanged);
    _input.soundLevel.addListener(_onLevel);
    _output.speaking.addListener(_onSpeakingChanged);
  }

  static const _speakingHold = Duration(milliseconds: 250);

  final VoiceInput _input;
  final VoiceOutput _output;

  final ValueChanged<String>? onPartial;

  final ValueChanged<String>? onFinal;

  final VoidCallback? onCancel;

  StreamSubscription<VoiceTranscript>? _sub;
  final _level = ValueNotifier<double>(0);
  final _transcript = ValueNotifier<String>('');
  Timer? _hold;
  bool _speakingShown = false;
  String _spokenText = '';
  bool _delivered = false;
  bool _voiceReplies = false;
  bool _expectReply = false;
  bool _lastInputWasVoice = false;
  bool _disposed = false;

  double _lo = 0;
  double _hi = 0;
  bool _seeded = false;

  bool get listening => _input.listening.value;

  VoicePhase get phase => listening
      ? VoicePhase.listening
      : (_speakingShown ? VoicePhase.speaking : VoicePhase.idle);

  ValueListenable<double> get level => _level;

  ValueListenable<String> get transcript => _transcript;

  String get spokenText => _spokenText;

  bool get voiceReplies => _voiceReplies;

  void setVoiceReplies(bool value) {
    if (_voiceReplies == value) return;
    _voiceReplies = value;
    if (!value) unawaited(_output.stop());
    notifyListeners();
  }
  Future<String?> toggleMic() async {
    if (listening) {
      await _input.stop();
      return null;
    }
    await _output.stop();
    _delivered = false;
    final started = await _input.start();
    if (!started) {
      return 'Mikrofon atau pengenalan suara tidak tersedia. '
          'Pastikan izin mikrofon dan pengenalan suara aktif di Pengaturan.';
    }
    return null;
  }

  Future<void> finishListening() => _input.stop();

  Future<void> cancelListening() async {
    _delivered = true;
    _transcript.value = '';
    await _input.cancel();
    onCancel?.call();
  }

  Future<void> stopSpeaking() => _output.stop();

  void noteSent({required bool voice}) {
    _expectReply = true;
    _lastInputWasVoice = voice;
    unawaited(_output.stop());
  }

  Future<void> onAssistantMessage(String text) async {
    if (_disposed || !_expectReply) return;
    _expectReply = false;
    if (!(_lastInputWasVoice || _voiceReplies)) return;
    if (listening) return;
    final speech = _forSpeech(text);
    if (speech.isEmpty) return;
    _spokenText = speech;
    await _output.speak(speech);
  }

  Future<void> stopAll() async {
    _delivered = true;
    await _input.cancel();
    await _output.stop();
  }

  void _onTranscript(VoiceTranscript t) {
    if (_disposed) return;
    final text = t.text.trim();
    if (text.isEmpty || _delivered) return;
    _transcript.value = text;
    onPartial?.call(text);
    if (!t.isFinal) return;
    _delivered = true;
    onFinal?.call(text);
  }

  void _onListeningChanged() {
    if (_disposed) return;
    _level.value = 0;
    if (listening) {
      _seeded = false;
      _transcript.value = '';
    }
    notifyListeners();
  }

  void _onLevel() {
    if (_disposed || !listening) return;
    final v = _input.soundLevel.value;
    if (!_seeded) {
      _lo = v - 1;
      _hi = v + 1;
      _seeded = true;
    }
    _lo = math.min(_lo, v);
    _hi = math.max(_hi, v);
    _lo += (v - _lo) * 0.002;
    _hi -= (_hi - v) * 0.002;
    final span = math.max(_hi - _lo, 4.0);
    final n = ((v - _lo) / span).clamp(0.0, 1.0);
    _level.value = math.max(n, _level.value * 0.85); // fast attack, slow release
  }

  void _onSpeakingChanged() {
    if (_disposed) return;
    if (_output.speaking.value) {
      _hold?.cancel();
      if (!_speakingShown) {
        _speakingShown = true;
        notifyListeners();
      }
    } else if (_speakingShown) {
      _hold?.cancel();
      _hold = Timer(_speakingHold, () {
        if (_disposed) return;
        _speakingShown = false;
        notifyListeners();
      });
    }
  }

  static String _forSpeech(String text) => text.replaceAll(RegExp(r'\s+'), ' ').trim();

  @override
  void dispose() {
    _disposed = true;
    _hold?.cancel();
    _input.listening.removeListener(_onListeningChanged);
    _input.soundLevel.removeListener(_onLevel);
    _output.speaking.removeListener(_onSpeakingChanged);
    unawaited(_sub?.cancel());
    unawaited(stopAll());
    _level.dispose();
    _transcript.dispose();
    super.dispose();
  }
}
