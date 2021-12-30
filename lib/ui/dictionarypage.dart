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
//import 'package:hanzishu/ui/animatedpathpainter.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/ui/dictionarypainter.dart';
import 'package:hanzishu/ui/dictionaryhelppage.dart';
import 'package:hanzishu/data/firstzilist.dart';
import 'package:hanzishu/engine/zi.dart';

class DictionaryPage extends StatefulWidget {
  //final int lessonId;
  //final int startLessonId;
  //final int endLessonId;
  //DictionaryStage dictionaryStage;
  //int currentZiIndex;

  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  PositionAndSize centerPositionAndSizeCache;

  //DictionaryPage(DictionaryStage dicStage, int ziIndex) {
  //  dictionaryStage = dicStage;
  //  currentZiIndex = ziIndex;
  //}
  //DictionaryPage({this.startLessonId, this.endLessonId});

  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> with SingleTickerProviderStateMixin {
  final TextEditingController _editController = TextEditingController();
  //int ziIndex;
  int firstZiIndex;  // different meaning for different stage
  int searchingZiIndex;
  bool shouldDrawCenter;
  double screenWidth;
  DictionaryStage dicStage;
  OverlayEntry overlayEntry;
  PositionAndMeaning previousPositionAndMeaning = PositionAndMeaning(0.0, 0.0, "");

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

    _editController.addListener(processEditInput);
    _editController.text = "";

    theCurrentCenterZiId = 1;

    setState(() {
      searchingZiIndex = 0;
      shouldDrawCenter = true;
      dicStage = DictionaryStage.firstzis;
      firstZiIndex = 0;
    });
  }

  void processEditInput() {
 //   final String text = _editController.text.toLowerCase();
 //   final String text = _editController.text;
 //   _editController.value = _editController.value.copyWith(
//       text: _editController.text,
 //     selection: TextSelection(baseOffset: text.length, extentOffset: text.length),
 //     composing: TextRange.empty,
 //   );

    if (_editController.text.length > 0) {
      var index = getSearchingListIndexFromChar(_editController.text);
      if (index != -1) {
        setState(() {
          searchingZiIndex = index;
          shouldDrawCenter = true;
          dicStage = DictionaryStage.detailedzi;
          firstZiIndex = Dictionary.getFirstZiIndexByPickingZiIndex(searchingZiIndex);
        });
      }
      else {
        // show error message
        setState(() {
          searchingZiIndex = -1;
          shouldDrawCenter = true;
          dicStage = DictionaryStage.search;
        });
      }
    }
    else {
      setState(() {
        searchingZiIndex = 99999;
      });
    }
  }

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
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // reinit
 //   if (_editController != null) {
 //     _editController.text = "";
 //   }

    screenWidth = Utility.getScreenWidth(context);

    var posi = thePositionManager.getCenterZiPosi();

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Hanzishu One Tap Dictionary"),  //汉字树一触字典
        ),
      body: getContainer(),
      );
  }

  Future<bool>_onWillPop() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }

    return Future.value(true);
  }

  Widget getContainer() {
    //Note: Search is disabled right now. Dictinary should be a simpler form than search/typing.
    /*
    if (dicStage == DictionaryStage.search) {
      return Column(
        children:<Widget>[
          Container(
            alignment: Alignment.topLeft,
            //padding: const EdgeInsets.all(10),
            child: Row(
              children:<Widget>[
                Container(
                  child: getGoHomeButton(),
                ),
                Container(
                  child: Text("Searching",style: TextStyle(color:Colors.blueAccent,fontSize:20),),
                ),
              ]
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: Text("Type a zi to search (ex: '好') using Hanzishu Input method:[Note: not yet implemented.]",style: TextStyle(color:Colors.blueAccent,fontSize:20),),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: _editController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            )
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: getSearchErrorMessage(),
          )
        ]
      );
    }
    */
    /*
    else if (dicStage == DictionaryStage.firstzis) {
      return Column(
          mainAxisSize: MainAxisSize.min,
        children:<Widget>[
          Row(
              children:<Widget>[
                Text("First Character Table (首字表)",
                            style: TextStyle(color:Colors.blueAccent,
                                fontSize:20),
                            textAlign: TextAlign.left),
                getHelpButton(),
              ]
          ),

          getWillPopScope(),
        ]
      );
    }
    */
    //else {
      return Container(
        child: getWillPopScope(),
      );
    //}
  }

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

  Widget getWillPopScope() {
    return WillPopScope(
        child: CustomPaint(
          foregroundPainter: DictionaryPainter(
              Colors.amber,
              //lessonId: widget.lessonId,
              screenWidth,
              //screenWidth: screenWidth,
              dicStage,
              firstZiIndex,
              searchingZiIndex,
              context
          ),
          child: Center(
            child: Stack(
                children: displayCharsAndCreateHittestButtons(context)
            ),
          ),
        ),
        onWillPop: _onWillPop
    );
  }

  showOverlay(BuildContext context, double posiX, double posiY, String meaning) {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
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
            _editController.text = "";
          }
          else if (dicStage == DictionaryStage.searchingzis) {
            this.searchingZiIndex = ziIndex;
            dicStage = DictionaryStage.detailedzi;
            _editController.text = "";
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
          _editController.text = "";
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
          _editController.text = "";
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

      int baseStrokeCount = theSearchingZiList[searchingZiId].strokeCount;
      int newCharCount = 0;
      int previousNetStrokeCount = 0;
      int currentNetStrokeCount = 0;

      var count = 0;
      for (var j = 0; j < 16; j++) {
        for (var i = 0; i < actualColumnCount.value; i++) {
          var searchingZi = theSearchingZiList[searchingZiId];
          currentNetStrokeCount = searchingZi.strokeCount - baseStrokeCount;

          if ((previousNetStrokeCount == 0 && currentNetStrokeCount != previousNetStrokeCount) || (newCharCount >= DictionaryPainter.minCharsForStrokeIndex && currentNetStrokeCount != previousNetStrokeCount)) {
            newCharCount = 0;
            previousNetStrokeCount = currentNetStrokeCount;
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
            previousNetStrokeCount = currentNetStrokeCount;

            searchingZiId++;
            count++;

            if (count > length) {
              CreateNavigationHitttestButtons(
                  DictionaryStage.searchingzis, buttons);
              return buttons; // stop the loop
            }
          }
        }
      }
    }
    else if (dicStage == DictionaryStage.detailedzi) {
      // for speech icon
      var positionAndSize = PositionAndSize(70.0, 278.0/*358.0*/, 30.0, 30.0, 0.0, 0.0);
      var posi = getPositionedSpeechButton(positionAndSize, searchingZiIndex);
      buttons.add(posi);

      CreateNavigationHitttestButtons(DictionaryStage.detailedzi, buttons);
    }
    else if (dicStage == DictionaryStage.help) {
      CreateNavigationHitttestButtons(DictionaryStage.detailedzi, buttons);
    }

    return buttons;
  }
}
