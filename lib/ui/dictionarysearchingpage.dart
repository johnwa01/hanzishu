// Note: This page doesn't cover FirstZi feature which is in charge of by dictionarypage.dart.
import 'package:flutter/material.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'dart:ui';
import 'dart:async';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/ui/animatedpathpainter.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/ui/dictionarypainter.dart';
import 'package:hanzishu/ui/dictionaryhelppage.dart';
import 'package:hanzishu/data/firstzilist.dart';
import 'package:hanzishu/engine/zi.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/ui/zigrouppage.dart';

class DictionarySearchingPage extends StatefulWidget {
  DictionaryStage dicStage;
  final int firstOrSearchingZiIndex;
  final String flashcardList;
  final DicCaller dicCaller;

  //dicStage = DictionaryStage.searchingzis;
  DictionarySearchingPage({this.dicStage, this.firstOrSearchingZiIndex, this.flashcardList, this.dicCaller});

  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  PositionAndSize centerPositionAndSizeCache;

  @override
  _DictionarySearchingPageState createState() => _DictionarySearchingPageState();
}

class _DictionarySearchingPageState extends State<DictionarySearchingPage> with SingleTickerProviderStateMixin {
  int firstZiIndex; // different meaning for different stage
  int searchingZiIndex;
  bool shouldDrawCenter;
  double screenWidth;
  DictionaryStage dicStage;
  OverlayEntry overlayEntry;
  PositionAndMeaning previousPositionAndMeaning = PositionAndMeaning(
      0.0, 0.0, "");

  AnimationController _controller;

  int compoundZiComponentNum = 0;
  List<int> compoundZiAllComponents = [];
  var compoundZiAnimationTimer;
  int compoundZiCurrentComponentId;
  var currentZiListType = ZiListType.searching;
  bool showBreakoutDetails;
  String flashcardList;
  int flashcardIndex;
  DicCaller dicCaller;

  double getSizeRatio() {
    var defaultFontSize = screenWidth / 16;
    return defaultFontSize / 25.0; // ratio over original hard coded value
  }

  double applyRatio(double value) {
    return value * getSizeRatio();
  }

  void _startAnimation() {
    _controller.stop();
    _controller.reset();
    _controller.forward(from: 0.0).whenComplete(() {
      setState(() {
        _controller.stop();
        _controller.reset(); // when complete, clean the animation drawing.
        shouldDrawCenter =
        true; // let it redraw the screen with regular center zi.
      });
    });
  }

  void _clearAnimation() {
    _controller.stop();
    _controller.reset();
  }

  void clearOverlayEntry() {
    if(dicStage != DictionaryStage.firstzis) {
      if (overlayEntry != null) {
        overlayEntry.remove();
        overlayEntry = null;
      }
    }
  }

  initOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    //Not used?
    theCurrentCenterZiId = searchingZiIndex;
    flashcardList = widget.flashcardList;
    flashcardIndex = 0;
    dicCaller = widget.dicCaller;

