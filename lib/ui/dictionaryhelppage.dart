
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/data/phraselist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/listofzipainter.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/texttospeech.dart';


class DictionaryHelpPage extends StatefulWidget {
  DictionaryHelpPage();

  @override
  _DictionaryHelpPageState createState() => _DictionaryHelpPageState();
}

class _DictionaryHelpPageState extends State<DictionaryHelpPage> {
  double screenWidth;
  ScrollController _scrollController;
  PrimitiveWrapper contentLength = PrimitiveWrapper(0.0);
  OverlayEntry overlayEntry;
  int previousOverlayGroup = 0;
  int previousOverlayIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        //print("offset = ${_scrollController.offset}");
      });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // it is a good practice to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);
    // init positionmanager frame size
    thePositionManager.setFrameWidth(screenWidth);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Help"),
      ),
      body: Container(
        //height: 800.00,

        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: WillPopScope(
              child: getHelpContentView(context),
              onWillPop: _onWillPop
          ),
        ),

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

  showOverlay(BuildContext context, keyGroup, keyIndex) {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
      theDicOverlayEntry = null;
    }

    if (!(keyGroup == 0 && keyIndex == 0) && !(previousOverlayGroup == keyGroup && previousOverlayIndex == keyIndex)) {
      var fullExpandedComp = theComponentManager
          .getFullExpandedComponentByGroupAndIndex(keyGroup, keyIndex);

      OverlayState overlayState = Overlay.of(context);
      overlayEntry = OverlayEntry(
          builder: (context) =>
              Positioned(
                top: 160.0, //posiY,
                left: 80.0, //posiX,
                child: Image.asset(
                  "assets/typing/" + fullExpandedComp.imageName,
                  width: 250.0,
                  height: 300.0,
                  //fit: BoxFit.fitWidth,
                ),
              ));
      overlayState.insert(overlayEntry);
      previousOverlayGroup = keyGroup;
      previousOverlayIndex = keyIndex;
    }
    else {
      previousOverlayGroup = 0;
      previousOverlayIndex = 0;
    }
  }

  Widget getOneKeyboardButton(int keyGroup, int keyIndex)
  {
    var image;
    if (keyGroup == 0 && keyIndex == 0) {
      image = "C00.png"; // the empty image without content
    }
    else {
      image = theComponentManager.getComponentByGroupAndIndex(
          keyGroup, keyIndex).image;
    }

    return FlatButton(
      color: Colors.white,
      textColor: Colors.blueAccent,
      padding: EdgeInsets.zero,
      onPressed: () {
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
          theDicOverlayEntry = null;
        }

        showOverlay(context, keyGroup, keyIndex);
      },
      child: Image.asset(
        "assets/typing/" + image,
        width: 30.0,
        height: 30.0,
        fit: BoxFit.fitWidth,
      ),
    );
  }


  Widget getHelpContentView(BuildContext context) {
    return Column(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: theConst.fontSizes[2] / 2),
          Text(
              "About the Hanzishu One Tap Dictionary",
              style: TextStyle(color: Colors.blue, fontSize: theConst.fontSizes[1]),
              textAlign: TextAlign.start
          ),
          Text(
              "The Hanzishu One Tap Dictionary is organized based on the Basic Character Table which groups Basic Character into groups 1-8. Each number represents the number of strokes for each Basic Character in that group. For example, Basic Characters in group 1 have one stroke. Basic Characters in group 2 have two strokes, and so on. The One Tap Dictionary houses nearly 4,000 Characters, all contained under its corresponding Basic Character.",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          SizedBox(height: theConst.fontSizes[2]),
          Text(
              "Navigate the Hanzishu One Tap Dictionary",
              style: TextStyle(color: Colors.blue, fontSize: theConst.fontSizes[1]),
              textAlign: TextAlign.start
          ),
          Text(
              "   •	Open the Basic Character Table",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "   •	Tap the first Basic Character",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "   •	Select the Character from the list. Note: If it’s not there, the dictionary doesn’t support this character.",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "   •	View the detailed information about the Character",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          SizedBox(height: theConst.fontSizes[2]),
          Text(
              "Identify the Character’s first Basic Character",
              style: TextStyle(color: Colors.blue, fontSize: theConst.fontSizes[1]),
              textAlign: TextAlign.start
          ),
          Text(
              "   •	Ex: Character 你 -> Basic Character 小 (the first and only Basic Character)",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "   •	If a Character’s first Basic Character is 口, but it contains other Basic Characters, select the next Basic Character",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "   	 o	Ex: 听 -> 斤 (skip 口)",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "   •	If a Character doesn’t contain any Basic Characters, select the Character’s first stroke (in group 1)",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "   	 o	Ex: Character 扎 -> Stroke 一 ",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "   	 o	Ex: Character 丝 -> Stroke 乙. Note: all fold strokes map to 乙.",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
        ]
    );
  }
}