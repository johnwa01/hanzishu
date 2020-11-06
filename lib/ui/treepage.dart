import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/treepainter.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/texttospeech.dart';
//import 'package:flutter_tts/flutter_tts.dart';
//import 'package:url_launcher/url_launcher.dart';

class TreePage extends StatefulWidget {
  final int lessonId;
  TreePage({this.lessonId});

  @override
  _TreePageState createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  int centerZiId;
  double screenWidth;

  @override
  void initState() {
    super.initState();
    //theLessonList[theCurrentLessonId].populateTreeMap(1);

    setState(() {
      centerZiId = theCurrentCenterZiId;
    });
  }

  /*
  double screenHeight(BuildContext context, {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) / dividedBy;
  }
  double screenHeightExcludingToolbar(BuildContext context, {double dividedBy = 1}) {
    return screenHeight(context, dividedBy: dividedBy, reducedBy: kToolbarHeight);
  }
  */

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Tree Page"),
      ),
      body: Container(
        //height: 200.0,
        //width: 200.0,
        child: CustomPaint(
          foregroundPainter: TreePainter(
              lineColor: Colors.amber,
              completeColor: Colors.blueAccent,
              centerId: centerZiId,
              //completePercent: percentage,
              width: screenWidth
          ),
          child: Center(
            child: Stack(
                children: createHittestButtons()
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> createHittestButtons() {
    List<Widget> buttons = [];
    TextToSpeech.speak();

    thePositionManager.resetPositionIndex();
    var realGroupMembers = theLessonManager.getRealGroupMembers(centerZiId);
    var totalSideNumberOfZis = theZiManager.getNumberOfZis(realGroupMembers);
    for (var i = 0; i < realGroupMembers.length; i++) {
      var memberZiId = realGroupMembers[i];
      var memberPinyinAndMeaning = theZiManager.getPinyinAndMeaning(memberZiId);
      var button = Tooltip(message: memberPinyinAndMeaning, preferBelow: false, child: FlatButton(
          child: Text('', style: TextStyle(fontSize: 20.0),),
          color: Colors.white,
          textColor: Colors.blueAccent,
          onPressed: () {
            setState(() {
              centerZiId = memberZiId;
            });
          }));

      var positionAndSize = theLessonManager.getPositionAndSize(memberZiId, totalSideNumberOfZis);
      var posi = Positioned(
          top: positionAndSize.transY,
          left: positionAndSize.transX,
          height: positionAndSize.height,
          width: positionAndSize.width,
          child: button
      );

      buttons.add(posi);
    }

    if (centerZiId != 1 ) {
      var pinyinAndMeaning = theZiManager.getPinyinAndMeaning(centerZiId);
      var parentId = theZiManager.getParentZiId(centerZiId);
      var butt = Tooltip(message: pinyinAndMeaning, preferBelow: false, child: FlatButton(
          child: Text('', style: TextStyle(fontSize: 20.0),),
          color: Colors.white,
          textColor: Colors.blueAccent,
          onPressed: () {
            setState(() {
              centerZiId = parentId;
            });
          }));
      var posiAndSize = theLessonManager.getCenterPositionAndSize();
      var posiCenter = Positioned(
          top: posiAndSize.transY,
          left: posiAndSize.transX,
          height: posiAndSize.height,
          width: posiAndSize.width,
          child: butt
      );

      buttons.add(posiCenter);
    }

    return buttons;
  }
}
