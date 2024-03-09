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

class ThirdPartyLessonPage extends StatefulWidget {
  //final int lessonId;
  final ThirdPartyType thirdPartyType;

  ThirdPartyLessonPage({this.thirdPartyType});

  @override
  _ThirdPartyLessonPageState createState() => _ThirdPartyLessonPageState();
}

class _ThirdPartyLessonPageState extends State<ThirdPartyLessonPage> with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  ThirdPartyType thirdPartyType;
  int currentLessonId;
  int currentLevelId;

  double screenWidth;

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

    var title = ThirdParty.getThirdPartyName(thirdPartyType);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(title),
      ),
      body: Container(
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: WillPopScope(   // just for removing overlay on detecting back arrow
              child: getColumn(),
              onWillPop: _onWillPop
          ),
        ),
      ),
    );
  }

  Widget getColumn() {
    double fontSize1 = TheConst.fontSizes[1];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: getLevelAndLessonList(thirdPartyType),
    );
  }

  List<Widget> getLevelAndLessonList(ThirdPartyType thirdPartyType) {
    List<Widget> listOfWidget = [];

    var textButton;
    int levelIndex = 0;

    for (int i = 0; i < theThirdPartyLessonList.length; i++) {
      if (theThirdPartyLessonList[i].thirdPartyType == thirdPartyType) {
        if (theThirdPartyLessonList[i].levelId != levelIndex) {
          var levelName = ThirdPartyLevel.getLevelName(theThirdPartyLessonList[i].levelId);
          textButton = TextButton(
            style: TextButton.styleFrom(
              textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
            ),
            onPressed: () {
              setState(() {
                if (currentLevelId == theThirdPartyLessonList[i].levelId) {
                  currentLevelId = 0;
                }
                else {
                  currentLevelId = theThirdPartyLessonList[i].levelId;
                }
              });
            },
            child: Text(levelName,
                style: TextStyle(color: Colors.brown)), // lightBlue
          );

          levelIndex = theThirdPartyLessonList[i].levelId;
          listOfWidget.add(textButton);
        }

        if (theThirdPartyLessonList[i].levelId == currentLevelId) {
          var lessonName = ThirdPartyLesson.getLessonName(theThirdPartyLessonList[i].lessonId);
          textButton = TextButton(
            style: TextButton.styleFrom(
              textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>
                      WordLaunchPage(drillCategory: DrillCategory.custom,
                          subItemId: i + 1, //subItemId,
                          customString: ThirdPartyLesson.getLessonString(thirdPartyType, theThirdPartyLessonList[i].lessonId)/*"好替身"*/)));
            },
            child: Text("                   " + lessonName, // add some back space from level
                style: TextStyle(color: Colors.black)), // lightBlue
          );

          listOfWidget.add(textButton);
        }
      }
    }

    return listOfWidget;
  }


  Future<bool>_onWillPop() {
    return Future.value(true);
  }
}