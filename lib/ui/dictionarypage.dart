import 'package:flutter/material.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/ui/animatedpathpainter.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/ui/dictionarypainter.dart';
import 'package:hanzishu/ui/dictionaryhelppage.dart';
import 'package:hanzishu/data/firstzilist.dart';
import 'package:hanzishu/engine/zi.dart';
import 'package:hanzishu/engine/zimanager.dart';

class DictionaryPage extends StatefulWidget {
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  PositionAndSize centerPositionAndSizeCache;

  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> with SingleTickerProviderStateMixin {
  //final TextEditingController _editController = TextEditingController();
  //int searchingZiIndex;
  int firstZiIndex;  // different meaning for different stage
  int searchingZiIndex;
  bool shouldDrawCenter;
  double screenWidth;
  DictionaryStage dicStage;
  OverlayEntry overlayEntry;
  PositionAndMeaning previousPositionAndMeaning = PositionAndMeaning(0.0, 0.0, "");

  AnimationController _controller;

  int compoundZiComponentNum = 0;
  List<int> compoundZiAllComponents = [];
  var compoundZiAnimationTimer;
  int compoundZiCurrentComponentId;
  var currentZiListType = ZiListType.searching;

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

    _controller = new AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    //_editController.addListener(processEditInput);
    //_editController.text = "";

    theCurrentCenterZiId = searchingZiIndex;

    setState(() {
      searchingZiIndex = searchingZiIndex;
      shouldDrawCenter = true;
      compoundZiComponentNum = 0;

      searchingZiIndex = 0;
      dicStage = DictionaryStage.firstzis;
      firstZiIndex = 0;
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
    //Utility.removeDicOverlayEntry(); TODO: need this like some other builds?

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

    screenWidth = Utility.getScreenWidth(context);

    if (compoundZiComponentNum > 0 && compoundZiComponentNum <= compoundZiTotalComponentNum) {
      compoundZiAnimation();
    }

    screenWidth = Utility.getScreenWidth(context);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Hanzishu One Tap Dictionary"),  //汉字树一触字典
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
                    shouldDrawCenter
                  ),
                  child: Center(
                    child: Stack(
                      children: displayCharsAndCreateHittestButtons(context)
                    ),
                  ),
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
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
      theDicOverlayEntry = null;
    }

    return Future.value(true);
  }

  //Widget getContainer() {
  //    return Container(
  //      child: getWillPopScope(),
  //    );
  //}

  /*
  Widget getHelpButton() {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
        ),
        onPressed: () {
          //theStatisticsManager.trackTimeAndTap();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DictionaryHelpPage(),
            ),
          );},
        child: const Text('Help'),
      ),
    );
  }
  */

  /*
  Widget getWillPopScope() {
    return WillPopScope(
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
                    compoundZiCurrentComponentId
                ),
                child: Center(
                  child: Stack(
                    children: displayCharsAndCreateHittestButtons(context)
                  ),
                ),
              ),
            ),
            getAnimatedPathPainter(),
          ]
        ),
        onWillPop: _onWillPop
    );
  }
*/

