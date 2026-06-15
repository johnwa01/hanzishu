import 'package:flutter/material.dart';
import 'package:hanzishu/data/characterdecompositionlist.dart';
import 'package:hanzishu/variables.dart';
import 'dart:ui';
import 'package:hanzishu/ui/tutorialstepindicator.dart';

/// Step 4: Character Decomposition.
///
/// Page flow:
///   0. Landing page
///   1..N. One decomposition example at a time from theCharacterDecompositionList
///   Final. Completion dialog, then returns to ToolsPage so the controller can
///          continue to the next tutorial step.
class CharacterDecompositionPage extends StatefulWidget {
  const CharacterDecompositionPage({
    //super.key,
    this.onBack,
    this.onCompleted,
    this.onSkipStep,
  });

  final VoidCallback? onBack;
  final VoidCallback? onCompleted;
  final VoidCallback? onSkipStep;

  @override
  _CharacterDecompositionPageState createState() =>
      _CharacterDecompositionPageState();
}

class _CharacterDecompositionPageState extends State<CharacterDecompositionPage> {
  int currentIndex = 0; // 0 is landing page; examples start at 1.

  int get totalExamples => theCharacterDecompositionList.length - 1;

  double _ratioForWidth(double width) {
    double ratio = width / 900.0;
    if (ratio > 1.15) ratio = 1.15;
    if (ratio < 0.78) ratio = 0.78;
    return ratio;
  }

  bool get _isLandingPage => currentIndex == 0;

  void _goBack() {
    if (widget.onBack != null) {
      widget.onBack!();
      return;
    }
    Navigator.maybePop(context);
  }

  void _skipStep() {
    if (widget.onSkipStep != null) {
      widget.onSkipStep!();
      return;
    }

    // Same pattern as ComponentPage: tell ToolsPage this was not a true back
    // arrow exit, so it can continue to the next tutorial case.
    theIsBackArrowExit = false;
    Navigator.of(context).pop();
  }

  void _startStudy() {
    setState(() {
      currentIndex = 1;
    });
  }

  void _previous() {
    if (currentIndex <= 0) {
      _goBack();
      return;
    }

    setState(() {
      currentIndex--;
    });
  }

  void _continue() {
    if (_isLandingPage) {
      _startStudy();
      return;
    }

    if (currentIndex < totalExamples) {
      setState(() {
        currentIndex++;
      });
      return;
    }

    _showCompletedDialog();
  }

  void _finishStep() {
    if (widget.onCompleted != null) {
      widget.onCompleted!();
      return;
    }

    theIsBackArrowExit = false;
    Navigator.of(context).pop();
  }

