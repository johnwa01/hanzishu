import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/reviewpainter.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/ui/basepainter.dart';

//import 'package:flutter_tts/flutter_tts.dart';
//import 'package:url_launcher/url_launcher.dart';

class ReviewPage extends StatefulWidget {
  //final int lessonId;
  final int startLessonId;
  final int endLessonId;
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  PositionAndSize centerPositionAndSizeCache;

  ReviewPage({this.startLessonId, this.endLessonId});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int centerZiId;
  double screenWidth;
  OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();
    //theLessonList[theCurrentLessonId].populateReviewMap(1);

    theCurrentCenterZiId = 1;
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
        title: Text("Review Page"),
      ),
      body: Container(
        child: WillPopScope(   // just for removing overlay on detecting back arrow
          //height: 200.0,
          //width: 200.0,
            child: CustomPaint(
              foregroundPainter: ReviewPainter(
                  Colors.amber,
                  Colors.blueAccent,
                  centerZiId,
                  screenWidth,
                  widget.startLessonId,
                  widget.endLessonId,
                  widget.sidePositionsCache,
                  widget.realGroupMembersCache,
                  widget.centerPositionAndSizeCache
                /*
                  lineColor: colors.amber,
                  completeColor: Colors.blueAccent,
                  centerId: centerZiId,
                  //completePercent: percentage,
                  width: screenWidth,
                  startLessonId: widget.startLessonId,
                  endLessonId: widget.endLessonId
                 */
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

  Positioned getPositionedButton(PositionAndSize posiAndSize, int currentZiId, int newCenterZiId, bool withAction) {
    //MaterialColor buttonColor = Colors.cyan;
    //if (centerZiId != 1) {
    //  buttonColor = Colors.blueGrey; //Colors.yellow; // cannot be Colors.white since it's not a MaterialColor
    //}

    var butt = FlatButton(
      color: Colors.white, // buttonColor,
      textColor: Colors.blueAccent,
      onPressed: () {
        if (withAction) {
          if (overlayEntry != null) {
            overlayEntry.remove();
            overlayEntry = null;
          }
          setState(() {
            centerZiId = newCenterZiId;
          });
        }
      },
      onLongPress: () {
        if (withAction) {
          if (overlayEntry != null) {
            overlayEntry.remove();
            overlayEntry = null;
          }
          TextToSpeech.speak("'你好'"); //TODO
          var meaning = theZiManager.getPinyinAndMeaning(currentZiId);
          showOverlay(context, posiAndSize.transX, posiAndSize.transY, meaning);
        }
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

  Positioned getPositionedSpeechButton(PositionAndSize posiAndSize, int ziId) {
    var butt = FlatButton(
      onPressed: () {
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
        }

        var zi = theZiManager.getZi(ziId);
        TextToSpeech.speak(zi.char);
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

  Positioned getPositionedDrawBihuaButton(PositionAndSize posiAndSize, int ziId) {
    var butt = FlatButton(
      onPressed: () {
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
        }

        var zi = theZiManager.getZi(ziId);
        TextToSpeech.speak(zi.char);
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

    thePositionManager.resetPositionIndex();

    var realGroupMembers = BasePainter.getRealGroupMembers(centerZiId, widget.startLessonId, widget.endLessonId, widget.realGroupMembersCache);
    var totalSideNumberOfZis = theZiManager.getNumberOfZis(realGroupMembers);
    for (var i = 0; i < realGroupMembers.length; i++) {
      var memberZiId = realGroupMembers[i];
      //var memberPinyinAndMeaning = theZiManager.getPinyinAndMeaning(memberZiId);
      var positionAndSize;
      //if (centerZiId == 1) {
        //var rootZiDisplayIndex = thePositionManager.getRootZiDisplayIndex(memberZiId);
        //positionAndSize = thePositionManager.getReviewRootPositionAndSize(rootZiDisplayIndex);
      //}
      //else {
        positionAndSize = BasePainter.getPositionAndSize(
            memberZiId, totalSideNumberOfZis, widget.sidePositionsCache);
      //}

      var posi = getPositionedButton(positionAndSize, memberZiId, memberZiId, true);

      thePositionManager.updatePositionIndex(memberZiId);
      buttons.add(posi);
    }

    /*
    if (centerZiId == 1) {
      for (var i = 0; i < 26; i++) {
        var indexHasZi = thePositionManager.rootIndexHasZi(i, realGroupMembers);
        if (!indexHasZi) { // draw an empty box
          var positionAndSize = thePositionManager.getReviewRootPositionAndSize(
              i);
          var posi = getPositionedButton(positionAndSize, 0, 0, false);

          //thePositionManager.updatePositionIndex(memberZiId);
          buttons.add(posi);
        }
      }
    }
    */
    //if (centerZiId != 1 ) {
      //var pinyinAndMeaning = theZiManager.getPinyinAndMeaning(centerZiId);
      var newCenterZiId = theZiManager.getParentZiId(centerZiId);
      //var posiAndSize = theLessonManager.getCenterPositionAndSize();
      var posiAndSize = thePositionManager.getPositionAndSizeHelper("m", 1, PositionManager.theBigMaximumNumber);
      var posiCenter = getPositionedButton(posiAndSize, centerZiId, newCenterZiId, true);

      buttons.add(posiCenter);
    //}

    // draw speech icon
    var posiAndSizeSpeech = thePositionManager.getCenterSpeechPosi();
    var speechPosiCenter = getPositionedSpeechButton(posiAndSizeSpeech, centerZiId);
    buttons.add(speechPosiCenter);

    // draw bihua icon
    var posiAndSizeBihua = thePositionManager.getCenterBihuaPosi();
    var drawBihuaPosiCenter = getPositionedDrawBihuaButton(posiAndSizeBihua, centerZiId);
    buttons.add(drawBihuaPosiCenter);

    return buttons;
  }
}
