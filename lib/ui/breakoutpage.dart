import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/breakoutpainter.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/texttospeech.dart';

class BreakoutPage extends StatefulWidget {
  final int lessonId;
  BreakoutPage({this.lessonId});

  @override
  _BreakoutPageState createState() => _BreakoutPageState();
}

class _BreakoutPageState extends State<BreakoutPage> {
  //int centerZiId;
  double screenWidth;
  OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();
    //theLessonList[theCurrentLessonId].populateBreakoutMap(1);

    //setState(() {
      //centerZiId = theCurrentCenterZiId;
    //});
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
    // init positionmanager frame size
    thePositionManager.setFrameWidth(screenWidth);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Breakout Page"),
      ),
      body: Container(
        //height: 200.0,
        //width: 200.0,
        child: WillPopScope(   // just for removing overlay on detecting back arrow
          child: CustomPaint(
            foregroundPainter: BreakoutPainter(
                lineColor: Colors.amber,
                completeColor: Colors.blueAccent,
                lessonId: widget.lessonId,
                //completePercent: percentage,
                screenWidth: screenWidth
            ),
            child: Center(
              child: Stack(
                  children: createHittestButtons(context)
              ),
            ),
          ),
            onWillPop: _onWillPop
        ),
      ),
    );
  }

  Future<bool>_onWillPop() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }

    return Future.value(true);
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

  Positioned getPositionedButton(int uniqueNumber, PositionAndSize posiAndSize) {
    var id = Utility.getIdFromUniqueNumber(uniqueNumber);

    var butt = FlatButton(
      color: Colors.white,
      textColor: Colors.blueAccent,
      onPressed: () {
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
        }
        //setState(() {
          //centerZiId = newCenterZiId;
        //});
      },
      onLongPress: () {
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
        }
        TextToSpeech.speak("'你好'");  //TODO
        var meaning = theZiManager.getPinyinAndMeaning(id);
        showOverlay(context, posiAndSize.transX, posiAndSize.transY, meaning);
      },
      child: Text('', style: TextStyle(fontSize: 20.0),),
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
    TextToSpeech.speak('你好');

    var breakoutPositions = theLessonManager.getBreakoutPositions(widget.lessonId);
    if (breakoutPositions.length == 0) {
      var painter = BreakoutPainter();
      breakoutPositions = painter.getBreakoutPositions(widget.lessonId);
    }

    breakoutPositions.forEach((uniqueNumber, position) =>
      buttons.add(getPositionedButton(uniqueNumber, position)));

    return buttons;
  }

}