  Widget getAnimatedPathPainter() {
    //Note: need to match the dictionarypainter's value
    var posi = PositionManager.getDicAnimatedZiPositionAndSize();
    //var strokes = DictionaryManager.getSearchingZi(searchingZiIndex).strokes;
    if (searchingZiIndex > 0 && !DictionaryManager.isCompoundZi(searchingZiIndex)) {
      var strokes = DictionaryManager.getSingleComponentSearchingZiStrokes(searchingZiIndex);
      return new Positioned(
        top: posi.transY + 25.0 * 2, // 25 is the navigation text height
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

  showOverlay(BuildContext context, double posiX, double posiY, String meaning) {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
      theDicOverlayEntry = null;
    }

    OverlayState overlayState = Overlay.of(context);
    if (previousPositionAndMeaning.x != posiX || previousPositionAndMeaning.y != posiY || previousPositionAndMeaning.meaning != meaning) {
      overlayEntry = OverlayEntry(
          builder: (context) =>
              Positioned(
                  top: posiY,
                  left: posiX,
                  child: FlatButton(
                    child: Text(meaning, style: TextStyle(fontSize: 20.0),),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () {},
                  )
              ));
      previousPositionAndMeaning.x = posiX;
      previousPositionAndMeaning.y = posiY;
      previousPositionAndMeaning.meaning = meaning;
    }
    else {
      previousPositionAndMeaning.x = 0.0;
      previousPositionAndMeaning.y = 0.0;
      previousPositionAndMeaning.meaning = "";
    }

    // workaround for removal of overlay during AppBar switch
    theDicOverlayEntry = overlayEntry;

    overlayState.insert(overlayEntry);
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
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
          theDicOverlayEntry = null;
        }

        _clearAnimation();

        var char;
        if (dicStage == DictionaryStage.firstzis) {
          var searchingZiId = theFirstZiList[ziIndex].searchingZiId;
          char = theSearchingZiList[searchingZiId].char;
        }
        else if (dicStage == DictionaryStage.searchingzis) {
          char = theSearchingZiList[ziIndex].char;
        }

        TextToSpeech.speak(char);

        setState(() {
          if (dicStage == DictionaryStage.firstzis) {
            this.firstZiIndex = ziIndex;
            dicStage = DictionaryStage.searchingzis;
            //_editController.text = "";
          }
          else if (dicStage == DictionaryStage.searchingzis) {
            this.searchingZiIndex = ziIndex;
            dicStage = DictionaryStage.detailedzi;
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

          TextToSpeech.speak(char);
          showOverlay(context, posiAndSize.transX, posiAndSize.transY, pinyinAndMeaning);
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

  Positioned getPositionedNavigationButton(PositionAndSize posiAndSize, DictionaryStage newDicStage) {
    var butt = FlatButton(
      color: Colors.white, // buttonColor,
      textColor: Colors.blueAccent,
      onPressed: () {
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
        }

        _clearAnimation();

        setState(() {
          dicStage = newDicStage;
          shouldDrawCenter = true;
          //_editController.text = "";
        });
      },
      onLongPress: () {
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

  Widget getGoHomeButton() {
    var butt = FlatButton(
      onPressed: () {
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
        }

        setState(() {
          dicStage = DictionaryStage.firstzis;
          //_editController.text = "";
        });
      },
      child: Text('@ ->', style: TextStyle(fontSize: 25.0),),
    );

    return butt;
  }

  Positioned getPositionedSpeechButton(PositionAndSize posiAndSize, int searchingZiId) {
    var butt = FlatButton(
      onPressed: () {
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
        }

        var searchingZi = theSearchingZiList[searchingZiId];
        TextToSpeech.speak(searchingZi.char);
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

  getHelpPositionedButton(posiAndSize) {
    var butt = FlatButton(
      onPressed: () {
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DictionaryHelpPage(),
          ),
        );

        //setState(() {
        //  dicStage = DictionaryStage.help;
        //  shouldDrawCenter = true;
        //  _editController.text = "";
        //});
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

  /* no longer used
  getSearchPositionedButton(posiAndSize) {
    var butt = FlatButton(
      onPressed: () {
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
        }

        setState(() {
          /*
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DictionarySearchPage(),
              )
          );
           */
          dicStage = DictionaryStage.search;
          firstZiIndex = -1;

          //shouldDrawCenter = true;
        });
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
  */

  Positioned getPositionedDrawBihuaButton(PositionAndSize posiAndSize, int ziId) {
    var butt = FlatButton(
      onPressed: () {
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
          theDicOverlayEntry = null;
        }

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

  CreateNavigationHitttestButtons(DictionaryStage stage, List<Widget> buttons) {
      PositionAndSize dicRootPosi = PositionAndSize(
          10.0, 5.0, 25.0, 25.0, 20.0, 1.0);
      var button1 = getPositionedNavigationButton(
          dicRootPosi, DictionaryStage.firstzis);
      buttons.add(button1);

      if (stage == DictionaryStage.detailedzi) {
        PositionAndSize dicSearchingZiPosi = PositionAndSize(
            70.0, 5.0, 25.0, 25.0, 20.0, 1);
        var button2 = getPositionedNavigationButton(
            dicSearchingZiPosi, DictionaryStage.searchingzis);
        buttons.add(button2);
      }
  }

  List<Widget> displayCharsAndCreateHittestButtons(BuildContext context) {
    List<Widget> buttons = [];

    thePositionManager.resetPositionIndex();

    if (dicStage == DictionaryStage.firstzis) {
      // search button first
      var searchPosiAndSize = PositionAndSize(screenWidth - 140.0, 5.0, 40.0, 40.0, 0.0, 0.0);
      //var searchPosi = getSearchPositionedButton(searchPosiAndSize);
      //buttons.add(searchPosi);

      // help button next
      var helpPosiAndSize = PositionAndSize(screenWidth - 70.0, 5.0, 40.0, 40.0, 0.0, 0.0);
      var helpPosi = getHelpPositionedButton(helpPosiAndSize);
      buttons.add(helpPosi);

      for (var j = 0; j < 16; j++) {
        for (var i = 0; i < 12; i++) {
          var positionAndSize = PositionAndSize(
              20.0 + i * 30.0, 60.0 + j * 30.0, 27.0, 27.0, 0.0, 0.0);

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

      DictionaryPainter.getSearchingParameters(length, actualColumnCount, startPosition);

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
      var positionAndSize = PositionAndSize(70.0, 230.0, 30.0, 30.0, 0.0, 0.0);
      var posi = getPositionedSpeechButton(positionAndSize, searchingZiIndex);
      buttons.add(posi);

      CreateNavigationHitttestButtons(DictionaryStage.detailedzi, buttons);
      createBreakoutHittestButtons(context, buttons);

      var posiAndSizeBihua = PositionManager.getDicAnimationBrushPositionAndSize();
      var drawBihuaPosiCenter = getPositionedDrawBihuaButton(posiAndSizeBihua, searchingZiIndex);
      buttons.add(drawBihuaPosiCenter);
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
      onPressed: () {
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
        }
        //setState(() {
        //searchingZiIndex = newCenterZiId;
        //});
      },
      onLongPress: () {
        //var scrollOffset = _scrollController.offset;
        //var zi = theZiManager.getZi(id);
        //var searchingZi = DictionaryManager.getSearchingZi(id);
        var char = ZiManager.getOneChar(id, listType);
        TextToSpeech.speak(char);
        var pinyinAndMeaning = ZiManager.getOnePinyinAndMeaning(id, listType);
        //var meaning = theZiManager.getPinyinAndMeaning(id);
        showOverlay(context, posiAndSize.transX, posiAndSize.transY /*- scrollOffset*/, pinyinAndMeaning);
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
        shouldDrawCenter
        );
      var breakoutPositions = painter.getDicBreakoutPositions(searchingZiIndex);
    //}

    var painterHeight = MediaQuery.of(context).size.height + 150.0;  // add some buffer at the end
    buttons.add (Container(height: painterHeight, width: screenWidth));  // workaround to avoid infinite space error

    breakoutPositions.forEach((uniqueNumber, position) =>
        buttons.add(getBreakoutPositionedButton(uniqueNumber, position)));

    return buttons;
  }
}
