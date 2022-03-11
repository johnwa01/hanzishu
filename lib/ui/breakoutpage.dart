import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/breakoutpainter.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/engine/zimanager.dart';

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
  ScrollController _scrollController;
  int previousZiId = 0;
  bool haveShowedOverlay = true;

  @override
  void initState() {
    super.initState();
    //theLessonList[theCurrentLessonId].populateBreakoutMap(1);
    _scrollController = ScrollController()
      ..addListener(() {
        //print("offset = ${_scrollController.offset}");
    });
    //setState(() {
      //centerZiId = theCurrentCenterZiId;
    //});
  }

  @override
  void dispose() {
    _scrollController.dispose(); // it is a good practice to dispose the controller
    super.dispose();
  }

  /*
  double screenHeight(BuildContext context, {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) / dividedBy;
  }
  double screenHeightExcludingToolbar(BuildContext context, {double dividedBy = 1}) {
    return screenHeight(context, dividedBy: dividedBy, reducedBy: kToolbarHeight);
  }
  */

  double getSizeRatio() {
    var defaultSize = screenWidth / 16.0; // equivalent to the original hardcoded value of 25.0
    return defaultSize / 25.0;
  }

  double applyRatio(double value) {
    return value * getSizeRatio();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);
    // init positionmanager frame size
    thePositionManager.setFrameWidth(screenWidth);

    var painterHeight = MediaQuery.of(context).size.height + 150.0 * getSizeRatio();  // add some buffer at the end

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Character Break Out"),
      ),
      body: Container(
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: WillPopScope(   // just for removing overlay on detecting back arrow
          child: CustomPaint(
            foregroundPainter: BreakoutPainter(
                lineColor: Colors.amber,
                completeColor: Colors.blueAccent,
                lessonId: widget.lessonId,
                //completePercent: percentage,
                screenWidth: screenWidth
            ),
            size: new Size(screenWidth, painterHeight),

            child: Center(
              child: Stack(
                  children: createHittestButtons(context)
              ),
            ),

          ),
            onWillPop: _onWillPop
          ),
        ),

      ),
    );
  }

  initOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
      theDicOverlayEntry = null;
    }
  }

  Future<bool>_onWillPop() {
    initOverlay();

    return Future.value(true);
  }

  showOverlay(BuildContext context, double posiX, double posiY, String meaning) {
    initOverlay();

    var screenWidth = Utility.getScreenWidth(context);
    var adjustedXValue = Utility.adjustOverlayXPosition(posiX, screenWidth);
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) =>Positioned(
            top: posiY,
            left: adjustedXValue,
            child: FlatButton(
              child: Text(meaning, style: TextStyle(fontSize: 20.0 * getSizeRatio()),),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {},
            )
        ));
    overlayState.insert(overlayEntry);
  }

  Positioned getBreakoutPositionedButton(int uniqueNumber, PositionAndSize posiAndSize) {
    var id = Utility.getIdFromUniqueNumber(uniqueNumber);
    var listType = Utility.getListType(uniqueNumber,id);

    var butt = FlatButton(
      color: Colors.white,
      textColor: Colors.blueAccent,
      /*
      onPressed: () {
        initOverlay();

        //setState(() {
          //centerZiId = newCenterZiId;
        //});
      },
      */
      //onLongPress: () {
      onPressed: () {
        initOverlay();

        var scrollOffset = _scrollController.offset;
        var zi = theZiManager.getZi(id);
        TextToSpeech.speak(zi.char);

        if (previousZiId != id || !haveShowedOverlay) {
          var meaning = ZiManager.getOnePinyinAndMeaning(id, listType);
          showOverlay(context, posiAndSize.transX, posiAndSize.transY - scrollOffset, meaning);
          haveShowedOverlay = true;
        }
        else if (haveShowedOverlay) {
          haveShowedOverlay = false;
        }

        previousZiId = id;
      },
      child: Text('', style: TextStyle(fontSize: 20.0),),
    );

    var posiCenter = Positioned(
        top: posiAndSize.transY,
        left: posiAndSize.transX,
        height: posiAndSize.height * 1.3,  // 1.3. for some reason, the hit box is smaller than the char.
        width: posiAndSize.width * 1.3,
        child: butt
    );

    return posiCenter;
  }

  List<Widget> createHittestButtons(BuildContext context) {
    List<Widget> buttons = [];

    var breakoutPositions = theLessonManager.getBreakoutPositions(widget.lessonId);
    if (breakoutPositions.length == 0) {
      //var painter = BreakoutPainter();
      var painter = BreakoutPainter(
          lineColor: Colors.amber,
          completeColor: Colors.blueAccent,
          lessonId: widget.lessonId,
          screenWidth: screenWidth);
      breakoutPositions = painter.getBreakoutPositions(widget.lessonId);
    }

    var painterHeight = MediaQuery.of(context).size.height + 150.0;  // add some buffer at the end
    buttons.add (Container(height: painterHeight, width: screenWidth));  // workaround to avoid infinite space error

    breakoutPositions.forEach((uniqueNumber, position) =>
      buttons.add(getBreakoutPositionedButton(uniqueNumber, position)));

    return buttons;
  }

}