    setState(() {
      shouldDrawCenter = true;
      compoundZiComponentNum = 0;

      searchingZiIndex = 0;
      dicStage = widget.dicStage; //DictionaryStage.searchingzis;
      if (dicStage == DictionaryStage.searchingzis) {
        firstZiIndex = widget.firstOrSearchingZiIndex;
        searchingZiIndex = -1;
      }
      else if (dicStage == DictionaryStage.detailedzi ){
        firstZiIndex = -1;
        if (flashcardList != null && flashcardList.length > 0) {
          searchingZiIndex = DictionaryManager.getSearchingZiId(flashcardList[flashcardIndex]);
        }
        else {
          searchingZiIndex = widget.firstOrSearchingZiIndex;
        }
      }
      showBreakoutDetails = false;
    });
  }

  // try to not use this due to the full search
  int getSearchingListIndexFromChar(String text) {
    for (var i = 0; i < theSearchingZiList.length; i++) {
      if (theSearchingZiList[i].char == text) {
        return i;
      }
    }

    return -1;
  }

  @override
  void dispose() {
    _controller.dispose();
    resetCompoundZiAnimation();
    //_editController.dispose();

    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    compoundZiCurrentComponentId = searchingZiIndex;
    int compoundZiTotalComponentNum = 0;

    // compound zi is animating.
    if (compoundZiComponentNum > 0) {
      List<String> componentCodes = List<String>();
      if (compoundZiAllComponents == null || compoundZiAllComponents.length == 0) {
        DictionaryManager.getAllComponents(searchingZiIndex, componentCodes);
        DictionaryManager.getComponentIdsFromCodes(
            componentCodes, compoundZiAllComponents);
      }
      //var compList = getAllZiComponents(searchingZiIndex);
      compoundZiTotalComponentNum = compoundZiAllComponents.length;

      if (compoundZiComponentNum == compoundZiTotalComponentNum + 1) {
        // after looping through the compoundZiAllComponents.
        compoundZiCurrentComponentId = searchingZiIndex;
        currentZiListType = ZiListType.searching;
        shouldDrawCenter = true;
        resetCompoundZiAnimation();
      }
      else {
        compoundZiCurrentComponentId = compoundZiAllComponents[compoundZiComponentNum - 1];
        currentZiListType = ZiListType.component;
      }
    }

    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    //screenWidth = Utility.getScreenWidth(context);

    if (compoundZiComponentNum > 0 && compoundZiComponentNum <= compoundZiTotalComponentNum) {
      compoundZiAnimation();
    }

    var title;
    if (flashcardList == null) {
      title = getString(95); /*Hanzishu Dictionary*/
    }
    else {
      title = getString(406); /*Customized Flashcards*/
    }

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(title),  //汉字树字典/Customized Flashcards
      ),
      body: Container(
          child: WillPopScope(
              child: new Stack(
                  children: <Widget>[
                    new Positioned(
                      child: CustomPaint(
                        foregroundPainter: DictionaryPainter(
                            Colors.amber,
                            //lessonId: widget.lessonId,
                            screenWidth,
                            //screenWidth: screenWidth,
                            dicStage,
                            firstZiIndex,
                            searchingZiIndex,
                            context,
                            compoundZiCurrentComponentId,
                            currentZiListType,
                            shouldDrawCenter,
                            showBreakoutDetails,
                        ),
                        //child: Center(
                          child: Stack(
                              children: displayCharsAndCreateHittestButtons(context)
                          ),
                        //),
                      ),
                    ),
                    getAnimatedPathPainter(),
                  ]
              ),
              onWillPop: _onWillPop
          )
      ),
    );
  }

  Future<bool>_onWillPop() {
    clearOverlayEntry();

    return Future.value(true);
  }

  Widget getAnimatedPathPainter() {
    //Note: need to match the dictionarypainter's value

    var posi = PositionManager.getDicAnimatedZiPositionAndSize(getSizeRatio());
    //var strokes = DictionaryManager.getSearchingZi(searchingZiIndex).strokes;
    if (searchingZiIndex > 0 && !DictionaryManager.isCompoundZi(searchingZiIndex)) {
      var strokes = DictionaryManager.getSingleComponentSearchingZiStrokes(searchingZiIndex);
      return new Positioned(
        top: posi.transY + 25.0 * 2 * getSizeRatio(), // 25 is the navigation text height
        left: posi.transX,
        height: posi.height,
        width: posi.width,
        child: new CustomPaint(
          foregroundPainter: new AnimatedPathPainter(_controller, strokes),
        ),
      );
    }
    else {
      // no need to create this.
      return Container(width: 0.0, height: 0.0);
    }
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

  showOverlay(BuildContext context, double xPosi, double yPosi, String meaning) {
    clearOverlayEntry();

    OverlayState overlayState = Overlay.of(context);

    if (previousPositionAndMeaning.x != xPosi || previousPositionAndMeaning.y != yPosi || previousPositionAndMeaning.meaning != meaning) {
      if (dicStage != DictionaryStage.firstzis) {
        var screenWidth = Utility.getScreenWidth(context); // Ok to use full width here
        var adjustedXValue = Utility.adjustOverlayXPosition(xPosi, screenWidth);
        overlayEntry = OverlayEntry(
            builder: (context) =>
                Positioned(
                    top: yPosi,
                    left: adjustedXValue,
                    child: FlatButton(
                      child: Text(meaning, style: TextStyle(fontSize: 20.0 * getSizeRatio()),),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () {initOverlay();},
                    )
                ));
        overlayState.insert(overlayEntry);
        previousPositionAndMeaning.set(xPosi, yPosi, meaning);
      }
    }
    else {
      previousPositionAndMeaning.set(0.0, 0.0, "");
    }

    //if (dicStage != DictionaryStage.firstzis) {
    //  overlayState.insert(overlayEntry);
    //}
  }

  Widget getSearchErrorMessage() {
    String errorMsg = "";

    if (searchingZiIndex == -1) {
      errorMsg = "Info: Can't find the zi you are searching for.";
    }

    return Text(errorMsg,style: TextStyle(color:Colors.blueAccent,fontSize:20),);
  }

  Positioned getPositionedButton(PositionAndSize posiAndSize, int ziIndex) {
    var butt = FlatButton(
      color: Colors.white, // buttonColor,
      textColor: Colors.blueAccent,
      onPressed: () {
        clearOverlayEntry();

        _clearAnimation();

        var char;
        if (dicStage == DictionaryStage.firstzis) {
          var searchingZiId = theFirstZiList[ziIndex].searchingZiId;
          char = theSearchingZiList[searchingZiId].char;
        }
        else if (dicStage == DictionaryStage.searchingzis) {
          char = theSearchingZiList[ziIndex].char;
        }

        TextToSpeech.speak("zh-CN", char);

        setState(() {
          if (dicStage == DictionaryStage.firstzis) {
            this.firstZiIndex = ziIndex;
            dicStage = DictionaryStage.searchingzis;
            //_editController.text = "";
          }
          else if (dicStage == DictionaryStage.searchingzis) {
            if (!DictionaryManager.isEmpty(ziIndex)) {
              this.searchingZiIndex = ziIndex;
              dicStage = DictionaryStage.detailedzi;
            }
            //_editController.text = "";
          }

          shouldDrawCenter = true;
        });
      },
      onLongPress: () {
        var char;
        var pinyinAndMeaning;
        if (dicStage == DictionaryStage.firstzis) {
          var searchingZiId = theFirstZiList[ziIndex].searchingZiId;
          var searchingZi = theSearchingZiList[searchingZiId];
          char = searchingZi.char;
          pinyinAndMeaning = Zi.formatPinyinAndMeaning(searchingZi.pinyin, searchingZi.meaning);
        }
        else if (dicStage == DictionaryStage.searchingzis) {
          var searchingZi = theSearchingZiList[ziIndex];
          char = searchingZi.char;
          pinyinAndMeaning = Zi.formatPinyinAndMeaning(searchingZi.pinyin, searchingZi.meaning);
        }

        TextToSpeech.speak("zh-CN", char);
        showOverlay(context, posiAndSize.transX, posiAndSize.transY, pinyinAndMeaning);
      },
      child: Text('', style: TextStyle(fontSize: 20.0 * getSizeRatio()),),
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

  Positioned getPositionedNavigationButton(PositionAndSize posiAndSize, DictionaryStage newDicStage) {
    var butt = FlatButton(
      color: Colors.white, // buttonColor,
      textColor: Colors.blueAccent,
      onPressed: () {
        clearOverlayEntry();

        _clearAnimation();

        setState(() {
          dicStage = newDicStage;
          shouldDrawCenter = true;
        });
      },
      onLongPress: () {
      },
      child: Text('', style: TextStyle(fontSize: 20.0 * getSizeRatio()),),
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

  Widget getGoHomeButton() {
    var butt = FlatButton(
      onPressed: () {
        clearOverlayEntry();

        setState(() {
          dicStage = DictionaryStage.firstzis;
          //_editController.text = "";
        });
      },
      child: Text('@ ->', style: TextStyle(fontSize: 25.0 * getSizeRatio()),),
    );

    return butt;
  }

  Positioned getPositionedSpeechButton(PositionAndSize posiAndSize, int searchingZiId) {
    var butt = FlatButton(
      onPressed: () {
        clearOverlayEntry();

        var searchingZi = theSearchingZiList[searchingZiId];
        TextToSpeech.speak("zh-CN", searchingZi.char);
      },
      child: Text('', style: TextStyle(fontSize: 20.0 * getSizeRatio()),),
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

  Positioned getPositionedTranslationSpeechButton(PositionAndSize posiAndSize, int searchingZiId) {
    var butt = FlatButton(
      onPressed: () {
        clearOverlayEntry();

        var searchingZi = theSearchingZiList[searchingZiId];
        TextToSpeech.speak("en-US", searchingZi.meaning);
      },
      child: Text('', style: TextStyle(fontSize: 20.0 * getSizeRatio()),),
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

  Positioned getPositionedBreakdownButton(PositionAndSize posiAndSize) {
    var butt = FlatButton(
      onPressed: () {
        clearOverlayEntry();

        setState(() {
          showBreakoutDetails = !showBreakoutDetails;
        });
      },
      child: Text('', style: TextStyle(fontSize: 20.0 * getSizeRatio()),),
    );

    var posi = Positioned(
        top: posiAndSize.transY,
        left: posiAndSize.transX,
        height: posiAndSize.height,
        width: posiAndSize.width,
        child: butt
    );

    return posi;
  }

  getHelpPositionedButton(posiAndSize) {
    var butt = FlatButton(
      onPressed: () {
        clearOverlayEntry();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DictionaryHelpPage(),
          ),
        );
      },
      child: Text('', style: TextStyle(fontSize: 20.0 * getSizeRatio()),),
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
        clearOverlayEntry();

        resetCompoundZiAnimation();

        setState(() {
          shouldDrawCenter = false;
        });

        if (!DictionaryManager.isCompoundZi(ziId)) {
          _startAnimation();
        }
        else {
          // it actually just sets a clock and tell which component index to display.
          // the real display of the component is done through the DictionaryPainter, animation painter is not involved.
          compoundZiAnimation();
        }

        var zi = DictionaryManager.getSearchingZi(ziId);
        TextToSpeech.speak("zh-CN", zi.char);
      },
      child: Text('', style: TextStyle(fontSize: 20.0 * getSizeRatio()),),
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

  Positioned getPositionedDrawZiGroupButton(PositionAndSize posiAndSize, int ziId) {
    var butt = FlatButton(
      onPressed: () {
        clearOverlayEntry();
        resetCompoundZiAnimation();

        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ZiGroupPage(ziId: ziId)));
      },
      child: Text('', style: TextStyle(fontSize: 20.0 * getSizeRatio()),),
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

  CreateNavigationHitttestButtons(DictionaryStage stage, List<Widget> buttons) {
    var defaultFontSize = screenWidth / 16.0;     // was hardcoded 25.0, use it as the standard
    var fontSize1 = defaultFontSize * (5.0 / 25.0);
//    var fontSize2 = defaultFontSize * (10.0 / 25.0);
    var fontSize3 = defaultFontSize * (20.0 / 25.0);
    var fontSize4 = defaultFontSize * (35.0 / 25.0);
/*
    PositionAndSize dicRootPosi = PositionAndSize(
        fontSize2, fontSize1, defaultFontSize, defaultFontSize, fontSize3, 1.0);
    var button1 = getPositionedNavigationButton(
        dicRootPosi, DictionaryStage.firstzis);
    buttons.add(button1);
*/
    if (stage == DictionaryStage.detailedzi) {
      PositionAndSize dicSearchingZiPosi = PositionAndSize(
          fontSize4, fontSize1, defaultFontSize * 2.5, defaultFontSize, fontSize3, 1.0);
      var button2 = getPositionedNavigationButton(
          dicSearchingZiPosi, DictionaryStage.searchingzis);
      buttons.add(button2);
    }
  }

  List<Widget> displayCharsAndCreateHittestButtons(BuildContext context) {
    List<Widget> buttons = [];

    thePositionManager.resetPositionIndex();

    var defaultFontSize = screenWidth / 16;     // was hardcoded 25.0 in painter, use it as the standard
    var hitTestPositionGap = defaultFontSize * (29.0 / 25.0);  // 25 + 4 = 29
    var hitTestSize = defaultFontSize * (27.0 / 25.0);
    var startXSize = defaultFontSize * (20.0 / 25.0);
    var startYSize = defaultFontSize * (45.0 / 25.0); // ratio of 60.0/25.0
    var helpPara1 = defaultFontSize * (70.0 / 25.0);
    var helpPara2 = defaultFontSize * (5.0 / 25.0);
    var helpPara3 = defaultFontSize * (40.0 / 25.0);
    var valuePara1 = defaultFontSize * (90.0 / 25.0);
    var valuePara2 = defaultFontSize * (210.0 / 25.0);

    if (dicStage == DictionaryStage.firstzis) {
      // help button next
      var helpPosiAndSize = PositionAndSize(screenWidth - helpPara1, helpPara2, helpPara3, helpPara3, 0.0, 0.0);
      var helpPosi = getHelpPositionedButton(helpPosiAndSize);
      buttons.add(helpPosi);

      for (var j = 0; j < 16; j++) {
        for (var i = 0; i < 12; i++) {
          var positionAndSize = PositionAndSize(
              startXSize + i * hitTestPositionGap, startYSize + j * hitTestPositionGap, hitTestSize, hitTestSize, 0.0, 0.0);

          int indexOfFirstZi = j * 12 + i;
          if (indexOfFirstZi >= theFirstZiList.length) {
            return buttons;
          }

          if (theFirstZiList[indexOfFirstZi].char[0] != '[') {
            var posi = getPositionedButton(
                positionAndSize, indexOfFirstZi);

            buttons.add(posi);
          }
        }
      }
    }
    else if (dicStage == DictionaryStage.searchingzis) {
      var length = DictionaryPainter.getSearchingZiCount(firstZiIndex);
      var searchingZiId = theFirstZiList[firstZiIndex].searchingZiId;
      PrimitiveWrapper actualColumnCount = new PrimitiveWrapper(0);
      PositionAndSize startPosition = new PositionAndSize(0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

      DictionaryPainter.getSearchingParameters(screenWidth, length, actualColumnCount, startPosition);

      //int baseStrokeCount = theSearchingZiList[searchingZiId].strokeCount;
      int newCharCount = 0;
      int previousStrokeCount = 0;
      int currentStrokeCount = 0;

      var count = 0;
      for (var j = 0; j < 16; j++) {
        for (var i = 0; i < actualColumnCount.value; i++) {
          var searchingZi = theSearchingZiList[searchingZiId];
          currentStrokeCount = searchingZi.strokeCount;

          if ((previousStrokeCount == 0 && currentStrokeCount != previousStrokeCount) || (newCharCount >= DictionaryPainter.minCharsForStrokeIndex && currentStrokeCount != previousStrokeCount)) {
            newCharCount = 0;
            previousStrokeCount = currentStrokeCount;
          }
          else {
            //displayTextWithValue(searchingZi.char, 12.0 + i * (fontSize + 5.0), rowStartPosition + j * (fontSize + 5.0) - fontSize * 0.25, fontSize, Colors.blueAccent);
            var positionAndSize = PositionAndSize(
                startPosition.transX + i * startPosition.width,
                startPosition.transY + j * startPosition.height /*- startPosition.charFontSize * 0.25*/,
                startPosition.width,
                startPosition.height,
                startPosition.charFontSize,
                startPosition.lineWidth);

            var posi = getPositionedButton(
                positionAndSize, searchingZiId);

            //thePositionManager.updatePositionIndex(168 /*memberZiId*/);
            buttons.add(posi);
            newCharCount++;
            previousStrokeCount = currentStrokeCount;

            searchingZiId++;
            count++;

            if (count >= length) {
              CreateNavigationHitttestButtons(
                  DictionaryStage.searchingzis, buttons);
              return buttons; // stop the loop
            }
          }
        }
      }
    }
    else if (dicStage == DictionaryStage.detailedzi) {
      // for speech icon. Need to match the DictionaryPainter yPosi.
      var positionAndSize = PositionAndSize(valuePara1, valuePara2, startXSize, startXSize, 0.0, 0.0);
      var posi = getPositionedSpeechButton(positionAndSize, searchingZiIndex);
      buttons.add(posi);

      var searchingZi = theSearchingZiList[searchingZiIndex];
      var positionAndSizesTrans = PositionAndSize(valuePara1 + 0.5 * defaultFontSize, valuePara2 + 1.4 * defaultFontSize, startXSize * searchingZi.meaning.length / 1.95, startXSize * 1.2, 0.0, 0.0);
      var posiTrans = getPositionedTranslationSpeechButton(positionAndSizesTrans, searchingZiIndex);
      buttons.add(posiTrans);

      var breakdownPositionAndSize = PositionAndSize(115.0 * 1.1 * getSizeRatio(), 362.0 * getSizeRatio(), 20.0 * getSizeRatio(), 20.0 * getSizeRatio(), 0.0, 0.0);
      var breakdownPosi = getPositionedBreakdownButton(breakdownPositionAndSize);
      buttons.add(breakdownPosi);

      if (dicCaller != DicCaller.WordsStudy && dicCaller != DicCaller.Flashcard) {
        CreateNavigationHitttestButtons(DictionaryStage.detailedzi, buttons);
      }

      createBreakoutHittestButtons(context, buttons);

      var ratio =  getSizeRatio();
      var animatedZiPosi = PositionManager.getDicAnimatedZiPositionAndSize(ratio);
      var posiAndSizeBihua = PositionManager.getDicAnimationBrushPositionAndSize(animatedZiPosi, ratio);
      var drawBihuaPosiCenter = getPositionedDrawBihuaButton(posiAndSizeBihua, searchingZiIndex);
      buttons.add(drawBihuaPosiCenter);

      // for zigroup
      var posiAndSizeZiGroup = posiAndSizeBihua;
      posiAndSizeZiGroup.transX += 100;
      posiAndSizeZiGroup.width += 50*ratio;
      var drawZiGroupPosiCenter = getPositionedDrawZiGroupButton(posiAndSizeZiGroup, searchingZiIndex);
      buttons.add(drawZiGroupPosiCenter);

      // skip button
      if (theIsFromLessonContinuedSection) {
        buttons.add(getPositionedSkipButton());
      }
    }
    else if (dicStage == DictionaryStage.help) {
      CreateNavigationHitttestButtons(DictionaryStage.detailedzi, buttons);
    }

    return buttons;
  }

  Positioned getBreakoutPositionedButton(int uniqueNumber, PositionAndSize posiAndSize) {
    var id = Utility.getIdFromUniqueNumber(uniqueNumber);
    var listType = Utility.getListType(uniqueNumber, id);

    var butt = FlatButton(
      color: Colors.white,
      textColor: Colors.blueAccent,
      /*
      onPressed: () {
        clearOverlayEntry();
        //setState(() {
        //searchingZiIndex = newCenterZiId;
        //});
      },
      onLongPress: () {
      */
      onPressed: () {
        //var scrollOffset = _scrollController.offset;
        //var zi = theZiManager.getZi(id);
        //var searchingZi = DictionaryManager.getSearchingZi(id);
        var char = ZiManager.getOneChar(id, listType);
        TextToSpeech.speak("zh-CN", char);
        var pinyinAndMeaning = ZiManager.getOnePinyinAndMeaning(id, listType);
        //var meaning = ZiManager.getPinyinAndMeaning(id);
        showOverlay(context, posiAndSize.transX, posiAndSize.transY /*- scrollOffset*/, pinyinAndMeaning);
      },
      child: Text('', style: TextStyle(fontSize: 20.0 *getSizeRatio()),),
    );

    var posiCenter = Positioned(
        top: posiAndSize.transY,
        left: posiAndSize.transX,
        height: posiAndSize.height * 1.3, // not sure why the hittest area is smaller than the char. so use 1.3
        width: posiAndSize.width * 1.3,
        child: butt
    );

    return posiCenter;
  }

  List<Widget> createBreakoutHittestButtons(BuildContext context, List<Widget> buttons) {

    //var breakoutPositions = //theLessonManager.getBreakoutPositions(1/*TODO*/);
    //if (breakoutPositions.length == 0) {
    var painter = DictionaryPainter(
        Colors.amber,
        //lessonId: widget.lessonId,
        screenWidth,
        //screenWidth: screenWidth,
        dicStage,
        firstZiIndex,
        searchingZiIndex,
        context,
        0, //compoundZiCurrentComponentId,  //This is just to calculate the positions, therefore doesn't matter. compoundZiCurrentComponentId
        currentZiListType,
        shouldDrawCenter,
        showBreakoutDetails,
    );
    var breakoutPositions = painter.getDicBreakoutPositions(searchingZiIndex);
    //}

    var painterHeight = MediaQuery.of(context).size.height + 150.0 * getSizeRatio();  // add some buffer at the end
    buttons.add (Container(height: painterHeight, width: screenWidth));  // workaround to avoid infinite space error

    breakoutPositions.forEach((uniqueNumber, position) =>
        buttons.add(getBreakoutPositionedButton(uniqueNumber, position)));

    // Next flashcard button, match dictionarypainter's definition
    if (flashcardList != null) {
      var fontSize4 = applyRatio(20.0);
      var fontSize8 = applyRatio(115.0);
      var nextButtonPosiAndSize = PositionAndSize(fontSize8 * 1.1,
          0.0 /*getHighestBreakoutYPosi(breakoutPositions) + fontSize4 * 3 */,
          fontSize4 * 6, fontSize4 * 1.2, 10.0, 10.0);
      buttons.add(getNextFlashcardButton(nextButtonPosiAndSize));
    }

    if (dicCaller == DicCaller.WordsStudy) {
      buttons.add(getSkipThisSection());
    }

    return buttons;
  }

  double getHighestBreakoutYPosi( Map<int, PositionAndSize> breakoutPositions) {
    double highestValue = 0;;
    for (var values in breakoutPositions.values) {
      if (values.transY > highestValue) {
        highestValue = values.transY;
      }
    }

    return highestValue;
  }

  Widget getNextFlashcardButton(PositionAndSize posiAndSize) {
    var butt = FlatButton(
      color: Colors.blueAccent,
      textColor: Colors.white,
      onPressed: () {
        clearOverlayEntry();
        flashcardIndex++;
        if (flashcardList != null && flashcardList.length > 0 && flashcardIndex < flashcardList.length) {
          setState(() {
            searchingZiIndex =
                DictionaryManager.getSearchingZiId(
                    flashcardList[flashcardIndex]);
          });
        }
        else {
          showCompletedDialog(context);
        }
      },
      child: Text(getString(138) + "->", style: TextStyle(fontSize: 18.0 * getSizeRatio()),),
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

  Widget getSkipThisSection() {
    var butt = FlatButton(
        child: Text(
          getString(401) /*"Skip this section"*/, style: TextStyle(fontSize: 14.0),),
        color: Colors.white,
        textColor: Colors.blueAccent,
        onPressed: () {
          clearOverlayEntry();
          theIsBackArrowExit = false;
          Navigator.of(context).pop();
        },
      );

    var posiCenter = Positioned(
        top: 0.0, //y
        left: screenWidth - applyRatio(80.0),
        height: applyRatio(25.0),
        width: applyRatio(85.0),
        child: butt
    );

    return posiCenter;
  }

  showCompletedDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(getString(286)/*"OK"*/),
      onPressed: () {
        theIsBackArrowExit = false;
        Navigator.of(context).pop(); // out of this dialog first
        Navigator.of(context).pop(); // then to the lesson page
      },
    );

    String title = getString(115)/*"Good job!"*/;
    String content = getString(407)/*"You have go through all the flashcards!"*/;

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Positioned getPositionedSkipButton() {
    var yPosi = 0.0;

    var buttonColor = Colors.white;
    if (theAllZiLearned) {
      buttonColor = Colors.blue;
    }

    var butt = FlatButton(
      color: buttonColor, //Colors.white,
      textColor: Colors.brown,
      onPressed: () {
        theIsBackArrowExit = false;
        Navigator.of(context).pop();
      },
      child: Text('', style: TextStyle(fontSize: getSizeRatio() * 20.0)),
    );

    // NOTE: match the basepainting's drawZiGroup
    var posiCenter = Positioned(
        top: yPosi, //yPosi.transY +
        //2 * thePositionManager.getCharFontSize(ZiOrCharSize.defaultSize),
        left: screenWidth - 80.0, //getSizeRatio() * 0.0,  // Need to match DrillPainter/BasePainter
        height: /*getSizeRatio() */ 50.0,
        //posiAndSize.height,
        width: /*getSizeRatio() */ 80.0, // 100.0
        //posiAndSize.width,
        child: butt
    );

    return posiCenter;
  }
}
