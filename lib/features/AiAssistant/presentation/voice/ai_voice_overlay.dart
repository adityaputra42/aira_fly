import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pss_app/app/theme/theme.dart';
import 'package:pss_app/core/common/widget/primary_button.dart';
import 'package:pss_app/core/common/widget/secondary_button.dart';

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
        final Widget child = switch (phase) {
          VoicePhase.idle => const SizedBox.shrink(key: ValueKey('voice-idle')),
          VoicePhase.listening => _ListeningPanel(
            key: const ValueKey('voice-listening'),
            controller: controller,
          ),
          VoicePhase.speaking => _SpeakingBanner(
            key: const ValueKey('voice-speaking'),
            controller: controller,
          ),
        };
        return AnimatedSwitcher(duration: const Duration(milliseconds: 200), child: child);
      },
    );
  }
}

class _ListeningPanel extends StatelessWidget {
  const _ListeningPanel({super.key, required this.controller});

  final AiVoiceController controller;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.stopAll();
      },
      child: Semantics(
        liveRegion: true,
        label: 'Mendengarkan',
        child: Material(
          color: Colors.black.withValues(alpha: 0.62),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: _Orb(level: controller.level, speaking: false),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Mendengarkan...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: ValueListenableBuilder<String>(
                      valueListenable: controller.transcript,
                      builder: (_, text, _) => Text(
                        text.isEmpty ? 'Silakan bicara' : text,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: text.isEmpty ? 0.55 : 0.9),
                          fontSize: 15,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 12,
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          onPressed: controller.cancelListening,
                          title: "Cancel",

                        ),
                      ),
                      Expanded(
                        child: PrimaryButton(
                          onPressed: controller.finishListening, title: 'Done',
                        ),),
                    ],
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

class _SpeakingBanner extends StatelessWidget {
  const _SpeakingBanner({super.key, required this.controller});

  final AiVoiceController controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Semantics(
          liveRegion: true,
          label: 'Asisten berbicara',
          child: Material(
            color: Colors.black.withValues(alpha: 0.86),
            elevation: 6,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
              child: Row(
                spacing: 12,
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: _Orb(level: controller.level, speaking: true, iconSize: 20),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Asisten berbicara...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          controller.spokenText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 13,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: controller.stopSpeaking,
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    child: const Text('Hentikan'),
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

class _Orb extends StatefulWidget {
  const _Orb({required this.level, required this.speaking, this.iconSize = 40});

  final ValueListenable<double> level;
  final bool speaking;
  final double iconSize;

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.hasBoundedWidth && constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 240.0;
        return SizedBox(
          width: side,
          height: side,
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
                  size: widget.iconSize,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OrbPainter extends CustomPainter {
  _OrbPainter({required this.t, required this.level, required this.speaking, required this.color});

  final double t; // 0..1 loop
  final double level; // 0..1 microphone level
  final bool speaking;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final base = size.shortestSide * 0.22;

    for (var i = 3; i >= 1; i--) {
      // Listening follows the microphone; speaking is a travelling ripple.
      final wave = speaking ? 0.5 + 0.5 * math.sin(t * 2 * math.pi * 2 - i * 0.9) : level;
      final radius = base + i * size.shortestSide * 0.09 * (0.6 + 0.8 * wave);
      canvas.drawCircle(center, radius, Paint()..color = color.withValues(alpha: 0.34 - 0.08 * i));
    }

    final pulse = speaking ? 0.5 + 0.5 * math.sin(t * 2 * math.pi * 2) : level;
    canvas.drawCircle(center, base * (1 + 0.12 * pulse), Paint()..color = color);
  }

  @override
  bool shouldRepaint(_OrbPainter old) =>
      old.t != t || old.level != level || old.speaking != speaking || old.color != color;
}
