import 'package:flutter/material.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/data/componenttypinglist.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';


class ComponentExerciseNumber {
  int id;
  String name;
  String title;
  String letter;
  static int totalExercises = 23; // roughly 4 to 30 chars a exercises.

  ComponentExerciseNumber(this.id, this.name, {this.title = '', this.letter = ''});

  static List<ComponentExerciseNumber?> exerciseNumbers = List<ComponentExerciseNumber?>.filled(totalExercises, null);

  static populateInitialNumbers() {
    var onePair;
    var titleString;
    var descriptionString;
    var stringAndCharsPair;
    for (var index = 0; index <= totalExercises - 1; index++) {
      onePair = theComponentCategoryStringIdAndTypingCharsList[index];
      titleString = getString(onePair.stringId);
      descriptionString = titleString + " (" + onePair.letter + ")";
      // Following is the index, not stringId -- different from ComponentCategoryStringIdAndTypingChars
      stringAndCharsPair = ComponentExerciseNumber(
        index,
        descriptionString,
        title: titleString,
        letter: onePair.letter,
      );
      exerciseNumbers[index] = stringAndCharsPair;
    }
  }

  // note: selected ReviewNumber instance has to be the same one as in the list.
  // therefore can't create a new one every time. Otherwise it'll fail with assert.
  static List<ComponentExerciseNumber?> getComponentExerciseNumbers() {
    populateInitialNumbers();
    return exerciseNumbers;
  }
}

class TypingComponentSelectionPage extends StatefulWidget {
  @override
  _TypingSelectionPageState createState() => _TypingSelectionPageState();
}

class _TypingSelectionPageState extends State<TypingComponentSelectionPage> {
  double? screenWidth;

