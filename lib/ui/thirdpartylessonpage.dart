import 'package:flutter/material.dart';
import 'package:hanzishu/data/thirdpartylessonlist.dart';
import 'dart:async';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/engine/thirdpartylesson.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/ui/wordlaunchpage.dart';
import 'package:hanzishu/engine/studywords.dart';

class ThirdPartyLessonPage extends StatefulWidget {
  //final int lessonId;
  final ThirdPartyType thirdPartyType;

  ThirdPartyLessonPage({required this.thirdPartyType});

  @override
  _ThirdPartyLessonPageState createState() => _ThirdPartyLessonPageState();
}

class _ThirdPartyLessonPageState extends State<ThirdPartyLessonPage> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late ThirdPartyType thirdPartyType;
  int currentLessonId = -1;
  int currentLevelId = -1;

  late double screenWidth;

  static const Color _deepText = Color(0xFF1F1B2D);
  static const Color _mutedText = Color(0xFF6F6284);
  static const Color _brandPurple = Color(0xFF6A35B8);
  static const Color _softPurple = Color(0xFFE5D7FA);
  static const Color _pageTop = Color(0xFFFBF7FF);
  static const Color _pageBottom = Color(0xFFFFFFFF);
  static const Color _blue = Color(0xFF2F6BFF);
  static const Color _green = Color(0xFF2F8F25);
  static const Color _orange = Color(0xFFFF8A00);

  getSizeRatio() {
    var defaultFontSize = screenWidth / 16;
    return defaultFontSize / 25.0; // ratio over original hard coded value
  }

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();
    currentLevelId = 0;

    _scrollController = ScrollController()
      ..addListener(() {
      });

    thirdPartyType = widget.thirdPartyType;

    //setState(() {
    //});
  }

  @override
  void dispose() {
    _scrollController.dispose(); // it is a good practice to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    thePositionManager.setFrameWidth(screenWidth - 10.0);

    return Scaffold(
      backgroundColor: _pageBottom,
      appBar: AppBar(
        title: Text(
          "Ty & Od Textbook Typing",
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
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: WillPopScope(   // just for removing overlay on detecting back arrow
            child: getColumn(),
            onWillPop: _onWillPop,
          ),
        ),
      ),
    );
  }

  Widget getColumn() {
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
              _buildTextbookPanel(ratio),
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

        final textColumn = Column(
          crossAxisAlignment:
          isNarrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Practice typing with lessons from the",
              textAlign: isNarrow ? TextAlign.center : TextAlign.start,
              style: TextStyle(
                color: _mutedText,
                fontSize: 14.5 * ratio,
                fontWeight: FontWeight.w700,
                height: 1.28,
              ),
            ),
            Text(
              "Ty & Od Chinese textbooks.",
              textAlign: isNarrow ? TextAlign.center : TextAlign.start,
              style: TextStyle(
                color: _mutedText,
                fontSize: 14.5 * ratio,
                fontWeight: FontWeight.w700,
                height: 1.28,
              ),
            ),
          ],
        );

        final bookIllustration = _buildBookIllustration(ratio);

        if (isNarrow) {
          return Padding(
            padding: EdgeInsets.only(bottom: 2 * ratio),
            child: Column(
              children: [
                bookIllustration,
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
              bookIllustration,
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

  Widget _buildBookIllustration(double ratio) {
    return SizedBox(
      width: 132 * ratio,
      height: 74 * ratio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 0,
            top: 3 * ratio,
            child: _buildSparkle(_brandPurple.withOpacity(0.40), 12 * ratio),
          ),
          Positioned(
            left: 4 * ratio,
            bottom: 12 * ratio,
            child: _buildSparkle(Color(0xFF18B7C8), 8 * ratio),
          ),
          Positioned(
            bottom: 6 * ratio,
            child: _buildBookLayer(
              width: 100 * ratio,
              height: 18 * ratio,
              color: Color(0xFFFF8A00),
              angle: -0.03,
              ratio: ratio,
            ),
          ),
          Positioned(
            bottom: 24 * ratio,
            child: _buildBookLayer(
              width: 94 * ratio,
              height: 18 * ratio,
              color: Color(0xFF72C93A),
              angle: 0.02,
              ratio: ratio,
            ),
          ),
          Positioned(
            bottom: 42 * ratio,
            child: _buildBookLayer(
              width: 88 * ratio,
              height: 18 * ratio,
              color: Color(0xFF8A5CF6),
              angle: -0.02,
              ratio: ratio,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookLayer({required double width, required double height, required Color color, required double angle, required double ratio}) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5 * ratio),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.22),
              blurRadius: 8 * ratio,
              offset: Offset(0, 4 * ratio),
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 24 * ratio,
            height: height * 0.52,
            margin: EdgeInsets.only(right: 6 * ratio),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.72),
              borderRadius: BorderRadius.circular(3 * ratio),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextbookPanel(double ratio) {
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
        children: getLevelAndLessonList(thirdPartyType, ratio),
      ),
    );
  }

  List<Widget> getLevelAndLessonList(ThirdPartyType thirdPartyType, double ratio) {
    List<Widget> listOfWidget = [];

    int? previousLevelId;
    bool firstSection = true;

    for (int i = 0; i < theThirdPartyLessonList.length; i++) {
      if (theThirdPartyLessonList[i].thirdPartyType == thirdPartyType) {
        int levelId = theThirdPartyLessonList[i].levelId;

        if (previousLevelId != levelId) {
          if (!firstSection) {
            listOfWidget.add(SizedBox(height: 18 * ratio));
            listOfWidget.add(_buildSectionDivider(ratio));
            listOfWidget.add(SizedBox(height: 12 * ratio));
          }

          var levelName = ThirdPartyLevel.getLevelName(
            thirdPartyType,
            theThirdPartyLessonList[i].version,
            levelId,
          );

          listOfWidget.add(
            _buildTextbookHeader(
              levelName!,
              levelId,
              _getSectionColor(levelId),
              ratio,
            ),
          );

          if (currentLevelId == levelId) {
            listOfWidget.add(SizedBox(height: 14 * ratio));
            listOfWidget.add(_buildLessonGrid(thirdPartyType, levelId, ratio));
          }

          previousLevelId = levelId;
          firstSection = false;
        }
      }
    }

    return listOfWidget;
  }

  Widget _buildTextbookHeader(String levelName, int levelId, Color sectionColor, double ratio) {
    final bool isExpanded = currentLevelId == levelId;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16 * ratio),
        onTap: () {
          setState(() {
            if (currentLevelId == levelId) {
              currentLevelId = -1;
            }
            else {
              currentLevelId = levelId;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 4 * ratio,
            vertical: 4 * ratio,
          ),
          child: Row(
            children: [
              Container(
                width: 40 * ratio,
                height: 40 * ratio,
                decoration: BoxDecoration(
                  color: sectionColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: sectionColor,
                  size: 24 * ratio,
                ),
              ),
              SizedBox(width: 12 * ratio),
              Expanded(
                child: Text(
                  levelName,
                  style: TextStyle(
                    color: sectionColor,
                    fontSize: 18 * ratio,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(
                isExpanded ? Icons.keyboard_arrow_down_rounded : Icons.chevron_right_rounded,
                color: sectionColor,
                size: 28 * ratio,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonGrid(ThirdPartyType thirdPartyType, int levelId, double ratio) {
    List<int> lessonIndexes = [];

    for (int i = 0; i < theThirdPartyLessonList.length; i++) {
      if (theThirdPartyLessonList[i].thirdPartyType == thirdPartyType &&
          theThirdPartyLessonList[i].levelId == levelId) {
        lessonIndexes.add(i);
      }
    }

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
          children: lessonIndexes.map((lessonIndex) {
            return SizedBox(
              width: cardWidth,
              child: _buildLessonCard(context, lessonIndex, _getSectionColor(levelId), ratio),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildLessonCard(BuildContext context, int lessonListIndex, Color sectionColor, double ratio) {
    final lesson = theThirdPartyLessonList[lessonListIndex];
    final lessonName = ThirdPartyLesson.getLessonName(
      thirdPartyType,
      lesson.version,
      lesson.lessonId,
    );

    final parts = _splitLessonLabel(lessonName!);
    final lessonNumber = parts[0];
    final lessonTitle = parts[1];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12 * ratio),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WordLaunchPage(
                drillCategory: DrillCategory.custom,
                subItemId: lessonListIndex + 1,
                customString: ThirdPartyLesson.getLessonString(thirdPartyType, lesson.lessonId),
                thirdPartyType: thirdPartyType,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(
            16 * ratio,
            11 * ratio,
            12 * ratio,
            11 * ratio,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12 * ratio),
            border: Border.all(
              color: sectionColor.withOpacity(0.20),
              width: 1.0 * ratio,
            ),
            boxShadow: [
              BoxShadow(
                color: sectionColor.withOpacity(0.08),
                blurRadius: 9 * ratio,
                offset: Offset(0, 4 * ratio),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lessonNumber,
                      style: TextStyle(
                        color: sectionColor,
                        fontSize: 15.5 * ratio,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                    SizedBox(height: 4 * ratio),
                    Text(
                      lessonTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _deepText,
                        fontSize: 14.5 * ratio,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8 * ratio),
              Container(
                width: 28 * ratio,
                height: 28 * ratio,
                decoration: BoxDecoration(
                  color: sectionColor.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: sectionColor,
                  size: 18 * ratio,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _splitLessonLabel(String label) {
    final trimmed = label.trim();
    final match = RegExp(r'^(\d+\.\d+)\s*(.*)$').firstMatch(trimmed);

    if (match != null) {
      final number = match.group(1)!;
      final title = match.group(2)!;
      return [number, title.isEmpty ? trimmed : title];
    }

    return [trimmed, ""];
  }

  Widget _buildSectionDivider(double ratio) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: _softPurple.withOpacity(0.55),
            width: 1,
          ),
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

  Color _getSectionColor(int levelId) {
    if (levelId == 0) {
      return _blue;
    }
    else if (levelId == 1) {
      return _green;
    }
    else {
      return _orange;
    }
  }

  Future<bool> _onWillPop() {
    return Future.value(true);
  }
}
