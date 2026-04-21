import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../demo_strings.dart';
import '../services/eleven_labs_service.dart';
import '../services/tutorial_controller.dart';
import '../theme/showcase_theme.dart';

/// Pulsing FAB-style bubble. First tap opens overlay + TTS; then it hides
/// until [TutorialController.resetAll] (e.g. refresh icon in app bar).
class TutorialBubble extends StatefulWidget {
  final String stepId;

  const TutorialBubble({super.key, required this.stepId});

  @override
  State<TutorialBubble> createState() => _TutorialBubbleState();
}

class _TutorialBubbleState extends State<TutorialBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  bool? _seen;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _loadSeenState();
  }

  Future<void> _loadSeenState() async {
    final seen = await TutorialController.hasSeenStep(widget.stepId);
    if (!mounted) return;
    setState(() => _seen = seen);
    if (!seen) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _openOverlay() async {
    await _TutorialOverlay.show(
      context: context,
      step: DemoStrings.tutorialStepById(widget.stepId),
    );
    await TutorialController.markStepSeen(widget.stepId);
    if (!mounted) return;
    _pulse.stop();
    _pulse.reset();
    setState(() => _seen = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_seen == null || _seen == true) return const SizedBox.shrink();

    return Semantics(
      button: true,
      label: DemoStrings.tutorialReplay,
      child: GestureDetector(
        onTap: _openOverlay,
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (context, child) {
            final t = _pulse.value;
            return SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 56 + (t * 20),
                    height: 56 + (t * 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: VIralColors.neon.withValues(
                        alpha: 0.25 * (1 - t),
                      ),
                    ),
                  ),
                  child!,
                ],
              ),
            );
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: VIralColors.charcoal2,
              border: Border.all(color: VIralColors.neon, width: 2),
              boxShadow: VIralShadows.glowNeonSm,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/brand/mascot-head.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: VIralColors.neon,
                      border: Border.all(
                        color: VIralColors.charcoal1,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '?',
                      style: TextStyle(
                        color: VIralColors.neonInk,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TutorialOverlay extends StatefulWidget {
  final TutorialStep step;
  const _TutorialOverlay({required this.step});

  static Future<void> show({
    required BuildContext context,
    required TutorialStep step,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: DemoStrings.tutorialClose,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (ctx, a1, a2) => _TutorialOverlay(step: step),
      transitionBuilder: (ctx, anim, a2, child) {
        final scale = Tween<double>(begin: 0.92, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutBack))
            .animate(anim);
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
    );
  }

  @override
  State<_TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<_TutorialOverlay>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  late final AnimationController _breath;
  bool _audioLoading = false;
  bool _audioFailed = false;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _breath = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _play();
  }

  Future<void> _play() async {
    if (!ElevenLabsService.isConfigured) {
      setState(() => _audioFailed = true);
      return;
    }
    setState(() {
      _audioLoading = true;
      _audioFailed = false;
    });
    try {
      final path = await ElevenLabsService.synthesiseToFile(
        text: widget.step.voice,
      );
      if (!mounted) return;
      if (path == null) {
        setState(() {
          _audioLoading = false;
          _audioFailed = true;
        });
        return;
      }
      await _player.stop();
      await _player.setFilePath(path);
      if (!mounted) return;
      setState(() => _audioLoading = false);
      await _player.play();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _audioLoading = false;
        _audioFailed = true;
      });
    }
  }

  Future<void> _close() async {
    if (_closing) return;
    _closing = true;
    await _player.stop();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _breath.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(VIralSpace.s5),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: _card(),
        ),
      ),
    );
  }

  Widget _card() {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _mascot(size: 88),
          ),
          const SizedBox(width: 0),
          Flexible(child: _speechBubble()),
        ],
      ),
    );
  }

  Widget _mascot({required double size}) {
    return AnimatedBuilder(
      animation: _breath,
      builder: (context, child) => Transform.scale(
        scale: 1.0 + (_breath.value * 0.05),
        child: child,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: VIralColors.charcoal2,
          boxShadow: VIralShadows.glowNeonSm,
        ),
        child: Padding(
          padding: const EdgeInsets.all(VIralSpace.s2),
          child: ClipOval(
            child: Image.asset(
              'assets/brand/mascot-head.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _speechBubble() {
    const tailWidth = 16.0;
    return CustomPaint(
      painter: _SpeechBubblePainter(
        fillColor: VIralColors.charcoal3,
        borderColor: VIralColors.neon.withValues(alpha: 0.6),
        borderWidth: 1.5,
        radius: 22,
        tailWidth: tailWidth,
        tailHeight: 20,
        tailApexFraction: 0.28,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          tailWidth + VIralSpace.s4,
          VIralSpace.s4,
          VIralSpace.s5,
          VIralSpace.s4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.step.title, style: VIralText.h3),
            const SizedBox(height: VIralSpace.s2),
            Text(widget.step.body, style: VIralText.body),
            if (_audioFailed) ...[
              const SizedBox(height: VIralSpace.s2),
              Text(
                DemoStrings.tutorialAudioFailed,
                style: VIralText.small.copyWith(color: VIralColors.warn),
              ),
            ],
            const SizedBox(height: VIralSpace.s4),
            Row(
              children: [
                _replayButton(),
                const SizedBox(width: VIralSpace.s2),
                Expanded(child: _closeButton()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _replayButton() {
    return Container(
      decoration: BoxDecoration(
        color: VIralColors.charcoal3,
        borderRadius: VIralRadii.rLg,
        border: Border.all(color: VIralColors.glassBorder2),
      ),
      child: IconButton(
        onPressed: _audioLoading ? null : _play,
        icon: _audioLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(VIralColors.neon),
                ),
              )
            : Icon(
                _audioFailed
                    ? Icons.volume_off_rounded
                    : Icons.replay_rounded,
                color: _audioFailed ? VIralColors.warn : VIralColors.fg1,
                size: 22,
              ),
        tooltip: DemoStrings.tutorialReplay,
      ),
    );
  }

  Widget _closeButton() {
    return ElevatedButton(
      onPressed: _close,
      style: ElevatedButton.styleFrom(
        backgroundColor: VIralColors.neon,
        foregroundColor: VIralColors.neonInk,
        padding: const EdgeInsets.symmetric(vertical: VIralSpace.s4),
        shape: RoundedRectangleBorder(borderRadius: VIralRadii.rLg),
        elevation: 0,
      ),
      child: Text(
        DemoStrings.tutorialClose,
        style: VIralText.button.copyWith(
          color: VIralColors.neonInk,
          fontSize: 15,
        ),
      ),
    );
  }
}

class _SpeechBubblePainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final double radius;
  final double tailWidth;
  final double tailHeight;
  final double tailApexFraction;

  _SpeechBubblePainter({
    required this.fillColor,
    required this.borderColor,
    required this.borderWidth,
    required this.radius,
    required this.tailWidth,
    required this.tailHeight,
    required this.tailApexFraction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final r = radius;
    final tw = tailWidth;
    final th = tailHeight;
    final apex = (tailApexFraction.clamp(0.0, 1.0)) * size.height;

    final path = Path()
      ..moveTo(tw + r, 0)
      ..lineTo(size.width - r, 0)
      ..quadraticBezierTo(size.width, 0, size.width, r)
      ..lineTo(size.width, size.height - r)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width - r,
        size.height,
      )
      ..lineTo(tw + r, size.height)
      ..quadraticBezierTo(tw, size.height, tw, size.height - r)
      ..lineTo(tw, apex + th / 2)
      ..lineTo(0, apex)
      ..lineTo(tw, apex - th / 2)
      ..lineTo(tw, r)
      ..quadraticBezierTo(tw, 0, tw + r, 0)
      ..close();

    canvas.drawPath(path, Paint()..color = fillColor);
    canvas.drawPath(
      path,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth,
    );
  }

  @override
  bool shouldRepaint(covariant _SpeechBubblePainter old) =>
      old.fillColor != fillColor ||
      old.borderColor != borderColor ||
      old.borderWidth != borderWidth ||
      old.radius != radius ||
      old.tailWidth != tailWidth ||
      old.tailHeight != tailHeight ||
      old.tailApexFraction != tailApexFraction;
}
