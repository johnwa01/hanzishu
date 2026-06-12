import 'package:flutter/material.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';


class ExerciseNumber {
  int id;
  String name;
  static int totalExercises = 38; // roughly 98 chars a exercises.

  ExerciseNumber(this.id, this.name);

  static List<ExerciseNumber?> exerciseNumbers = List<ExerciseNumber?>.filled(totalExercises, null);

  static populateInitialNumbers() {
    if (exerciseNumbers[0] == null) {
      for (var index = 0; index <= totalExercises - 1; index++) {
        var level = ExerciseNumber(index + 1, (index + 1).toString());
        exerciseNumbers[index] = level;
      }
    }
  }

  static List<ExerciseNumber?> getExerciseNumbers() {
    populateInitialNumbers();
    return exerciseNumbers;
  }
}

class TypingSelectionPage extends StatefulWidget {
  @override
  _TypingSelectionPageState createState() => _TypingSelectionPageState();
}

class _TypingSelectionPageState extends State<TypingSelectionPage> {
  late double screenWidth;
  late List<ExerciseNumber?> _exerciseNumbers = ExerciseNumber.getExerciseNumbers();

  static const Color _deepText = Color(0xFF1F1B2D);
  static const Color _mutedText = Color(0xFF6F6284);
  static const Color _brandPurple = Color(0xFF6A35B8);
  static const Color _softPurple = Color(0xFFE5D7FA);
  static const Color _pageTop = Color(0xFFFBF7FF);
  static const Color _pageBottom = Color(0xFFFFFFFF);
  static const Color _orange = Color(0xFFFF8A00);

