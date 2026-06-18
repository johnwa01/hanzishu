

import 'package:flutter/material.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/data/componentlist.dart';
import 'package:hanzishu/data/drillmenulist.dart';
import 'dart:ui';
import 'dart:async';
import 'package:hanzishu/engine/quizmanager.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/drillpainter.dart';
import 'package:hanzishu/engine/zi.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/ui/wordlaunchpage.dart';
import 'package:hanzishu/ui/standardexampage.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/ui/drillpagecore.dart';
import 'package:hanzishu/ui/animatedpathpainter.dart';
import 'package:hanzishu/localization/string_en_US.dart';
import 'package:hanzishu/localization/string_zh_CN.dart';
//import 'package:flutter_tts/flutter_tts.dart';
import 'package:hanzishu/ui/privacypolicy.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/engine/thirdpartylesson.dart';


class _HeroPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HeroPill({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.76),
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 17.0, color: const Color(0xFF6D5DF6)),
          const SizedBox(width: 6.0),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4A4658),
            ),
          ),
        ],
      ),
    );
  }
}

// For HSK word level only currently
class WordLevelPage extends StatefulWidget {
  //final int lessonId;
  final DrillCategory drillCategory; //startLessonId;
  final int subItemId; //endLessonId;
  final String customString;
  //final ThirdPartyType thirdPartyType;
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  PositionAndSize? centerPositionAndSizeCache;

  WordLevelPage({required this.drillCategory, required this.subItemId, required this.customString});

  @override
  _WordLevelPageState createState() => _WordLevelPageState();
}

class _WordLevelPageState extends State<WordLevelPage> with SingleTickerProviderStateMixin {
  DrillCategory? drillCategory; //startLessonId;
  int subItemId = -1; //endLessonId;
  String customString = '';
  int centerZiId = -1;
  bool? shouldDrawCenter;
  double? screenWidth;
  int previousZiId = 0;
  bool haveShowedOverlay = true;

  Map<int, bool> allLearnedZis = Map();

  int compoundZiComponentNum = 0;
  List<int> compoundZiAllComponents = [];
  Timer? compoundZiAnimationTimer;

  late ZiListType currentZiListType;

