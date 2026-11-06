import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pss_app/app/theme/theme.dart';

import 'ai_voice_controller.dart';

class AiVoiceOverlay extends StatelessWidget {
  const AiVoiceOverlay({super.key, required this.controller});

  final AiVoiceController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final phase = controller.phase;
        final idle = phase == VoicePhase.idle;
        return IgnorePointer(
          ignoring: idle,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: idle
                ? const SizedBox.expand(key: ValueKey('voice-idle'))
                : _Panel(
                    key: ValueKey(phase),
                    controller: controller,
                    phase: phase,
                  ),
          ),
        );
      },
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({super.key, required this.controller, required this.phase});

  final AiVoiceController controller;
  final VoicePhase phase;

  bool get _listening => phase == VoicePhase.listening;

  @override
  Widget build(BuildContext context) {
    final title = _listening ? 'Mendengarkan...' : 'Asisten berbicara...';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.stopAll();
      },
      child: Semantics(
        liveRegion: true,
        label: title,
        child: Material(
          color: Colors.black.withValues(alpha: 0.62),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  _Orb(level: controller.level, speaking: !_listening),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    style: AppFont.semibold18
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: _listening
                        ? ValueListenableBuilder<String>(
                            valueListenable: controller.transcript,
                            builder: (_, text, __) => _Caption(
                              text.isEmpty ? 'Silakan bicara' : text,
                              dim: text.isEmpty,
                            ),
                          )
                        : _Caption(controller.spokenText),
                  ),
                  const Spacer(flex: 3),
                  if (_listening)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 12,
                      children: [
                        OutlinedButton(
                          onPressed: controller.cancelListening,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white54),
                          ),
                          child: const Text('Batal'),
                        ),
                        FilledButton(
                          onPressed: controller.finishListening,
                          child: const Text('Selesai', style: AppFont.medium12),
                        ),
                      ],
                    )
                  else
                    FilledButton.icon(
                      onPressed: controller.stopSpeaking,
                      icon: const Icon(Icons.stop_rounded),
                      label: const Text('Hentikan', style: AppFont.medium12),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Caption extends StatelessWidget {
  const _Caption(this.text, {this.dim = false});

  final String text;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: AppFont.medium14.copyWith(
        color: Colors.white.withValues(alpha: dim ? 0.55 : 0.9),
        height: 1.35,
      ),
    );
  }
}

class _Orb extends StatefulWidget {
  const _Orb({required this.level, required this.speaking});

  final ValueListenable<double> level;
  final bool speaking;

  @override
  State<_Orb> createState() => _OrbState();
}

class _OrbState extends State<_Orb> with SingleTickerProviderStateMixin {
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _anim.stop();
    } else if (!_anim.isAnimating) {
      _anim.repeat();
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 240,
      child: AnimatedBuilder(
        animation: Listenable.merge([_anim, widget.level]),
        builder: (context, _) => CustomPaint(
          painter: _OrbPainter(
            t: _anim.value,
            level: widget.level.value,
            speaking: widget.speaking,
            color: AppColor.primaryColor,
          ),
          child: Center(
            child: Icon(
              widget.speaking ? Icons.volume_up_rounded : Icons.mic_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrbPainter extends CustomPainter {
  _OrbPainter({
    required this.t,
    required this.level,
    required this.speaking,
    required this.color,
  });

  final double t; // 0..1 loop
  final double level; // 0..1 microphone level
  final bool speaking;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final base = size.shortestSide * 0.22;

    for (var i = 3; i >= 1; i--) {
      final wave = speaking
          ? 0.5 + 0.5 * math.sin(t * 2 * math.pi * 2 - i * 0.9)
          : level;
      final radius = base + i * size.shortestSide * 0.09 * (0.6 + 0.8 * wave);
      canvas.drawCircle(
        center,
        radius,
        Paint()..color = color.withValues(alpha: 0.34 - 0.08 * i),
      );
    }

    final pulse = speaking ? 0.5 + 0.5 * math.sin(t * 2 * math.pi * 2) : level;
    canvas.drawCircle(
      center,
      base * (1 + 0.12 * pulse),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_OrbPainter old) =>
      old.t != t ||
      old.level != level ||
      old.speaking != speaking ||
      old.color != color;
}
