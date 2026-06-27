import 'package:flutter/material.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/data/componenttypinglist.dart';
import 'package:hanzishu/utility.dart';

class ComponentCombinationSelectionPage extends StatefulWidget {
  @override
  _ComponentCombinationSelectionPageState createState() => _ComponentCombinationSelectionPageState();
}

class _ComponentCombinationSelectionPageState extends State<ComponentCombinationSelectionPage> {
  double? screenWidth;
  late ScrollController _scrollController;

  static const Color _brandPurple = Color(0xFF5B2DA8);
  static const Color _deepText = Color(0xFF111827);
  static const Color _mutedText = Color(0xFF4B5563);
  static const Color _softBorder = Color(0xFFDCCBFA);
  static const Color _pageTop = Color(0xFFFAF7FF);
  static const Color _pageBottom = Color(0xFFFFFFFF);

  static const List<Color> _accentColors = <Color>[
    Color(0xFF1E88E5), // blue
    Color(0xFF35A915), // green
    Color(0xFF7B48D9), // purple
    Color(0xFFF57C00), // orange
    Color(0xFF0097A7), // teal
    Color(0xFF8E4EDB), // violet
    Color(0xFF009B9B), // cyan
    Color(0xFFFF4F70), // pink/red
    Color(0xFF2F7FE5), // blue
    Color(0xFF39A826), // green
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth!);
  }

  double getUiRatio() {
    final ratio = getSizeRatioWithLimit();
    if (ratio < 0.86) {
      return 0.86;
    }
    if (ratio > 1.0) {
      return 1.0;
    }
    return ratio;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);
    final ui = getUiRatio();

    return Scaffold(
      backgroundColor: _pageBottom,
      appBar: AppBar(
        title: Text(
          getString(529), //"Basic Exercises",
          style: TextStyle(
            color: _deepText,
            fontSize: 36 * ui,
            fontWeight: FontWeight.w800,
            height: 1.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: _deepText,
        toolbarHeight: 78 * ui,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 18 * ui),
            child: _buildHelpButton(ui),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
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
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: WillPopScope(
            child: getExerciseSelection(context),
            onWillPop: _onWillPop,
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return Future.value(true);
  }

  Widget getExerciseSelection(BuildContext context) {
    final ui = getUiRatio();

    return Stack(
      children: [
        Positioned(
          left: -55 * ui,
          top: 82 * ui,
          child: _buildSoftBlob(
            size: 128 * ui,
            color: Color(0xFFFFF0C8),
          ),
        ),
        Positioned(
          right: -72 * ui,
          top: 18 * ui,
          child: _buildSoftBlob(
            size: 170 * ui,
            color: Color(0xFFF1E6FF),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            44 * ui,
            22 * ui,
            44 * ui,
            32 * ui,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1280 * ui),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildIntroRow(ui),
                  SizedBox(height: 30 * ui),
                  _buildExerciseGrid(context, ui),
                  SizedBox(height: 28 * ui),
                  _buildBottomTip(ui),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHelpButton(double ui) {
    return Container(
      width: 56 * ui,
      height: 56 * ui,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18 * ui),
        border: Border.all(
          color: _softBorder,
          width: 1.5 * ui,
        ),
      ),
      child: Icon(
        Icons.help_outline_rounded,
        color: _brandPurple,
        size: 30 * ui,
      ),
    );
  }

  Widget _buildIntroRow(double ui) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool narrow = constraints.maxWidth < 620;

        final icon = _buildLearningIcon(ui);
        final divider = Container(
          width: 2 * ui,
          height: narrow ? 0 : 76 * ui,
          color: _softBorder,
        );
        final subtitle = Text(
          "Practice typing characters using only\n2–3 letters.",
          textAlign: narrow ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            color: _mutedText,
            fontSize: 21 * ui,
            fontWeight: FontWeight.w500,
            height: 1.28,
          ),
        );

        if (narrow) {
          return Column(
            children: [
              icon,
              SizedBox(height: 12 * ui),
              subtitle,
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            SizedBox(width: 28 * ui),
            divider,
            SizedBox(width: 28 * ui),
            Flexible(
              child: subtitle,
            ),
          ],
        );
      },
    );
  }

  Widget _buildLearningIcon(double ui) {
    return SizedBox(
      width: 170 * ui,
      height: 92 * ui,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 13 * ui,
            child: Container(
              width: 135 * ui,
              height: 35 * ui,
              decoration: BoxDecoration(
                color: _brandPurple.withOpacity(0.09),
                borderRadius: BorderRadius.circular(30 * ui),
              ),
            ),
          ),
          Positioned(
            left: 44 * ui,
            top: 14 * ui,
            child: Transform.rotate(
              angle: -0.12,
              child: _buildMiniShape(Color(0xFFEAF6FF), ui),
            ),
          ),
          Positioned(
            left: 78 * ui,
            top: 8 * ui,
            child: Transform.rotate(
              angle: 0.10,
              child: _buildMiniShape(Color(0xFFF0FFE8), ui),
            ),
          ),
          Positioned(
            left: 64 * ui,
            top: 42 * ui,
            child: Transform.rotate(
              angle: -0.02,
              child: _buildMiniShape(Color(0xFFF0E6FF), ui),
            ),
          ),
          Positioned(
            left: 18 * ui,
            top: 22 * ui,
            child: _buildSparkle(Color(0xFFC4A6F5), 18 * ui),
          ),
          Positioned(
            right: 18 * ui,
            bottom: 18 * ui,
            child: _buildSparkle(Color(0xFFFFA940), 16 * ui),
          ),
          Positioned(
            left: 28 * ui,
            bottom: 18 * ui,
            child: _buildDot(Color(0xFF14B8C9), 9 * ui),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniShape(Color color, double ui) {
    return Container(
      width: 45 * ui,
      height: 45 * ui,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(11 * ui),
        border: Border.all(
          color: _softBorder.withOpacity(0.95),
          width: 1.6 * ui,
        ),
      ),
    );
  }

  Widget _buildExerciseGrid(BuildContext context, double ui) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 2;
        if (constraints.maxWidth >= 980 * ui) {
          columns = 5;
        }
        else if (constraints.maxWidth >= 720 * ui) {
          columns = 4;
        }
        else if (constraints.maxWidth >= 520 * ui) {
          columns = 3;
        }

        final spacing = 18.0 * ui;
        final rawCardWidth = (constraints.maxWidth - spacing * (columns - 1)) / columns;
        final maxCardWidth = columns == 5 ? 190.0 * ui : 210.0 * ui;
        final cardWidth = rawCardWidth > maxCardWidth ? maxCardWidth : rawCardWidth;
        final cardHeight = cardWidth * 0.78;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.center,
          children: List.generate(
            10,
                (id) => SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: getStartExercise(context, id, ui),
            ),
          ),
        );
      },
    );
  }

  Widget getStartExercise(BuildContext context, int id, double ui) {
    final item = theComponentCombinationCharsList[id];
    final accent = _accentColors[id % _accentColors.length];

    String displayLabel = item.letter1 + " " + item.letter2;
    String nextLabel = item.letter1 + ", " + item.letter2;
    if (item.letter3.length != 0) {
      displayLabel += " " + item.letter3;
      nextLabel += ", " + item.letter3;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16 * ui),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InputZiPage(
                typingType: TypingType.ComponentCombinationTyping,
                lessonId: id,
                wordsStudy: nextLabel,
                isSoundPrompt: false,
                inputMethod: InputMethod.Pinxin,
                showHint: HintType.Hint1,
                includeSkipSection: false,
                showSwitchMethod: false,
              ),
            ),
          );
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16 * ui),
            border: Border.all(
              color: _softBorder,
              width: 1.3 * ui,
            ),
            boxShadow: [
              BoxShadow(
                color: _brandPurple.withOpacity(0.08),
                blurRadius: 12 * ui,
                offset: Offset(0, 6 * ui),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: 86 * ui,
                  height: 86 * ui,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.11),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 21 * ui,
                left: 20 * ui,
                child: _buildSparkle(accent.withOpacity(0.58), 18 * ui),
              ),
              Positioned(
                top: 27 * ui,
                right: 22 * ui,
                child: _buildDot(accent.withOpacity(0.28), 13 * ui),
              ),
              Positioned(
                bottom: 24 * ui,
                left: 22 * ui,
                child: _buildDot(accent.withOpacity(0.28), 12 * ui),
              ),
              Positioned(
                bottom: 22 * ui,
                right: 24 * ui,
                child: _buildSparkle(accent.withOpacity(0.56), 18 * ui),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10 * ui),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      displayLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: accent,
                        fontSize: 37 * ui,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 3.5 * ui,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomTip(double ui) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20 * ui,
        vertical: 9 * ui,
      ),
      decoration: BoxDecoration(
        color: _brandPurple.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18 * ui),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: _brandPurple,
            size: 22 * ui,
          ),
          SizedBox(width: 10 * ui),
          Text(
            "Each exercise uses only the letters shown above.",
            style: TextStyle(
              color: _mutedText,
              fontSize: 14.5 * ui,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSparkle(Color color, double size) {
    return IgnorePointer(
      child: Icon(
        Icons.auto_awesome,
        color: color,
        size: size,
      ),
    );
  }

  Widget _buildDot(Color color, double size) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildSoftBlob({required double size, required Color color}) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.68,
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
}