  void _showCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          title: const Text(
            'Great Job!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.w900,
              color: Color(0xFF102B4C),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF2F80ED),
                size: 72.0,
              ),
              SizedBox(height: 16.0),
              Text(
                'You can now break characters into components.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17.0,
                  height: 1.35,
                  color: Color(0xFF405064),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F80ED),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28.0,
                  vertical: 14.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _finishStep();
              },
            ),
          ],
        );
      },
    );
  }

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
          onPressed: _goBack,
        ),
        centerTitle: true,
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
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isNarrow = constraints.maxWidth < 520;
            final double ratio = _ratioForWidth(constraints.maxWidth);
            final double maxContentWidth = isNarrow ? constraints.maxWidth : 640.0;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isNarrow ? 18.0 : 32.0,
                  vertical: 18.0,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: _isLandingPage
                      ? _buildLandingPage(isNarrow, ratio)
                      : _buildExamplePage(isNarrow, ratio),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLandingPage(bool isNarrow, double ratio) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TutorialStepIndicator(currentStep: 4, ratio: ratio),
        SizedBox(height: 24.0 * ratio),
        _SubtitleRow(
          title: 'Top-left to Bottom-right',
          onSkipStep: _skipStep,
          isNarrow: isNarrow,
        ),
        SizedBox(height: 18.0 * ratio),
        _DecompositionHero(isNarrow: isNarrow),
        SizedBox(height: 24.0 * ratio),
        _PrimaryButton(
          text: 'Start Study',
          onPressed: _startStudy,
        ),
      ],
    );
  }

  Widget _buildExamplePage(bool isNarrow, double ratio) {
    final item = theCharacterDecompositionList[currentIndex];
    final List<String> components = _componentsForCharacter(item.character);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _ExampleProgress(
          current: currentIndex,
          total: totalExamples,
          ratio: ratio,
        ),
        SizedBox(height: 24.0 * ratio),
        _SubtitleRow(
          title: item.name,
          onSkipStep: _skipStep,
          isNarrow: isNarrow,
        ),
        SizedBox(height: 22.0 * ratio),
        _CharacterExampleCard(
          character: item.character,
          components: components,
          ruleName: item.name,
          isNarrow: isNarrow,
          ratio: ratio,
        ),
        SizedBox(height: 24.0 * ratio),
        _BottomNavigation(
          onPrevious: _previous,
          onContinue: _continue,
          isLast: currentIndex == totalExamples,
        ),
      ],
    );
  }

  List<String> _componentsForCharacter(String character) {
    switch (character) {
      case '明':
        return <String>['日', '月'];
      case '否':
        return <String>['不', '口'];
      case '问':
        return <String>['门', '口'];
      case '程':
        return <String>['禾', '口', '王'];
      case '想':
        return <String>['木', '目', '心'];
      case '好':
        return <String>['女', '子'];
      case '十':
        return <String>['十'];
      default:
        return <String>[character];
    }
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep, required this.totalSteps});

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(totalSteps * 2 - 1, (int index) {
          if (index.isOdd) {
            final int leftStep = (index + 1) ~/ 2;
            final bool isCompletedLine = leftStep < currentStep;
            return Container(
              width: 34.0,
              height: 2.5,
              decoration: BoxDecoration(
                color: isCompletedLine
                    ? const Color(0xFF2F80ED)
                    : const Color(0xFFD7E0EE),
                borderRadius: BorderRadius.circular(999.0),
              ),
            );
          }

          final int step = index ~/ 2 + 1;
          final bool isCurrent = step == currentStep;
          final bool isCompleted = step < currentStep;

          if (isCompleted) {
            return Container(
              width: 30.0,
              height: 30.0,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF2F80ED),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 19.0,
              ),
            );
          }

          return Container(
            width: isCurrent ? 38.0 : 30.0,
            height: isCurrent ? 38.0 : 30.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrent ? const Color(0xFF2F80ED) : Colors.white,
              border: Border.all(
                color: isCurrent
                    ? const Color(0xFFDCEBFF)
                    : const Color(0xFFD7E0EE),
                width: isCurrent ? 5.0 : 1.5,
              ),
              boxShadow: isCurrent
                  ? const <BoxShadow>[
                BoxShadow(
                  color: Color(0x221677FF),
                  blurRadius: 12.0,
                  offset: Offset(0, 4.0),
                ),
              ]
                  : null,
            ),
            child: Text(
              '$step',
              style: TextStyle(
                color: isCurrent ? Colors.white : const Color(0xFF8B98AA),
                fontSize: isCurrent ? 17.0 : 13.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ExampleProgress extends StatelessWidget {
  const _ExampleProgress({
    required this.current,
    required this.total,
    required this.ratio,
  });

  final int current;
  final int total;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: LinearProgressIndicator(
            value: current / total,
            minHeight: 3.0,
            backgroundColor: const Color(0xFFD7E0EE),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2F80ED)),
          ),
        ),
        SizedBox(width: 10.0 * ratio),
        Text(
          '$current / $total',
          style: TextStyle(
            fontSize: 13.0 * ratio,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF7A8798),
          ),
        ),
      ],
    );
  }
}

class _SubtitleRow extends StatelessWidget {
  const _SubtitleRow({
    required this.title,
    required this.onSkipStep,
    required this.isNarrow,
  });

