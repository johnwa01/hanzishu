import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/reviewpainter.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/ui/animatedpathpainter.dart';

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

class _ReviewPageState extends State<ReviewPage> with SingleTickerProviderStateMixin {
  int centerZiId;
  bool shouldDrawCenter;
  double screenWidth;
  OverlayEntry overlayEntry;

  AnimationController _controller;
  Map<int, bool> allLearnedZis = Map();

  int compoundZiComponentNum = 0;
  List<int> compoundZiAllComponents = [];
  var compoundZiAnimationTimer;

  void _startAnimation() {
    _controller.stop();
    _controller.reset();
    _controller.forward(from: 0.0).whenComplete(() {
      setState(() {
        _controller.stop();
        _controller.reset();     // when complete, clean the animation drawing.
        shouldDrawCenter = true; // let it redraw the screen with regular center zi.
      });
    });
  }

  void _clearAnimation() {
    _controller.stop();
    _controller.reset();
  }

  @override
  void initState() {
    super.initState();
    //theLessonList[theCurrentLessonId].populateReviewMap(1);

    _controller = new AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    theCurrentCenterZiId = 1;
    setState(() {
      centerZiId = theCurrentCenterZiId;
      shouldDrawCenter = true;
      compoundZiComponentNum = 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

    resetCompoundZiAnimation();
  }

  /*
  double screenHeight(BuildContext context, {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) / dividedBy;
  }
  double screenHeightExcludingToolbar(BuildContext context, {double dividedBy = 1}) {
    return screenHeight(context, dividedBy: dividedBy, reducedBy: kToolbarHeight);
  }
  */

  void resetCompoundZiAnimation() {
    // re-init
    compoundZiComponentNum = 0;
    if (compoundZiAllComponents.length > 0) {
      compoundZiAllComponents.clear(); //removeRange(0, compList.length - 1);
    }

    if (compoundZiAnimationTimer != null) {
      compoundZiAnimationTimer.cancel();
      compoundZiAnimationTimer = null;
    }
  }

  List<int> getAllZiComponents(int id) {
    if (compoundZiAllComponents.length == 0) {
      theZiManager.getAllZiComponents(id, compoundZiAllComponents);
    }

    return compoundZiAllComponents;
  }

  @override
  Widget build(BuildContext context) {
    int compoundZiCurrentComponentId = 0;
    int compoundZiTotalComponentNum = 0;

    // compound zi is animating.
    if (compoundZiComponentNum > 0) {
      var compList = getAllZiComponents(centerZiId);
      compoundZiTotalComponentNum = compList.length;

      if (compoundZiComponentNum == compoundZiTotalComponentNum + 1) {
        compoundZiCurrentComponentId = centerZiId;
        resetCompoundZiAnimation();
      }
      else {
        compoundZiCurrentComponentId = compList[compoundZiComponentNum - 1];
      }
    }

    screenWidth = Utility.getScreenWidth(context);
    var posi = thePositionManager.getCenterZiPosi();

    if (compoundZiComponentNum > 0 && compoundZiComponentNum <= compoundZiTotalComponentNum) {
      compoundZiAnimation();
    }

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Review"),
      ),
      body: Container(
        child: WillPopScope(   // just for removing overlay on detecting back arrow
          //height: 200.0,
          //width: 200.0,
          child: new Stack(
              children: <Widget>[
                new Positioned(
                  child: CustomPaint(
                    foregroundPainter: ReviewPainter(
                      Colors.amber,
                      Colors.blueAccent,
                      centerZiId,
                      shouldDrawCenter,
                      screenWidth,
                      widget.startLessonId,
                      widget.endLessonId,
                      widget.sidePositionsCache,
                      widget.realGroupMembersCache,
                      widget.centerPositionAndSizeCache,
                      allLearnedZis,
                        compoundZiCurrentComponentId,
                    ),
                    child: Center(
                      child: Stack(
                          children: createHittestButtons(context)
                      ),
                    ),
                  ),
                ),
                new Positioned(
                  top: posi.transY, //240,
                  left: posi.transX, //160,
                  height: posi.height, //80,
                  width: posi.width, //80,
                  child: new CustomPaint(
                    foregroundPainter: new AnimatedPathPainter(_controller),
                  ),
                ),
              ],
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

  //NOTE: setState within the Timer so that it'll trigger this function to be called repeatedly.
  void  compoundZiAnimation() {
    const oneSec = const Duration(seconds: 1);
    compoundZiAnimationTimer = new Timer(oneSec, () {     //timeout(oneSec, (Timer t) {   //periodic
      setState(() {
        compoundZiComponentNum += 1;
      });
    });
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
      color: Colors.white, // buttonColor,
      textColor: Colors.blueAccent,
      onPressed: () {
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
        }

        _clearAnimation();
        resetCompoundZiAnimation();

        setState(() {
          centerZiId = newCenterZiId;
          shouldDrawCenter = true;
        });

        var zi = theZiManager.getZi(currentZiId);
        TextToSpeech.speak(zi.char);
      },
      onLongPress: () {
        var partialZiId = theZiManager.getPartialZiId(theCurrentCenterZiId, currentZiId);

        var zi = theZiManager.getZi(partialZiId);
        TextToSpeech.speak(zi.char);

        var meaning = theZiManager.getPinyinAndMeaning(partialZiId);
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

        resetCompoundZiAnimation();

        setState(() {
          shouldDrawCenter = false;
        });

        if (theZiManager.isBasicZi(ziId)) {
          _startAnimation();
        }
        else {
          compoundZiAnimation();
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
    //TextToSpeech.speak('你好');

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

      var posi = getPositionedButton(positionAndSize, memberZiId, memberZiId);

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
      var posiCenter = getPositionedButton(posiAndSize, centerZiId, newCenterZiId);

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

    CreateNavigationHitttestButtons(centerZiId, true, buttons);

    return buttons;
  }

  CreateNavigationHitttestButtons(int centerZiId, bool isFromReviewPage, List<Widget> buttons) {
    var naviMap = PositionManager.getNavigationPathPosi(centerZiId, isFromReviewPage);

    for (var id in naviMap.keys) {
      var posi = getPositionedButton(naviMap[id], id, id);
      buttons.add(posi);
    }
  }
}
