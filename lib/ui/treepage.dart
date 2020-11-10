import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/treepainter.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
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
  OverlayEntry overlayEntry;

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
                children: createHittestButtons(context)
            ),
          ),
        ),
      ),
    );
  }

  showOverlay(BuildContext context, double posiX, double posiY, String meaning) {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }

    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) =>Positioned(
        top: posiY,
        left: posiX,
        child: FlatButton(
          child: Text(meaning, style: TextStyle(fontSize: 20.0),),
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: () {},
        )
      ));
    overlayState.insert(overlayEntry);
  }

  Positioned getPositionedButton(PositionAndSize posiAndSize, int currentZiId, int newCenterZiId) {
    var butt = FlatButton(
      color: Colors.white,
      textColor: Colors.blueAccent,
      onPressed: () {
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
        }
        setState(() {
          centerZiId = newCenterZiId;
        });
      },
      onLongPress: () {
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
        }
        TextToSpeech.speak();
        var meaning = theZiManager.getPinyinAndMeaning(currentZiId);
        showOverlay(context, posiAndSize.transX, posiAndSize.transY, meaning);
      },
      //child: GestureDetector(
      //TODO: couldn't make onLongPressUp work
      //onLongPressUp: () {
      //TextToSpeech.speak();
      //},
      child: Text('', style: TextStyle(fontSize: 20.0),),
      //),
    );

    var posiCenter = Positioned(
        top: posiAndSize.transY,
        left: posiAndSize.transX,
        height: posiAndSize.height,
        width: posiAndSize.width,
        child: butt
    );

    return posiCenter;
  }

  List<Widget> createHittestButtons(BuildContext context) {
    List<Widget> buttons = [];
    TextToSpeech.speak();

    thePositionManager.resetPositionIndex();
    var realGroupMembers = theLessonManager.getRealGroupMembers(centerZiId);
    var totalSideNumberOfZis = theZiManager.getNumberOfZis(realGroupMembers);
    for (var i = 0; i < realGroupMembers.length; i++) {
      var memberZiId = realGroupMembers[i];
      var memberPinyinAndMeaning = theZiManager.getPinyinAndMeaning(memberZiId);
      var positionAndSize = theLessonManager.getPositionAndSize(memberZiId, totalSideNumberOfZis);

      var posi = getPositionedButton(positionAndSize, memberZiId, memberZiId);

      buttons.add(posi);
    }

    if (centerZiId != 1 ) {
      var pinyinAndMeaning = theZiManager.getPinyinAndMeaning(centerZiId);
      var newCenterZiId = theZiManager.getParentZiId(centerZiId);
      var posiAndSize = theLessonManager.getCenterPositionAndSize();

      var posiCenter = getPositionedButton(posiAndSize, centerZiId, newCenterZiId);

      buttons.add(posiCenter);
    }

    return buttons;
  }
}
