import 'package:flutter/material.dart';
import 'package:hanzishu/data/searchingzilist.dart';
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
import 'package:hanzishu/ui/animatedpathpainter.dart';
import 'package:hanzishu/ui/dictionarypainter.dart';
import 'package:hanzishu/data/firstzilist.dart';
import 'package:hanzishu/engine/zi.dart';

class DictionaryPage extends StatefulWidget {
  //final int lessonId;
  final int startLessonId;
  final int endLessonId;
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  PositionAndSize centerPositionAndSizeCache;

  DictionaryPage({this.startLessonId, this.endLessonId});

  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> with SingleTickerProviderStateMixin {
  //int ziIndex;
  int firstZiIndex;  // different meaning for different stage
  int searchingZiIndex;
  bool shouldDrawCenter;
  double screenWidth;
  DictionaryStage dicStage;
  OverlayEntry overlayEntry;

  AnimationController _controller;
  Map<int, bool> allLearnedZis = Map();

  void _startAnimation() {
    _controller.stop();
    _controller.reset();
    _controller.forward(from: 0.0);
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
      firstZiIndex = 0;  // different meaning for different stage
      searchingZiIndex = 0;
      shouldDrawCenter = true;
      dicStage = DictionaryStage.firstzis;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);

    var posi = thePositionManager.getCenterZiPosi();

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("字典"),
      ),
      body: Container(
        //height: 200.0,
        //width: 200.0,
          child: WillPopScope( // just for removing overlay on detecting back arrow
              child: CustomPaint(
                foregroundPainter: DictionaryPainter(
                    Colors.amber,
                    //lessonId: widget.lessonId,
                    screenWidth,
                    //screenWidth: screenWidth,
                    dicStage,
                    firstZiIndex,
                    searchingZiIndex
                ),
                child: Center(
                  child: Stack(
                      children: displayCharsAndCreateHittestButtons(context)
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

  Positioned getPositionedButton(PositionAndSize posiAndSize, int ziIndex) {
    var butt = FlatButton(
      color: Colors.white, // buttonColor,
      textColor: Colors.blueAccent,
      onPressed: () {
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
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
          }
          else if (dicStage == DictionaryStage.searchingzis) {
            this.searchingZiIndex = ziIndex;
            dicStage = DictionaryStage.detailedzi;
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

        setState(() {
          dicStage = DictionaryStage.help;
          shouldDrawCenter = true;
        });
      },
      child: Text('Help', style: TextStyle(fontSize: 20.0),),
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

        setState(() {
          shouldDrawCenter = false;
        });

        _startAnimation();

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

  List<Widget> displayCharsAndCreateHittestButtons(BuildContext context) {
    List<Widget> buttons = [];

    thePositionManager.resetPositionIndex();

    if (dicStage == DictionaryStage.firstzis) {
      // help first
      //displayTextWithValue("Help", 350, 5.0, 20.0, Colors.lightBlue);
      var helpPosiAndSize = PositionAndSize(
          350, 5.0, 25.0, 25.0, 0.0, 0.0);
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

      var count = 0;
      for (var j = 0; j < 16; j++) {
        for (var i = 0; i < 12; i++) {
          var positionAndSize = PositionAndSize(
              20.0 + i * 30.0, 90.0 + j * 30.0, 27.0, 27.0, 0.0, 0.0);

          var posi = getPositionedButton(
              positionAndSize, searchingZiId);

          //thePositionManager.updatePositionIndex(168 /*memberZiId*/);
          buttons.add(posi);

          searchingZiId++;
          count++;

          if (count > length) {
            CreateNavigationHitttestButtons(DictionaryStage.searchingzis, buttons);
            return buttons; // stop the loop
          }
        }
      }
    }
    else if (dicStage == DictionaryStage.detailedzi) {
      // for speech icon
      var positionAndSize = PositionAndSize(70.0, 358.0, 30.0, 30.0, 0.0, 0.0);
      var posi = getPositionedSpeechButton(positionAndSize, searchingZiIndex);
      buttons.add(posi);

      CreateNavigationHitttestButtons(DictionaryStage.detailedzi, buttons);
    }
    else if (dicStage == DictionaryStage.help) {
      CreateNavigationHitttestButtons(DictionaryStage.detailedzi, buttons);
    }

    return buttons;
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
}