  final String title;
  final VoidCallback onSkipStep;
  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isNarrow ? 70.0 : 100.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isNarrow ? 21.0 : 27.0,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1677FF),
                height: 1.1,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: TextButton(
              onPressed: onSkipStep,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6C7686),
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
              ),
              child: Text(
                'Skip Section',
                style: TextStyle(
                  fontSize: isNarrow ? 13.0 : 15.0,
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
    final double width = isNarrow ? 350.0 : 470.0;
    final double height = isNarrow ? 470.0 : 540.0;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.0),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 24.0,
            offset: Offset(0, 10.0),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          const Positioned.fill(child: _SoftGlow()),
          Positioned(
            top: isNarrow ? 24.0 : 22.0,
            left: 0,
            right: 0,
            child: Text(
              '程',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isNarrow ? 118.0 : 148.0,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF102B4C),
                shadows: const <Shadow>[
                  Shadow(
                    color: Color(0x33000000),
                    blurRadius: 6.0,
                    offset: Offset(3.0, 4.0),
                  ),
                  Shadow(
                    color: Color(0x44FFD878),
                    blurRadius: 24.0,
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
            left: isNarrow ? 26.0 : 44.0,
            top: isNarrow ? 210.0 : 250.0,
            child: const _ComponentBlock(
              label: '禾',
              number: '1',
              color: Color(0xFF58D84D),
              rotate: -0.06,
            ),
          ),
          Positioned(
            left: isNarrow ? 145.0 : 190.0,
            top: isNarrow ? 300.0 : 342.0,
            child: const _ComponentBlock(
              label: '口',
              number: '2',
              color: Color(0xFFFFC928),
              rotate: 0.02,
            ),
          ),
          Positioned(
            right: isNarrow ? 28.0 : 44.0,
            bottom: isNarrow ? 34.0 : 42.0,
            child: const _ComponentBlock(
              label: '王',
              number: '3',
              color: Color(0xFF2196F3),
              rotate: 0.05,
            ),
          ),
          const Positioned(
            left: 42.0,
            top: 164.0,
            child: _Sparkle(color: Color(0xFFFFC928)),
          ),
          const Positioned(
            right: 56.0,
            top: 194.0,
            child: _Sparkle(color: Color(0xFF28A8FF)),
          ),
          const Positioned(
            right: 86.0,
            top: 126.0,
            child: _Sparkle(color: Color(0xFFFFC928), small: true),
          ),
        ],
      ),
    );
  }
}

class _CharacterExampleCard extends StatelessWidget {
  const _CharacterExampleCard({
    required this.character,
    required this.components,
    required this.ruleName,
    required this.isNarrow,
    required this.ratio,
  });

  final String character;
  final List<String> components;
  final String ruleName;
  final bool isNarrow;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    final double cardWidth = isNarrow ? 350.0 : 520.0;
    final double cardHeight = isNarrow ? 430.0 : 470.0;

    return Container(
      width: cardWidth,
      constraints: BoxConstraints(minHeight: cardHeight),
      padding: EdgeInsets.symmetric(
        horizontal: 22.0 * ratio,
        vertical: 24.0 * ratio,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0 * ratio),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 24.0,
            offset: Offset(0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            character,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isNarrow ? 118.0 : 142.0,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF102B4C),
              height: 1.0,
              shadows: const <Shadow>[
                Shadow(
                  color: Color(0x22000000),
                  blurRadius: 5.0,
                  offset: Offset(2.0, 3.0),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.0 * ratio),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: const Color(0xFF8EA2B8),
            size: 42.0 * ratio,
          ),
          SizedBox(height: 12.0 * ratio),
          _ComponentLayout(
            character: character,
            components: components,
            ratio: ratio,
          ),
          if (ruleName == 'Components Only' || ruleName == 'Keep Crossed Strokes')
            Padding(
              padding: EdgeInsets.only(top: 18.0 * ratio),
              child: Text(
                ruleName == 'Components Only'
                    ? 'Break into components, not individual strokes.'
                    : 'Keep crossed strokes together.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.0 * ratio,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF6C7686),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ComponentLayout extends StatelessWidget {
  const _ComponentLayout({
    required this.character,
    required this.components,
    required this.ratio,
  });

  final String character;
  final List<String> components;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    if (character == '否') {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _SmallComponentChip(label: components[0], number: 1, color: const Color(0xFF58D84D), ratio: ratio),
          SizedBox(height: 12.0 * ratio),
          _SmallComponentChip(label: components[1], number: 2, color: const Color(0xFFFFC928), ratio: ratio),
        ],
      );
    }

    if (character == '程' || character == '想') {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _SmallComponentChip(label: components[0], number: 1, color: const Color(0xFF58D84D), ratio: ratio),
              SizedBox(width: 14.0 * ratio),
              _SmallComponentChip(label: components[1], number: 2, color: const Color(0xFFFFC928), ratio: ratio),
            ],
          ),
          SizedBox(height: 14.0 * ratio),
          _SmallComponentChip(label: components[2], number: 3, color: const Color(0xFF2196F3), ratio: ratio),
        ],
      );
    }

    if (character == '十') {
      return _SmallComponentChip(
        label: components[0],
        number: 1,
        color: const Color(0xFF58D84D),
        ratio: ratio,
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 14.0 * ratio,
      runSpacing: 14.0 * ratio,
      children: <Widget>[
        for (int i = 0; i < components.length; i++)
          _SmallComponentChip(
            label: components[i],
            number: i + 1,
            color: i == 0
                ? const Color(0xFF58D84D)
                : i == 1
                ? const Color(0xFFFFC928)
                : const Color(0xFF2196F3),
            ratio: ratio,
          ),
      ],
    );
  }
}