  static const Color _deepText = Color(0xFF1F1B2D);
  static const Color _mutedText = Color(0xFF6F6284);
  static const Color _brandPurple = Color(0xFF6A35B8);
  static const Color _softPurple = Color(0xFFE5D7FA);
  static const Color _pageTop = Color(0xFFFBF7FF);
  static const Color _pageBottom = Color(0xFFFFFFFF);
  static const Color _blue = Color(0xFF2F6BFF);
  static const Color _orange = Color(0xFFFF8A00);

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth!);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);

    return Scaffold(
      backgroundColor: _pageBottom,
      appBar: AppBar(
        title: Text(
          "Component Typing",
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
          right: -62 * ratio,
          top: 18 * ratio,
          child: _buildSoftBlob(
            size: 160 * ratio,
            color: Color(0xFFEFE3FF),
          ),
        ),
        Positioned(
          left: -58 * ratio,
          top: 118 * ratio,
          child: _buildSoftBlob(
            size: 138 * ratio,
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
              _buildComponentPanel(context, ratio),
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
          "Practice typing components\nby their characteristics.",
          textAlign: isNarrow ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: _deepText,
            fontSize: 15.5 * ratio,
            fontWeight: FontWeight.w700,
            height: 1.28,
          ),
        );

        final componentIllustration = _buildComponentIllustration(ratio);

        if (isNarrow) {
          return Padding(
            padding: EdgeInsets.only(bottom: 2 * ratio),
            child: Column(
              children: [
                componentIllustration,
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
              componentIllustration,
              SizedBox(width: 28 * ratio),
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

  Widget _buildComponentIllustration(double ratio) {
    return SizedBox(
      width: 132 * ratio,
      height: 82 * ratio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 6 * ratio,
            top: 5 * ratio,
            child: _buildSparkle(_brandPurple.withOpacity(0.40), 12 * ratio),
          ),
          Positioned(
            left: 5 * ratio,
            bottom: 15 * ratio,
            child: _buildSparkle(Color(0xFF18B7C8), 8 * ratio),
          ),
          Positioned(
            right: 20 * ratio,
            bottom: 14 * ratio,
            child: Transform.rotate(
              angle: 0.10,
              child: Container(
                width: 54 * ratio,
                height: 54 * ratio,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.80),
                  borderRadius: BorderRadius.circular(10 * ratio),
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
                    "木",
                    style: TextStyle(
                      color: _softPurple,
                      fontSize: 32 * ratio,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 26 * ratio,
            bottom: 17 * ratio,
            child: Transform.rotate(
              angle: -0.08,
              child: Container(
                width: 58 * ratio,
                height: 58 * ratio,
                decoration: BoxDecoration(
                  color: Color(0xFF7C4DFF),
                  borderRadius: BorderRadius.circular(10 * ratio),
                  boxShadow: [
                    BoxShadow(
                      color: _brandPurple.withOpacity(0.22),
                      blurRadius: 12 * ratio,
                      offset: Offset(0, 6 * ratio),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "人",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36 * ratio,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentPanel(BuildContext context, double ratio) {
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
          _buildComponentGrid(context, ratio),
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
            color: _blue.withOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.extension_rounded,
            color: _blue,
            size: 24 * ratio,
          ),
        ),
        SizedBox(width: 12 * ratio),
        Expanded(
          child: Text(
            "Components grouped by their characteristics",
            style: TextStyle(
              color: _mutedText,
              fontSize: 13.5 * ratio,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12 * ratio,
            vertical: 7 * ratio,
          ),
          decoration: BoxDecoration(
            color: _brandPurple.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12 * ratio),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.keyboard_rounded,
                color: _brandPurple,
                size: 15 * ratio,
              ),
              SizedBox(width: 6 * ratio),
              Text(
                "23 groups",
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

  Widget _buildComponentGrid(BuildContext context, double ratio) {
    final exerciseNumbers = ComponentExerciseNumber.getComponentExerciseNumbers()
        .whereType<ComponentExerciseNumber>()
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 1;
        if (constraints.maxWidth >= 1040) {
          columns = 4;
        }
        else if (constraints.maxWidth >= 760) {
          columns = 3;
        }
        else if (constraints.maxWidth >= 520) {
          columns = 2;
        }

        final spacing = 14.0 * ratio;
        final cardWidth = (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: exerciseNumbers.map((exerciseNumber) {
            return SizedBox(
              width: cardWidth,
              child: _buildComponentCard(context, exerciseNumber, ratio),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildComponentCard(BuildContext context, ComponentExerciseNumber exerciseNumber, double ratio) {
    final visual = _getComponentVisual(exerciseNumber.letter, exerciseNumber.title);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14 * ratio),
        onTap: () {
          _startExercise(context, exerciseNumber.id);
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(
            12 * ratio,
            12 * ratio,
            12 * ratio,
            12 * ratio,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14 * ratio),
            border: Border.all(
              color: visual.mainColor.withOpacity(0.22),
              width: 1.1 * ratio,
            ),
            boxShadow: [
              BoxShadow(
                color: visual.mainColor.withOpacity(0.08),
                blurRadius: 11 * ratio,
                offset: Offset(0, 5 * ratio),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildLetterBadge(visual, ratio),
              SizedBox(width: 13 * ratio),
              Expanded(
                child: Text(
                  visual.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _deepText,
                    fontSize: 14.8 * ratio,
                    fontWeight: FontWeight.w800,
                    height: 1.16,
                  ),
                ),
              ),
              SizedBox(width: 8 * ratio),
              Container(
                width: 28 * ratio,
                height: 28 * ratio,
                decoration: BoxDecoration(
                  color: visual.mainColor.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: visual.mainColor,
                  size: 21 * ratio,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLetterBadge(_ComponentVisual visual, double ratio) {
    return Container(
      width: 54 * ratio,
      height: 54 * ratio,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * ratio),
        border: Border.all(
          color: visual.mainColor.withOpacity(0.28),
          width: 1.4 * ratio,
        ),
        boxShadow: [
          BoxShadow(
            color: visual.mainColor.withOpacity(0.08),
            blurRadius: 8 * ratio,
            offset: Offset(0, 3 * ratio),
          ),
        ],
      ),
      child: Center(
        child: Text(
          visual.letter.toUpperCase(),
          style: TextStyle(
            color: visual.mainColor,
            fontSize: 38 * ratio,
            fontWeight: FontWeight.w900,
            height: 0.92,
            letterSpacing: -1.1 * ratio,
          ),
        ),
      ),
    );
  }

  _ComponentVisual _getComponentVisual(String letter, String fallbackTitle) {
    final mouth = _ComponentVisual(
      letter: letter,
      title: fallbackTitle,
      group: 'Mouth',
      mainColor: Color(0xFFE83E5A),
      accentColor: Color(0xFFFF9AAE),
      lightColor: Color(0xFFFFEEF2),
      darkColor: Color(0xFF9B1830),
    );
    final legs = _ComponentVisual(
      letter: letter,
      title: fallbackTitle,
      group: 'Legs',
      mainColor: Color(0xFFFF7A1A),
      accentColor: Color(0xFFFFC04D),
      lightColor: Color(0xFFFFF1DF),
      darkColor: Color(0xFF9A4A00),
    );
    final shapes = _ComponentVisual(
      letter: letter,
      title: fallbackTitle,
      group: 'Shape',
      mainColor: Color(0xFF23A66F),
      accentColor: Color(0xFF7ED957),
      lightColor: Color(0xFFEAFBEF),
      darkColor: Color(0xFF167246),
    );
    final strokes = _ComponentVisual(
      letter: letter,
      title: fallbackTitle,
      group: 'Stroke',
      mainColor: Color(0xFF2F6BFF),
      accentColor: Color(0xFF5ED0FF),
      lightColor: Color(0xFFEAF2FF),
      darkColor: Color(0xFF1747A6),
    );

    switch (letter.toUpperCase()) {
      case 'A':
        return legs.copyWith(title: 'Human Legs');
      case 'B':
        return mouth.copyWith(title: 'Up & Down Mouth');
      case 'C':
        return mouth.copyWith(title: 'Right-Open Mouth');
      case 'D':
        return shapes.copyWith(title: 'Kitchen Knife');
      case 'E':
        return strokes.copyWith(title: 'Horizontal Lines');
      case 'F':
        return shapes.copyWith(title: 'Cliff');
      case 'G':
        return shapes.copyWith(title: 'Triangle');
      case 'H':
        return shapes.copyWith(title: 'Grass');
      case 'I':
        return strokes.copyWith(title: 'Vertical Line');
      case 'K':
        return shapes.copyWith(title: 'K Shape');
      case 'L':
        return strokes.copyWith(title: 'L Shape');
      case 'M':
        return legs.copyWith(title: 'Three Legs');
      case 'N':
        return mouth.copyWith(title: 'Bottom-Open Mouth');
      case 'O':
        return mouth.copyWith(title: 'Mouth');
      case 'P':
        return shapes.copyWith(title: 'Ear');
      case 'Q':
        return mouth.copyWith(title: 'Four Mouths');
      case 'R':
        return legs.copyWith(title: 'Left & Right Legs');
      case 'S':
        return mouth.copyWith(title: 'Left-Open Mouth');
      case 'T':
        return shapes.copyWith(title: 'T Shape');
      case 'U':
        return mouth.copyWith(title: 'Top-Open Mouth');
      case 'V':
        return legs.copyWith(title: 'Divided Legs');
      case 'X':
        return legs.copyWith(title: 'Crossed Legs');
      case 'Y':
        return shapes.copyWith(title: 'Y Shape');
      default:
        return shapes.copyWith(title: fallbackTitle);
    }
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

  void _startExercise(BuildContext context, int exerciseId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InputZiPage(
          typingType: TypingType.ComponentTyping,
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
}


class _ComponentVisual {
  final String letter;
  final String title;
  final String group;
  final Color mainColor;
  final Color accentColor;
  final Color lightColor;
  final Color darkColor;

  _ComponentVisual({
    required this.letter,
    required this.title,
    required this.group,
    required this.mainColor,
    required this.accentColor,
    required this.lightColor,
    required this.darkColor,
  });

  _ComponentVisual copyWith({
    String? title,
    String? group,
    Color? mainColor,
    Color? accentColor,
    Color? lightColor,
    Color? darkColor,
  }) {
    return _ComponentVisual(
      letter: letter,
      title: title ?? this.title,
      group: group ?? this.group,
      mainColor: mainColor ?? this.mainColor,
      accentColor: accentColor ?? this.accentColor,
      lightColor: lightColor ?? this.lightColor,
      darkColor: darkColor ?? this.darkColor,
    );
  }
}
