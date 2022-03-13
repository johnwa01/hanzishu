// This page is for the dictionary front page only. the dictionarysearchingpage.dart is for all three stages - front, selection and details.
import 'package:flutter/material.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'dart:ui';
import 'dart:async';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/ui/dictionarypainter.dart';
import 'package:hanzishu/ui/dictionaryhelppage.dart';
import 'package:hanzishu/ui/dictionarysearchingpage.dart';
import 'package:hanzishu/data/firstzilist.dart';
import 'package:hanzishu/engine/zimanager.dart';

class DictionaryPage extends StatefulWidget {
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  PositionAndSize centerPositionAndSizeCache;

  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> with SingleTickerProviderStateMixin {
  int firstZiIndex;
  int searchingZiIndex;
  bool shouldDrawCenter;
  double screenWidth;
  DictionaryStage dicStage;
  OverlayEntry overlayEntry;
 // PositionAndMeaning previousPositionAndMeaning = PositionAndMeaning(
 //     0.0, 0.0, "");

  int compoundZiComponentNum = 0;
  List<int> compoundZiAllComponents = [];
  var compoundZiAnimationTimer;
  int compoundZiCurrentComponentId;
  var currentZiListType = ZiListType.searching;

  @override
  void initState() {
    super.initState();

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

  @override
  void dispose() {
    super.dispose();
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
      }
      else {
        compoundZiCurrentComponentId = compoundZiAllComponents[compoundZiComponentNum - 1];
        currentZiListType = ZiListType.component;
      }
    }

    screenWidth = Utility.getScreenWidthForTreeAndDict(context);

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
      //        getAnimatedPathPainter(),
            ]
          ),
          onWillPop: _onWillPop
        )
      ),
    );
  }

  Future<bool>_onWillPop() {
    return Future.value(true);
  }

  Positioned getPositionedButton(PositionAndSize posiAndSize, int ziIndex) {
    var butt = FlatButton(
      color: Colors.white, // buttonColor,
      textColor: Colors.blueAccent,
      onPressed: () {
        var char;
        if (dicStage == DictionaryStage.firstzis) {
          var searchingZiId = theFirstZiList[ziIndex].searchingZiId;
          char = theSearchingZiList[searchingZiId].char;
        }

        TextToSpeech.speak(char);

        setState(() {
          if (dicStage == DictionaryStage.firstzis) {
            //this.firstZiIndex = ziIndex;
            //dicStage = DictionaryStage.searchingzis;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DictionarySearchingPage(firstZiIndex: ziIndex),
              ),
            );
          }

          shouldDrawCenter = true;
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

  getHelpPositionedButton(posiAndSize) {
    var butt = FlatButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DictionaryHelpPage(),
          ),
        );
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

  List<Widget> displayCharsAndCreateHittestButtons(BuildContext context) {
    List<Widget> buttons = [];

    thePositionManager.resetPositionIndex();

    var defaultFontSize = screenWidth / 16;     // was hardcoded 25.0 in painter, use it as the standard
    var hitTestPositionGap = defaultFontSize * (29.0 / 25.0); //30, that is, 25 + 4 = 29
    var hitTestSize = defaultFontSize * (27.0 / 25.0);
    var startXSize = defaultFontSize * (20.0 / 25.0);
    var startYSize = defaultFontSize * (45.0 / 25.0); // ratio of 60.0/25.0
    var helpPara1 = defaultFontSize * (70.0 / 25.0);
    var helpPara2 = defaultFontSize * (5.0 / 25.0); // 5.0
    var helpPara3 = defaultFontSize * (40.0 / 25.0);


    if (dicStage == DictionaryStage.firstzis) {
      //var searchPosiAndSize = PositionAndSize(screenWidth - 140.0, 5.0, 40.0, 40.0, 0.0, 0.0);

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

    return buttons;
  }

}
