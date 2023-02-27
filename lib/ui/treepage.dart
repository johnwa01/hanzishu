import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/treepainter.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/ui/animatedpathpainter.dart';

class TreePage extends StatefulWidget {
  final int lessonId;
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  PositionAndSize centerPositionAndSizeCache; // = PositionAndSize(0,0,0,0,0,0);

  TreePage({this.lessonId});

  @override
  _TreePageState createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  TreePainter treePainter;
  Map<int, bool> allLearnedZis = Map();
  Map<int, bool> newInLesson = Map();
  int previousZiId = 0;
  bool haveShowedOverlay = true;
  int compoundZiComponentNum = 0;
  List<int> compoundZiAllComponents = [];
  var compoundZiAnimationTimer;

  int centerZiId;
  bool shouldDrawCenter;
  double screenWidth;
  OverlayEntry overlayEntry;

  double getSizeRatio() {
    var defaultFontSize = screenWidth / 16;
    return defaultFontSize / 25.0; // ratio over original hard coded value
  }

  void _startAnimation() {
    _controller.stop();
    _controller.reset();
    _controller.forward(from: 0.0).whenComplete(() {
      setState(() {
        _controller.stop();
        _controller.reset();     // when complete, clean the animation drawing.
        shouldDrawCenter = true; // trigger redraw of the screen with regular center zi.
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

    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    // for different devices
    thePositionManager.setFrameTopEdgeSizeWithRatio(getSizeRatio());

    treePainter = new TreePainter(
      Colors.amber, //lineColor: Colors.amber,
      Colors.blueAccent, //completeColor: Colors.blueAccent,
      centerZiId, //centerId: centerZiId,
      shouldDrawCenter,
      screenWidth, //width: screenWidth,
      widget.sidePositionsCache,
      widget.realGroupMembersCache,
      widget.centerPositionAndSizeCache, //sidePositions: widget.sidePositions
      allLearnedZis,
      newInLesson,
        compoundZiCurrentComponentId
    );

    if (compoundZiComponentNum > 0 && compoundZiComponentNum <= compoundZiTotalComponentNum) {
      compoundZiAnimation();
    }

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(1)/*"Character drills"*/),
      ),
      body: Container(
        child: WillPopScope(   // just for removing overlay on detecting back arrow
          //height: 200.0,
          //width: 200.0,
          child: new Stack(
            children: <Widget>[
              new Positioned(
                child: CustomPaint(
                  foregroundPainter: treePainter,
                  child: Center(
                    child: Stack(
                      children: createHittestButtons(context)
                    ),
                  ),
                ),
              ),
              getAnimatedPathPainter(),
            ],
          ),
            onWillPop: _onWillPop
        ),
      )
    );
  }

  Widget getAnimatedPathPainter() {
    if (!theZiManager.isHechenZi(centerZiId)) {
      var posi = thePositionManager.getCenterZiPosi();
      var strokes = theZiManager.getZi(centerZiId).strokes;
      return new Positioned(
        top: posi.transY,
        left: posi.transX,
        height: posi.height,
        width: posi.width,
        child: new CustomPaint(
          foregroundPainter: new AnimatedPathPainter(_controller, strokes),
        ),
      );
    }
    else {
      // no need to create above.
      return Container(width: 0.0, height: 0.0);
    }
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

    var adjustedXValue = Utility.adjustOverlayXPosition(posiX, screenWidth);
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) =>Positioned(
        top: posiY,
        left: adjustedXValue,
        child: FlatButton(
          child: Text(meaning, style: TextStyle(fontSize: 20.0),),
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: () {},
        )
      ));
    overlayState.insert(overlayEntry);
  }

  Positioned getPositionedSpeechButton(PositionAndSize posiAndSize, int ziId) {
    var butt = FlatButton(
      onPressed: () {
        initOverlay();

        //resetCompoundZiAnimation();

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
        initOverlay();

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


  //NOTE: setState within the Timer so that it'll trigger this function to be called repeatedly.
  void  compoundZiAnimation() {
    const oneSec = const Duration(seconds: 1);
    compoundZiAnimationTimer = new Timer(oneSec, () {     //timeout(oneSec, (Timer t) {   //periodic
      setState(() {
        compoundZiComponentNum += 1;
      });
    });
  }

  Positioned getPositionedButton(PositionAndSize posiAndSize, int currentZiId, int newCenterZiId, bool isFromNavigation) {
    var butt = FlatButton(
      color: Colors.white,
      textColor: Colors.blueAccent,
      onPressed: () {
        initOverlay();

        _clearAnimation();
        resetCompoundZiAnimation();

        setState(() {
          centerZiId = newCenterZiId;
          if (Utility.isPseudoRootZiId(centerZiId)) {
            centerZiId = 1;   // skip the pseudo layer for treepage.
          }
          else if (Utility.isPseudoNonCharRootZiId(centerZiId)) {
            centerZiId = TheConst.starCharId;   // skip the pseudo layer for treepage.
          }
          shouldDrawCenter = true;
        });

        var zi = theZiManager.getZi(currentZiId);
        TextToSpeech.speak(zi.char);
      },
      onLongPress: () {
        initOverlay();

        var partialZiId = currentZiId;
        ZiListTypeWrapper listTypeWrapper = ZiListTypeWrapper(ZiListType.zi);
        if (theCurrentCenterZiId != currentZiId && !isFromNavigation) {
          partialZiId = theZiManager.getPartialZiId(listTypeWrapper, theCurrentCenterZiId, currentZiId);
        }

        var zi = theZiManager.getZi(partialZiId);
        TextToSpeech.speak(zi.char);

        if (previousZiId != currentZiId || !haveShowedOverlay) {
          var meaning = ZiManager.getPinyinAndMeaning(partialZiId);
          showOverlay(context, posiAndSize.transX, posiAndSize.transY, meaning);
          haveShowedOverlay = true;
        }
        else if (haveShowedOverlay) {
          haveShowedOverlay = false;
        }

        previousZiId = currentZiId;
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
    var realGroupMembers = BasePainter.getRealGroupMembers(centerZiId, ZiListType.zi, 0, theCurrentLessonId, theCurrentLessonId, widget.realGroupMembersCache);
    var totalSideNumberOfZis = theZiManager.getNumberOfZis(ZiListType.zi, realGroupMembers);
    for (var i = 0; i < realGroupMembers.length; i++) {
      var memberZiId = realGroupMembers[i];
      //var memberPinyinAndMeaning = ZiManager.getPinyinAndMeaning(memberZiId);
      var positionAndSize = BasePainter.getPositionAndSize(ZiListType.zi, memberZiId, totalSideNumberOfZis, widget.sidePositionsCache);

      var posi = getPositionedButton(positionAndSize, memberZiId, memberZiId, false);
      thePositionManager.updatePositionIndex(ZiListType.zi, memberZiId);
      buttons.add(posi);
    }

    // add Continue button
    if (theIsFromLessonContinuedSection) {
      buttons.add(getPositionedContinueButton());
    }

    if (centerZiId != 1 ) {
      //var pinyinAndMeaning = ZiManager.getPinyinAndMeaning(centerZiId);
      var newCenterZiId = theZiManager.getParentZiId(ZiListType.zi, centerZiId);
      var posiAndSize = BasePainter.getCenterPositionAndSize(widget.centerPositionAndSizeCache);
      var posiCenter = getPositionedButton(posiAndSize, centerZiId, newCenterZiId, false);
      buttons.add(posiCenter);

      // draw speech icon
      var posiAndSizeSpeech = thePositionManager.getCenterSpeechPosi();
      var speechPosiCenter = getPositionedSpeechButton(posiAndSizeSpeech, centerZiId);
      buttons.add(speechPosiCenter);

      // draw bihua icon
      var posiAndSizeBihua = thePositionManager.getCenterBihuaPosi();
      var drawBihuaPosiCenter = getPositionedDrawBihuaButton(posiAndSizeBihua, centerZiId);
      buttons.add(drawBihuaPosiCenter);
    }

    CreateNavigationHitttestButtons(centerZiId, false, buttons);

    return buttons;
  }

  CreateNavigationHitttestButtons(int centerZiId, bool isFromReviePage, List<Widget> buttons) {
    var naviMap = PositionManager.getNavigationPathPosi(ZiListType.zi, centerZiId, isFromReviePage, getSizeRatio());

    for (var id in naviMap.keys) {
      var posi = getPositionedButton(naviMap[id], id, id, true);
      buttons.add(posi);
    }
  }

  Positioned getPositionedContinueButton() {
    var yPosi = thePositionManager.getHintPosi();

    var butt = FlatButton(
      color: Colors.white,
      textColor: Colors.brown,
      onPressed: () {
        theIsBackArrowLessonExit = false;
        Navigator.of(context).pop();
      },
      child: Text('', style: TextStyle(fontSize: getSizeRatio() * 20.0)),
    );

    var posiCenter = Positioned(
        top: yPosi.transY +
            2 * thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
        left: getSizeRatio() * 0.0,
        height: getSizeRatio() * 25.0,
        //posiAndSize.height,
        width: getSizeRatio() * 200.0,
        //posiAndSize.width,
        child: butt
    );

    return posiCenter;
  }
}