  @override
  void initState() {
    super.initState();
  }

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);

    return Scaffold(
      backgroundColor: _pageBottom,
      appBar: AppBar(
        title: Text(
          "Commonly Used Hanzi",
          style: TextStyle(
            color: _deepText,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: _deepText,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _pageTop,
              _pageBottom,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: getExerciseSelection(context),
        ),
      ),
    );
  }

  Widget getExerciseSelection(BuildContext context) {
    final ratio = getSizeRatioWithLimit();

    return Stack(
      children: [
        Positioned(
          right: -66 * ratio,
          top: 16 * ratio,
          child: _buildSoftBlob(
            size: 166 * ratio,
            color: Color(0xFFEFE3FF),
          ),
        ),
        Positioned(
          left: -60 * ratio,
          top: 116 * ratio,
          child: _buildSoftBlob(
            size: 136 * ratio,
            color: Color(0xFFFFF0C9),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            28 * ratio,
            14 * ratio,
            28 * ratio,
            34 * ratio,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildIntro(ratio),
              SizedBox(height: 12 * ratio),
              _buildExercisePanel(context, ratio),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIntro(double ratio) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 620;

        final textColumn = Text(
          "Practice typing the most commonly used characters.",
          textAlign: isNarrow ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: _mutedText,
            fontSize: 14.5 * ratio,
            fontWeight: FontWeight.w700,
            height: 1.28,
          ),
        );

        final hanziIllustration = _buildHanziIllustration(ratio);

        if (isNarrow) {
          return Padding(
            padding: EdgeInsets.only(bottom: 2 * ratio),
            child: Column(
              children: [
                hanziIllustration,
                SizedBox(height: 8 * ratio),
                textColumn,
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8 * ratio),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              hanziIllustration,
              SizedBox(width: 24 * ratio),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 430 * ratio),
                  child: textColumn,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHanziIllustration(double ratio) {
    return SizedBox(
      width: 138 * ratio,
      height: 80 * ratio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 10 * ratio,
            top: 18 * ratio,
            child: Transform.rotate(
              angle: 0.08,
              child: Container(
                width: 56 * ratio,
                height: 48 * ratio,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.88),
                  borderRadius: BorderRadius.circular(8 * ratio),
                  boxShadow: [
                    BoxShadow(
                      color: _brandPurple.withOpacity(0.10),
                      blurRadius: 10 * ratio,
                      offset: Offset(0, 5 * ratio),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "字",
                    style: TextStyle(
                      color: _softPurple,
                      fontSize: 28 * ratio,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 22 * ratio,
            top: 10 * ratio,
            child: Transform.rotate(
              angle: -0.08,
              child: Container(
                width: 62 * ratio,
                height: 58 * ratio,
                decoration: BoxDecoration(
                  color: Color(0xFF8A5CF6),
                  borderRadius: BorderRadius.circular(10 * ratio),
                  boxShadow: [
                    BoxShadow(
                      color: _brandPurple.withOpacity(0.24),
                      blurRadius: 12 * ratio,
                      offset: Offset(0, 7 * ratio),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "汉",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30 * ratio,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 6 * ratio,
            top: 18 * ratio,
            child: _buildSparkle(_brandPurple.withOpacity(0.58), 10 * ratio),
          ),
          Positioned(
            right: 0,
            top: 10 * ratio,
            child: _buildSparkle(_brandPurple.withOpacity(0.38), 12 * ratio),
          ),
          Positioned(
            right: 8 * ratio,
            bottom: 16 * ratio,
            child: _buildSparkle(_orange, 9 * ratio),
          ),
          Positioned(
            left: 18 * ratio,
            bottom: 12 * ratio,
            child: _buildDot(_orange.withOpacity(0.75), 3.5 * ratio),
          ),
        ],
      ),
    );
  }

  Widget _buildExercisePanel(BuildContext context, double ratio) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        22 * ratio,
        20 * ratio,
        22 * ratio,
        22 * ratio,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(22 * ratio),
        border: Border.all(
          color: _softPurple.withOpacity(0.70),
          width: 1.2 * ratio,
        ),
        boxShadow: [
          BoxShadow(
            color: _brandPurple.withOpacity(0.07),
            blurRadius: 20 * ratio,
            offset: Offset(0, 9 * ratio),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPanelHeader(ratio),
          SizedBox(height: 18 * ratio),
          _buildExerciseGrid(context, ratio),
        ],
      ),
    );
  }

  Widget _buildPanelHeader(double ratio) {
    return Row(
      children: [
        Container(
          width: 40 * ratio,
          height: 40 * ratio,
          decoration: BoxDecoration(
            color: _orange.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.star_rounded,
            color: _orange,
            size: 24 * ratio,
          ),
        ),
        SizedBox(width: 12 * ratio),
        Expanded(
          child: Text(
            "38 exercises   •   About 100 characters per exercise",
            style: TextStyle(
              color: _mutedText,
              fontSize: 13.5 * ratio,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 13 * ratio,
            vertical: 7 * ratio,
          ),
          decoration: BoxDecoration(
            color: _softPurple.withOpacity(0.42),
            borderRadius: BorderRadius.circular(18 * ratio),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_fire_department_rounded,
                color: _brandPurple,
                size: 16 * ratio,
              ),
              SizedBox(width: 5 * ratio),
              Text(
                "3,800 Hanzi",
                style: TextStyle(
                  color: _brandPurple,
                  fontSize: 12.5 * ratio,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseGrid(BuildContext context, double ratio) {
    final exerciseNumbers = _exerciseNumbers.whereType<ExerciseNumber>().toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 2;
        if (constraints.maxWidth >= 1040) {
          columns = 4;
        }
        else if (constraints.maxWidth >= 760) {
          columns = 4;
        }
        else if (constraints.maxWidth >= 520) {
          columns = 3;
        }

        final spacing = 14.0 * ratio;
        final cardWidth = (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: exerciseNumbers.map((exerciseNumber) {
            return SizedBox(
              width: cardWidth,
              child: _buildExerciseCard(context, exerciseNumber, ratio),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildExerciseCard(BuildContext context, ExerciseNumber exerciseNumber, double ratio) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12 * ratio),
        onTap: () {
          _startExercise(context, exerciseNumber.id);
        },
        child: Container(
          height: 58 * ratio,
          padding: EdgeInsets.fromLTRB(
            18 * ratio,
            9 * ratio,
            13 * ratio,
            9 * ratio,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12 * ratio),
            border: Border.all(
              color: _softPurple.withOpacity(0.90),
              width: 1.0 * ratio,
            ),
            boxShadow: [
              BoxShadow(
                color: _brandPurple.withOpacity(0.07),
                blurRadius: 9 * ratio,
                offset: Offset(0, 4 * ratio),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  exerciseNumber.name,
                  style: TextStyle(
                    color: _brandPurple,
                    fontSize: 24 * ratio,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                ),
              ),
              Container(
                width: 30 * ratio,
                height: 30 * ratio,
                decoration: BoxDecoration(
                  color: _softPurple.withOpacity(0.48),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: _brandPurple,
                  size: 19 * ratio,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startExercise(BuildContext context, int exerciseId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InputZiPage(
          typingType: TypingType.CommonZiTyping,
          lessonId: exerciseId,
          wordsStudy: '',
          isSoundPrompt: false,
          inputMethod: InputMethod.Pinxin,
          showHint: HintType.Hint1,
          includeSkipSection: false,
          showSwitchMethod: false,
        ),
      ),
    );
  }

  Widget _buildSoftBlob({required double size, required Color color}) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.55,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(size * 0.45),
          ),
        ),
      ),
    );
  }

  Widget _buildSparkle(Color color, double size) {
    return Icon(
      Icons.auto_awesome,
      color: color,
      size: size,
    );
  }

  Widget _buildDot(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
