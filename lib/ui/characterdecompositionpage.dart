import 'package:flutter/material.dart';
import 'package:hanzishu/data/characterdecompositionlist.dart';

/// Standalone landing page for Step 4: Character Decomposition.
///
/// This file is intentionally self-contained so it can be copied into the
/// Hanzishu tutorial flow and wired up later.
class CharacterDecompositionPage extends StatelessWidget {
  const CharacterDecompositionPage({
    //super.key,
    this.onBack,
    this.onStartStudy,
    this.onSkipStep,
  });

  final VoidCallback? onBack;
  final VoidCallback? onStartStudy;
  final VoidCallback? onSkipStep;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0B1F3A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: onBack ?? () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Character Decomposition',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0B1F3A),
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 520;
            final maxContentWidth = isNarrow ? constraints.maxWidth : 620.0;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isNarrow ? 20 : 32,
                  vertical: 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _StepIndicator(currentStep: 4, totalSteps: 5),
                      const SizedBox(height: 28),
                      _SubtitleRow(
                        onSkipStep: onSkipStep,
                        isNarrow: isNarrow,
                      ),
                      const SizedBox(height: 20),
                      _DecompositionHero(isNarrow: isNarrow),
                      const SizedBox(height: 28),
                      _StartButton(onPressed: onStartStudy),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep, required this.totalSteps});

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(totalSteps * 2 - 1, (index) {
          if (index.isOdd) {
            final leftStep = (index + 1) ~/ 2;
            final isCompletedLine = leftStep < currentStep;
            return Container(
              width: 46,
              height: 3,
              decoration: BoxDecoration(
                color: isCompletedLine
                    ? const Color(0xFF1677FF)
                    : const Color(0xFFD2D8E2),
                borderRadius: BorderRadius.circular(999),
              ),
            );
          }

          final step = index ~/ 2 + 1;
          final isCurrent = step == currentStep;
          final isCompleted = step < currentStep;
          final fillColor = isCurrent || isCompleted
              ? const Color(0xFF1677FF)
              : const Color(0xFFD2D8E2);

          return Container(
            width: isCurrent ? 42 : 34,
            height: isCurrent ? 42 : 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: fillColor,
              border: isCurrent
                  ? Border.all(color: const Color(0xFFDCEBFF), width: 6)
                  : null,
              boxShadow: isCurrent
                  ? const [
                BoxShadow(
                  color: Color(0x221677FF),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ]
                  : null,
            ),
            child: Text(
              '$step',
              style: TextStyle(
                color: isCurrent || isCompleted
                    ? Colors.white
                    : const Color(0xFF4C596A),
                fontSize: isCurrent ? 18 : 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SubtitleRow extends StatelessWidget {
  const _SubtitleRow({required this.onSkipStep, required this.isNarrow});

  final VoidCallback? onSkipStep;
  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Top-left to Bottom-right',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isNarrow ? 23 : 28,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1677FF),
              height: 1.1,
            ),
          ),
          Positioned(
            right: 0,
            child: TextButton(
              onPressed: onSkipStep,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6C7686),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
              ),
              child: Text(
                'Skip Step',
                style: TextStyle(
                  fontSize: isNarrow ? 14 : 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DecompositionHero extends StatelessWidget {
  const _DecompositionHero({required this.isNarrow});

  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    final width = isNarrow ? 350.0 : 470.0;
    final height = isNarrow ? 470.0 : 540.0;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(child: _SoftGlow()),
          Positioned(
            top: isNarrow ? 24 : 22,
            left: 0,
            right: 0,
            child: Text(
              '程',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isNarrow ? 118 : 148,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF102B4C),
                shadows: const [
                  Shadow(
                    color: Color(0x33000000),
                    blurRadius: 6,
                    offset: Offset(3, 4),
                  ),
                  Shadow(
                    color: Color(0x44FFD878),
                    blurRadius: 24,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
          CustomPaint(
            size: Size(width, height),
            painter: _DottedPathPainter(),
          ),
          Positioned(
            left: isNarrow ? 26 : 44,
            top: isNarrow ? 210 : 250,
            child: const _ComponentBlock(
              label: '禾',
              number: '1',
              color: Color(0xFF58D84D),
              rotate: -0.06,
            ),
          ),
          Positioned(
            left: isNarrow ? 145 : 190,
            top: isNarrow ? 300 : 342,
            child: const _ComponentBlock(
              label: '口',
              number: '2',
              color: Color(0xFFFFC928),
              rotate: 0.02,
            ),
          ),
          Positioned(
            right: isNarrow ? 28 : 44,
            bottom: isNarrow ? 34 : 42,
            child: const _ComponentBlock(
              label: '王',
              number: '3',
              color: Color(0xFF2196F3),
              rotate: 0.05,
            ),
          ),
          const Positioned(left: 42, top: 164, child: _Sparkle(color: Color(0xFFFFC928))),
          const Positioned(right: 56, top: 194, child: _Sparkle(color: Color(0xFF28A8FF))),
          const Positioned(right: 86, top: 126, child: _Sparkle(color: Color(0xFFFFC928), small: true)),
        ],
      ),
    );
  }
}

class _ComponentBlock extends StatelessWidget {
  const _ComponentBlock({
    required this.label,
    required this.number,
    required this.color,
    this.rotate = 0,
  });

  final String label;
  final String number;
  final Color color;
  final double rotate;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotate,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 112,
            height: 104,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.38),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
                const BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 8,
                  offset: Offset(4, 6),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white.withOpacity(0.35), color],
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 54,
                fontWeight: FontWeight.w900,
                color: Color(0xFF102B4C),
                shadows: [
                  Shadow(
                    color: Color(0x33000000),
                    blurRadius: 4,
                    offset: Offset(2, 3),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: -10,
            top: -14,
            child: Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.white.withOpacity(0.7), width: 2),
              ),
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DottedPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8EA2B8)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.31, size.height * 0.60)
      ..cubicTo(
        size.width * 0.46,
        size.height * 0.60,
        size.width * 0.42,
        size.height * 0.73,
        size.width * 0.55,
        size.height * 0.72,
      )
      ..cubicTo(
        size.width * 0.72,
        size.height * 0.72,
        size.width * 0.66,
        size.height * 0.86,
        size.width * 0.77,
        size.height * 0.86,
      );

    _drawDashedPath(canvas, path, paint, dashLength: 8, gapLength: 10);
  }

  void _drawDashedPath(
      Canvas canvas,
      Path path,
      Paint paint, {
        required double dashLength,
        required double gapLength,
      }) {
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashLength;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SoftGlow extends StatelessWidget {
  const _SoftGlow();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const RadialGradient(
          center: Alignment(0, -0.28),
          radius: 0.72,
          colors: [
            Color(0xFFFFF3C8),
            Color(0x00FFF3C8),
          ],
        ),
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle({required this.color, this.small = false});

  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? 18.0 : 26.0;
    return Icon(Icons.auto_awesome, size: size, color: color);
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 420,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1677FF),
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: const Color(0x551677FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Start Study',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(width: 18),
            Icon(Icons.arrow_forward_rounded, size: 30),
          ],
        ),
      ),
    );
  }
}