  getSizeRatio() {
    var defaultFontSize = screenWidth! / 16;
    return defaultFontSize / 25.0; // ratio over original hard coded value
  }

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth!);
  }

  @override
  void initState() {
    super.initState();
    //theLessonList[theCurrentLessonId].populateDrillMap(1);

    // should just run once
    // believe initState only runs once, but added a global variable in case LessonPage has run it already.
    if (!theHavePopulatedLessonsInfo) {
      LessonManager.populateLessonsInfo();
      theHavePopulatedLessonsInfo = true;
    }

    drillCategory = widget.drillCategory;
    subItemId = widget.subItemId;
    customString = widget.customString;
    theAllZiLearned = false;

    //if (drillCategory == DrillCategory.custom) {
    //  theDictionaryManager.InitRealFilterList(drillCategory, subItemId, subItemId, customString);
    //}

    theCurrentCenterZiId = 1;
    setState(() {
      centerZiId = theCurrentCenterZiId;
      shouldDrawCenter = true;
      compoundZiComponentNum = 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //screenWidth = Utility.getScreenWidth(context);
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    thePositionManager.setFrameWidth(screenWidth /*- 10.0*/);
    thePositionManager.setFrameTopEdgeSizeWithRatio(getSizeRatio());

    var title;
    if (drillCategory == DrillCategory.hsk) {
      title = getString(455);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Container(
          color: const Color(0xFFFFF8FF),
          width: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 22.0, 20.0, 28.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildHeroCard(),
                    const SizedBox(height: 22.0),
                    _buildLevelGrid(drillCategory!),
                    const SizedBox(height: 18.0),
                    _buildWideLevelCard(
                      drillCategory: drillCategory!,
                      subItemId: 7,
                      title: 'HSK 7-9',
                      countText: '1200 Hanzi',
                      description: 'Advanced proficiency',
                      iconText: '⑦',
                      accentColor: const Color(0xFFE57373),
                    ),
                    const SizedBox(height: 18.0),
                    _buildAllLevelsCard(drillCategory!),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.0),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFE8F3FF),
            Color(0xFFF3E9FF),
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Practice characters by official HSK levels',
            style: TextStyle(
              fontSize: 20.0 * getSizeRatioWithLimit(),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2F2F3A),
            ),
          ),
          const SizedBox(height: 14.0),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: const <Widget>[
              _HeroPill(icon: Icons.menu_book_rounded, text: '3000 Hanzi'),
              _HeroPill(icon: Icons.flag_rounded, text: 'HSK 1-9'),
              _HeroPill(icon: Icons.trending_up_rounded, text: 'Progressive difficulty'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelGrid(DrillCategory drillCategory) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool useTwoColumns = constraints.maxWidth >= 560.0;
        final double spacing = 16.0;
        final double cardWidth = useTwoColumns
            ? (constraints.maxWidth - spacing) / 2.0
            : constraints.maxWidth;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: <Widget>[
            for (int i = 1; i <= 6; i++)
              SizedBox(
                width: cardWidth,
                child: _buildLevelCard(
                  drillCategory: drillCategory,
                  subItemId: i,
                  title: 'HSK $i',
                  countText: '300 Hanzi',
                  iconText: _getCircledNumber(i),
                  accentColor: _getLevelColor(i),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildLevelCard({
    required DrillCategory drillCategory,
    required int subItemId,
    required String title,
    required String countText,
    required String iconText,
    required Color accentColor,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22.0),
      onTap: () => _openLevel(drillCategory, subItemId),
      child: Container(
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.0),
          border: Border.all(color: accentColor.withOpacity(0.26), width: 1.2),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 16.0,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 56.0,
              width: 56.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.13),
                shape: BoxShape.circle,
              ),
              child: Text(
                iconText,
                style: TextStyle(
                  fontSize: 27.0 * getSizeRatioWithLimit(),
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.0 * getSizeRatioWithLimit(),
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2F2F3A),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    countText,
                    style: TextStyle(
                      fontSize: 14.0 * getSizeRatioWithLimit(),
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: accentColor, size: 22.0),
          ],
        ),
      ),
    );
  }

  Widget _buildWideLevelCard({
    required DrillCategory drillCategory,
    required int subItemId,
    required String title,
    required String countText,
    required String description,
    required String iconText,
    required Color accentColor,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24.0),
      onTap: () => _openLevel(drillCategory, subItemId),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: accentColor.withOpacity(0.28), width: 1.2),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 16.0,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 64.0,
              width: 64.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.14),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                iconText,
                style: TextStyle(
                  fontSize: 30.0 * getSizeRatioWithLimit(),
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                ),
              ),
            ),
            const SizedBox(width: 17.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 21.0 * getSizeRatioWithLimit(),
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2F2F3A),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    '$countText · $description',
                    style: TextStyle(
                      fontSize: 14.0 * getSizeRatioWithLimit(),
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: accentColor, size: 24.0),
          ],
        ),
      ),
    );
  }

  Widget _buildAllLevelsCard(DrillCategory drillCategory) {
    const Color accentColor = Color(0xFF7E57C2);

    return InkWell(
      borderRadius: BorderRadius.circular(26.0),
      onTap: () => _openLevel(drillCategory, 0),
      child: Container(
        padding: const EdgeInsets.all(22.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26.0),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFFFFF3E0),
              Color(0xFFF3E5F5),
            ],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18.0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 66.0,
              width: 66.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.82),
                borderRadius: BorderRadius.circular(22.0),
              ),
              child: const Text(
                '★',
                style: TextStyle(
                  fontSize: 32.0,
                  color: accentColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 18.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    getString(459),
                    style: TextStyle(
                      fontSize: 21.0 * getSizeRatioWithLimit(),
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF2F2F3A),
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    '3000 Hanzi · Randomized challenge mode',
                    style: TextStyle(
                      fontSize: 14.0 * getSizeRatioWithLimit(),
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, color: accentColor, size: 24.0),
          ],
        ),
      ),
    );
  }

  Color _getLevelColor(int level) {
    if (level <= 2) {
      return const Color(0xFF43A047);
    }
    if (level <= 4) {
      return const Color(0xFF42A5F5);
    }
    return const Color(0xFFFF9800);
  }

  String _getCircledNumber(int level) {
    switch (level) {
      case 1:
        return '①';
      case 2:
        return '②';
      case 3:
        return '③';
      case 4:
        return '④';
      case 5:
        return '⑤';
      case 6:
        return '⑥';
      default:
        return level.toString();
    }
  }

  void _openLevel(DrillCategory drillCategory, int subItemId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WordLaunchPage(
          drillCategory: drillCategory,
          subItemId: subItemId,
          customString: '',
          thirdPartyType: ThirdPartyType.none,
        ),
      ),
    );
  }

  Future<bool>_onWillPop() {
    return Future.value(true);
  }
}
