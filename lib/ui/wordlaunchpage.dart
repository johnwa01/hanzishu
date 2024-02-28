
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

class WordLaunchPage extends StatefulWidget {
  //final int lessonId;
  final DrillCategory drillCategory; //startLessonId;
  final int subItemId; //endLessonId;
  final String customString;
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  PositionAndSize centerPositionAndSizeCache;

  WordLaunchPage({this.drillCategory, this.subItemId, this.customString});

  @override
  _WordLaunchPageState createState() => _WordLaunchPageState();
}

class _WordLaunchPageState extends State<WordLaunchPage> with SingleTickerProviderStateMixin {
  DrillCategory drillCategory; //startLessonId;
  int subItemId; //endLessonId;
  String customString;
  int centerZiId;
  bool shouldDrawCenter;
  double screenWidth;
  int previousZiId = 0;
  bool haveShowedOverlay = true;

  Map<int, bool> allLearnedZis = Map();

  int compoundZiComponentNum = 0;
  List<int> compoundZiAllComponents = [];
  var compoundZiAnimationTimer;

  ZiListType currentZiListType;

  getSizeRatio() {
    var defaultFontSize = screenWidth / 16;
    return defaultFontSize / 25.0; // ratio over original hard coded value
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
    //  theDictionaryManager.InitRealFilterList(DrillCategory.custom, subItemId, subItemId, customString);
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
    screenWidth = Utility.getScreenWidth(context);
    //screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    thePositionManager.setFrameTopEdgeSizeWithRatio(getSizeRatio());

    var title;
    if (drillCategory == DrillCategory.hsk) {
      if (subItemId == 0) {
        title = getString(455) + " - " + getString(459);
      }
      else {
        if (subItemId == 7) {
          title = getString(455) + " " + getString(399) + " 7/8/9";
        }
        else {
          title = getString(455) + " " + getString(399) + subItemId.toString();
        }
      }
    }
    else if (drillCategory == DrillCategory.all) {
      title = getString(395); // 'all 3,800'
    }
    else if (drillCategory == DrillCategory.custom) {
      title = getString(10) + " " + getString(399) + subItemId.toString();
    }

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(title),
      ),
      body: Container(
        child: WillPopScope(   // just for removing overlay on detecting back arrow
          //height: 200.0,
          //width: 200.0,
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                getDrillPageCore(drillCategory),
                SizedBox(height: 30),
                getExamMeaning(drillCategory),
                SizedBox(height: 30),
                getExamSoundToHanzi(drillCategory),
                SizedBox(height: 30),
                getExamSound(drillCategory),
                SizedBox(height: 30),
              ],
            ),
        ),
            onWillPop: _onWillPop
        ),
      )
    );
  }

  Widget getDrillPageCore(drillCategory) {
    if(drillCategory == DrillCategory.custom) {
      return SizedBox(width: 0, height: 0);
    }

    return RawMaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(33),
          ),
          side: BorderSide(color: Colors.blue, width: 0.5)
      ),
      fillColor: Colors.blue.shade100,
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>
                DrillPageCore(drillCategory: drillCategory,
                    startingCenterZiId: 1,
                    subItemId: subItemId,
                    isFromReviewPage: true,
                    customString: customString)));
      },
      child: Text(getString(456), //"Learn Hanzi"
          style: TextStyle(color: Colors.brown)), // lightBlue
    );
  }

  Widget getExamSoundToHanzi(DrillCategory drillCategory) {
    return RawMaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(33),
          ),
          side: BorderSide(color: Colors.blue, width: 0.5)
      ),
      fillColor: Colors.blue.shade100,
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>
                StandardExamPage(drillCategory: drillCategory,
                    subItemId: subItemId,
                    quizCategory: QuizCategory.soundToZi,
                    customString: customString)));
      },
      child: Text(getString(488), //"Test sound to Hanzi"
          style: TextStyle(color: Colors.brown)), // lightBlue
    );
  }

  Widget getExamSound(DrillCategory drillCategory) {
    return RawMaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(33),
          ),
          side: BorderSide(color: Colors.blue, width: 0.5)
      ),
      fillColor: Colors.blue.shade100,
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>
                StandardExamPage(drillCategory: drillCategory,
                    subItemId: subItemId,
                    quizCategory: QuizCategory.ziToSound,
                    customString: customString)));
      },
      child: Text(getString(447), //"Test Hanzi sound"
          style: TextStyle(color: Colors.brown)), // lightBlue
    );
  }

  Widget getExamMeaning(drillCategory) {
    if(drillCategory == DrillCategory.custom) {
      return SizedBox(width: 0, height: 0);
    }

    return RawMaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(33),
          ),
          side: BorderSide(color: Colors.lightBlueAccent, width: 0.5)
      ),
      fillColor: Colors.blue.shade100,
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>
                StandardExamPage(drillCategory: drillCategory,
                    subItemId: subItemId, quizCategory: QuizCategory.meaning)));
      },
      child: Text(getString(448), //"Test Hanzi meaning"
          style: TextStyle(color: Colors.brown)), // lightBlue
    );
  }

  Future<bool>_onWillPop() {
    return Future.value(true);
  }
}