class _SmallComponentChip extends StatelessWidget {
  const _SmallComponentChip({
    required this.label,
    required this.number,
    required this.color,
    required this.ratio,
  });

  final String label;
  final int number;
  final Color color;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          width: 92.0 * ratio,
          height: 82.0 * ratio,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0 * ratio),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Colors.white.withOpacity(0.42), color],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: color.withOpacity(0.28),
                blurRadius: 15.0 * ratio,
                offset: Offset(0, 8.0 * ratio),
              ),
              const BoxShadow(
                color: Color(0x16000000),
                blurRadius: 7.0,
                offset: Offset(3.0, 5.0),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 42.0 * ratio,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF102B4C),
              shadows: const <Shadow>[
                Shadow(
                  color: Color(0x22000000),
                  blurRadius: 3.0,
                  offset: Offset(1.5, 2.0),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: -8.0 * ratio,
          top: -10.0 * ratio,
          child: Container(
            width: 32.0 * ratio,
            height: 32.0 * ratio,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(color: Colors.white.withOpacity(0.75), width: 2.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 6.0,
                  offset: Offset(0, 3.0),
                ),
              ],
            ),
            child: Text(
              '$number',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0 * ratio,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
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
        children: <Widget>[
          Container(
            width: 112.0,
            height: 104.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(22.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: color.withOpacity(0.38),
                  blurRadius: 18.0,
                  offset: const Offset(0, 10.0),
                ),
                const BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 8.0,
                  offset: Offset(4.0, 6.0),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.white.withOpacity(0.35), color],
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 54.0,
                fontWeight: FontWeight.w900,
                color: Color(0xFF102B4C),
                shadows: <Shadow>[
                  Shadow(
                    color: Color(0x33000000),
                    blurRadius: 4.0,
                    offset: Offset(2.0, 3.0),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: -10.0,
            top: -14.0,
            child: Container(
              width: 42.0,
              height: 42.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 8.0,
                    offset: Offset(0, 4.0),
                  ),
                ],
                border: Border.all(color: Colors.white.withOpacity(0.7), width: 2.0),
              ),
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21.0,
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
    final Paint paint = Paint()
      ..color = const Color(0xFF8EA2B8)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Path path = Path()
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

    _drawDashedPath(canvas, path, paint, dashLength: 8.0, gapLength: 10.0);
  }

  void _drawDashedPath(
      Canvas canvas,
      Path path,
      Paint paint, {
        required double dashLength,
        required double gapLength,
      }) {
    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double next = distance + dashLength;
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
        borderRadius: BorderRadius.circular(28.0),
        gradient: const RadialGradient(
          center: Alignment(0, -0.28),
          radius: 0.72,
          colors: <Color>[
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
    final double size = small ? 18.0 : 26.0;
    return Icon(Icons.auto_awesome, size: size, color: color);
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420.0),
      child: SizedBox(
        width: double.infinity,
        height: 60.0,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1677FF),
            foregroundColor: Colors.white,
            elevation: 8.0,
            shadowColor: const Color(0x551677FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                text,
                style: const TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 16.0),
              const Icon(Icons.arrow_forward_rounded, size: 29.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    required this.onPrevious,
    required this.onContinue,
    required this.isLast,
  });

  final VoidCallback onPrevious;
  final VoidCallback onContinue;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          onPressed: onPrevious,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF6C7686),
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          ),
          child: const Text(
            'Previous',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 48.0),
        ElevatedButton(
          onPressed: onContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1677FF),
            foregroundColor: Colors.white,
            elevation: 5.0,
            shadowColor: const Color(0x441677FF),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 13.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                isLast ? 'Finish' : 'Continue',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8.0),
              const Icon(Icons.arrow_forward_rounded, size: 21.0),
            ],
          ),
        ),
      ],
    );
  }
}
