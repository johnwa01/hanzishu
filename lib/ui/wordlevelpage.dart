

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

// For HSK word level only currently
class WordLevelPage extends StatefulWidget {
  //final int lessonId;
  final DrillCategory drillCategory; //startLessonId;
  final int subItemId; //endLessonId;
  final String customString;
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  PositionAndSize centerPositionAndSizeCache;

  WordLevelPage({this.drillCategory, this.subItemId, this.customString});

  @override
  _WordLevelPageState createState() => _WordLevelPageState();
}

class _WordLevelPageState extends State<WordLevelPage> with SingleTickerProviderStateMixin {
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

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
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
    /*
    int compoundZiCurrentComponentId = -1;
    int compoundZiTotalComponentNum = 0;

    // compound zi is animating.
    if (compoundZiComponentNum > 0) {
      List<String> componentCodes = List<String>();
      if (compoundZiAllComponents == null ||
          compoundZiAllComponents.length == 0) {
        DictionaryManager.getAllComponents(centerZiId, componentCodes);
        DictionaryManager.getComponentIdsFromCodes(
            componentCodes, compoundZiAllComponents);
      }
      //var compList = getAllZiComponents(searchingZiIndex);
      compoundZiTotalComponentNum = compoundZiAllComponents.length;

      if (compoundZiComponentNum == compoundZiTotalComponentNum + 1) {
        // after looping through the compoundZiAllComponents.
        compoundZiCurrentComponentId = centerZiId;
        currentZiListType = ZiListType.searching;
        shouldDrawCenter = true;
      }
      else {
        compoundZiCurrentComponentId =
        compoundZiAllComponents[compoundZiComponentNum - 1];
        currentZiListType = ZiListType.component;
      }
    }
*/
    //screenWidth = Utility.getScreenWidth(context);
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    thePositionManager.setFrameTopEdgeSizeWithRatio(getSizeRatio());

/*
    var imageName = "assets/core/chardrill_eng.png";
    if (theDefaultLocale == "zh_CN") {
      imageName = "assets/core/chardrill_cn.png";
    }
*/

    var title;
    if (drillCategory == DrillCategory.hsk) {
      title = getString(455);
    }
    //else {
    //}

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
            child: Column(
              children: getLevelList(drillCategory),
              /*[
                /
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, //spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 10),
                    //getCategories(context, centerZiId, drillCategory),
                    //SizedBox(width: 10),
                    Text("Test"),
                    SizedBox(width: 10),
                    //Text("Results"),
                    //getSubMenus(context, centerZiId),
                    SizedBox(width: 10),
                    //SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 10),

                InkWell(
                    child: //Column(
                    //children: [
                    Ink.image(
                      image: AssetImage(imageName),
                      width: 170, //130
                      height: 110, //80
                    ),
                    onTap: () => {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>
                              WordLaunchPage(drillCategory: drillCategory,
                                  subItemId: 1, //subItemId,
                                  customString: null))),
                    }
                ),
                SizedBox(height: 30),
              ],
                 */
            ),
            onWillPop: _onWillPop
        ),
      ),
    );
  }

  List<Widget> getLevelList(DrillCategory drillCategory) {
      List<Widget> listOfWidget = [];

      var textButton;

      var level = getString(399);
      var numberOfLevel;
      if (drillCategory == DrillCategory.hsk) {
        numberOfLevel = 7;
      }
      //else if () {
      //  numberOfLevel = ;
      //}

      String levelText;

      for (int i = 0; i < numberOfLevel; i++) {
        if (i == 6) { // last item for level 7/8/9
          levelText = level + " 7/8/9";
        }
        else {
          levelText = level + (i + 1).toString();
        }

        textButton = TextButton(
          style: TextButton.styleFrom(
            textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
          ),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>
                    WordLaunchPage(drillCategory: drillCategory,
                        subItemId: i + 1, //subItemId,
                        customString: null)));
          },
          child: Text(levelText,
              style: TextStyle(color: Colors.brown)), // lightBlue
        );

        listOfWidget.add(textButton);
      }

      // All level combined
      TextButton combinedTextButton = TextButton(
        style: TextButton.styleFrom(
          textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
        ),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>
                  WordLaunchPage(drillCategory: drillCategory,
                      subItemId: 0, //subItemId,
                      customString: null)));
        },
        child: Text(getString(459),
            style: TextStyle(color: Colors.brown)), // lightBlue
      );

      listOfWidget.add(combinedTextButton);


      return listOfWidget;
  }


  Future<bool>_onWillPop() {
    return Future.value(true);
  }
}
