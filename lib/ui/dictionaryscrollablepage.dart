import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/ui/dictionarypainter.dart';
import 'package:hanzishu/ui/dictionarysearchingpage.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/data/firstzilist.dart';
import 'package:hanzishu/data/searchingzilist.dart';

class DictionaryScrollablePage extends StatefulWidget {
  final int firstZiIndex;
  DictionaryScrollablePage({this.firstZiIndex});

  @override
  _DictionaryScrollablePageState createState() => _DictionaryScrollablePageState();
}

class _DictionaryScrollablePageState extends State<DictionaryScrollablePage> {
  int firstZiIndex;
  double fontSize1;
  double fontSize2;
  double fontSize3;

  int currentDisplayRow = 0;

  double screenWidth;
  ScrollController _scrollController;
  PrimitiveWrapper contentLength = PrimitiveWrapper(0.0);
  OverlayEntry overlayEntry;
  int previousOverlayGroup = 0;
  int previousOverlayIndex = 0;
  PositionAndMeaning previousPositionAndMeaning = PositionAndMeaning(
      0.0, 0.0, "");

  static int maxItemsInARow = 12;

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        //print("offset = ${_scrollController.offset}");
      });
  }

  initOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  @override
  void dispose() {
    initOverlay();
    _scrollController
        .dispose(); // it is a good practice to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    firstZiIndex = widget.firstZiIndex;

    // init positionmanager frame size
    thePositionManager.setFrameWidth(screenWidth);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(95) /*"DictionaryScrollable"*/),
      ),
      body: Container(
        //height: 800.00,

        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: WillPopScope(
              child: Column(
                  children: <Widget>[
                    getDictionaryScrollableContent(context),
                  ]
              ),
              onWillPop: _onWillPop
          ),
        ),

      ),
    );
  }

  Future<bool> _onWillPop() {
    return Future.value(true);
  }

  Widget getDictionaryScrollableContent(BuildContext context) {
    return Column(
      //mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: DisplaySearchingZis(firstZiIndex),
    );
  }

  DisplaySearchingZis(int firstZiIndex) {
    var length = DictionaryPainter.getSearchingZiCount(firstZiIndex);
    var searchingZiId = theFirstZiList[firstZiIndex].searchingZiId;
    int newCharCount = 0;
    int previousStrokeCount = 0;
    int currentStrokeCount = 0;

    List<Widget> widgets = [];
    String charOrStrokeIndexStr;
    List<String> rowStringList = [];
    var count = 0;
    for (var j = 0; j < 30; j++) {
      currentDisplayRow = j;
      for (var i = 0; i < 12 /*actualColumnCount.value*/; i++) {  //12
        var searchingZi = theSearchingZiList[searchingZiId];
        currentStrokeCount = searchingZi.strokeCount;

        if ((previousStrokeCount == 0 && currentStrokeCount != previousStrokeCount) || (newCharCount >= DictionaryPainter.minCharsForStrokeIndex && currentStrokeCount != previousStrokeCount)) {
          charOrStrokeIndexStr = "(" + currentStrokeCount.toString() + ")";
          newCharCount = 0;
          previousStrokeCount = currentStrokeCount;
        }
        else {
          charOrStrokeIndexStr = searchingZi.char;
          newCharCount++;
          previousStrokeCount = currentStrokeCount;
          searchingZiId++;
          count++;
          if (count >= length) {
            break; //return;
          }
        }
        rowStringList.add(charOrStrokeIndexStr);
      }

      var oneRowButtons = getRowButtons(rowStringList);
      rowStringList.clear();
      widgets.add(getOneRowContainer(oneRowButtons));
    }

    return widgets;
  }

  Widget getOneRowContainer(List<Widget> rowButtons) {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: rowButtons
      ),
    );
  }

  List<Widget> getRowButtons(List<String> rowStringList/*int sentId, int rowIndex*/) {
    List<Widget> buttons = [];
    double fontSize;
    String currentZiOrLable;
    bool isChar;
    var color;

    for (int i = 0; i < rowStringList.length; i++) {
      int ziId;
      currentZiOrLable = rowStringList[i];
      if (currentZiOrLable[0] == '(') {
        fontSize = 13.0 * getSizeRatioWithLimit();
        isChar = false;
        color = Colors.black;
        ziId = -1;
      }
      else {
        fontSize = 30.0 * getSizeRatioWithLimit();
        isChar = true;
        color = Colors.blueAccent;
        ziId = ZiManager.findIdFromChar(ZiListType.searching, currentZiOrLable);;
      }

      var butt = TextButton(
        style: TextButton.styleFrom(
            textStyle: TextStyle(fontSize: fontSize * getSizeRatioWithLimit()),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.fromLTRB(0.0/*2.5*/, 0.0, 0.0/*2.5*/, 0.0)
        ),
        onPressed: () {
          initOverlay();
          if (isChar) {
            //TextToSpeech.speak("zh-CN", sentText[i]);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DictionarySearchingPage(
                        dicStage: DictionaryStage.detailedzi,
                        firstOrSearchingZiIndex: ziId,
                        flashcardList: null,
                        dicCaller: DicCaller.Dictionary),
              ),
            );
          }
        },
        onLongPress: () {
          initOverlay();
          if (isChar) {
            TextToSpeech.speak("zh-CN", currentZiOrLable);
            var meaning = ZiManager.getOnePinyinAndMeaning(
                ziId, ZiListType.searching);
            var posiAndSize = PositionAndSize(
                (150.0 + currentDisplayRow) * getSizeRatioWithLimit(),
                (85.0 + (currentDisplayRow * 25)) * getSizeRatioWithLimit(),
                20.0 * getSizeRatioWithLimit(), 20.0 * getSizeRatioWithLimit(),
                0.0, 0.0);
            showOverlay(
                context, posiAndSize.transX, posiAndSize.transY, meaning);
          }
        },
        child: Text(currentZiOrLable,
            style: TextStyle(color: color)),
      );
      buttons.add(SizedBox(width: 30 * getSizeRatioWithLimit(), height: 38 * getSizeRatioWithLimit(), child: butt));
    }

    return buttons;
  }

  showOverlay(BuildContext context, double posiX, double posiY, String meaning) {
    initOverlay();

    if (previousPositionAndMeaning.x != posiX || previousPositionAndMeaning.y != posiY || previousPositionAndMeaning.meaning != meaning) {
      var screenWidth = Utility.getScreenWidth(context);
      var adjustedXValue = Utility.adjustOverlayXPosition(posiX, screenWidth);

      OverlayState overlayState = Overlay.of(context);
      overlayEntry = OverlayEntry(
          builder: (context) =>
              Positioned(
                  top: posiY,
                  left: adjustedXValue,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blueAccent, //Colors.red.shade50,
                      textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.fromLTRB(2.5, 0.0, 2.5, 0.0),
                    ),
                    onPressed: () {
                      initOverlay();
                    },
                    child: Text(meaning,
                        style: TextStyle(color: Colors.white)),
                  )
              ));
      overlayState.insert(overlayEntry);
      previousPositionAndMeaning.set(posiX, posiY, meaning);
    }
    else {
      previousPositionAndMeaning.set(0.0, 0.0, "");
    }
  }
}
