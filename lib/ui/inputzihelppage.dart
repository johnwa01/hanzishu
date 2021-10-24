
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


class InputZiHelpPage extends StatefulWidget {
  InputZiHelpPage();

  @override
  _InputZiHelpPageState createState() => _InputZiHelpPageState();
}

class _InputZiHelpPageState extends State<InputZiHelpPage> {
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
        title: Text("Introduction"),
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
    }

    return Future.value(true);
  }

  showOverlay(BuildContext context, keyGroup, keyIndex) {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
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
    var fontSize = 18.0;
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: fontSize/2),
          Flexible(
            child: Text(
                "Hanzishu Component Input Method is a 'what you see is what you type' method. Like typing letters of an English word through keyboard, you type the components of a Chinese character through keyboard in sequence according to components/keyboard mapping.",
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.left
            ),
          ),
          SizedBox(height: fontSize),
          Flexible(
            child: Text(
                "This app provides the preparation steps to remember the keyboard positions of those Lead Components and to be familiar with their Expanded Components. It also provides some guided typing so that you can speed up fast. After that, you can start your own typing.",
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.left
            ),
          ),
          SizedBox(height: fontSize +3),
          Flexible(
            child: Text(
              "Steps to type a Chinese character",
              style: TextStyle(fontSize: fontSize + 3, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left
            ),
          ),
          SizedBox(height: fontSize),
          Flexible(
            child: Text(
                "1. According to rules listed in Note 1, divide the character into components (Lead Components or Expanded Components).",
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.left
            ),
          ),
          SizedBox(height: fontSize),
          Flexible(
            child: Text(
                "2. According to the components/keyboard mapping in Note 2, type the character's components in sequence through keyboard.",
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.left
            ),
          ),
          SizedBox(height: fontSize),
          Flexible(
            child: Text(
                "a. If the character has only 1 component, type the component first, then you can type up to 3 strokes: first, second, and last stroke.",
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.left
            ),
          ),
          Flexible(
            child: Text(
                "All the turning strokes map to '乙' as shown below:",
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.left
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset(
                "assets/typing/Strokes.png",
                width: 400.0,
                height: 250.0),
          ),
          SizedBox(height: fontSize),
          Flexible(
            child: Text(
                "b. If the character has 2 components, type them first, then you can type two strokes: last stroke of each of the two components.",
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.left
            ),
          ),
          SizedBox(height: fontSize),
          Flexible(
            child: Text(
                "c. If the character has 3 or more components, type all of the components in sequence.",
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.left
            ),
          ),
          SizedBox(height: fontSize),
          Flexible(
            child: Text(
                "3. You can pick the desired character whenever you see it from the list below typing field.",
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.left
            ),
          ),
          SizedBox(height: fontSize),
          Flexible(
            child: Text(
              "Note 1: The rules for breaking character into components:\n--Don't break strokes that are crossed through each other, ex: never break the strokes of character '井' into separate components, unless you are reading its strokes.;\n--Ok to break two strokes if they are disconnected or just touched, ex: '明' into '日' and '月', '古' into '十' and '口';\n--Break into bigger components if available, ex: '房' into '户' and '方' instead of into 4 coomopnents;",
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              //overflow: TextOverflow.ellipsis,
              //maxLines: 4
            ),
          ),
          SizedBox(height: fontSize),
          Flexible(
            child: Text(
              "Note 2: The Lead Components and keyboard mapping are shown below. You can click them to see their Expanded Components associated to them. To type a Lead Component or its Expanded Component, simply type the corresponding keyboard key.",
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              //overflow: TextOverflow.ellipsis,
              //maxLines: 4
            ),
          ),
          SizedBox(height: fontSize),

          Row(
              children: <Widget>[
                Flexible(child: getOneKeyboardButton(1, 5)),
                Flexible(child: getOneKeyboardButton(1, 4)),
                Flexible(child: getOneKeyboardButton(1, 3)),
                Flexible(child: getOneKeyboardButton(1, 2)),
                Flexible(child: getOneKeyboardButton(1, 1)),
                SizedBox(width: fontSize + 2),
                Flexible(child: getOneKeyboardButton(2, 1)),
                Flexible(child: getOneKeyboardButton(2, 2)),
                Flexible(child: getOneKeyboardButton(2, 3)),
                Flexible(child: getOneKeyboardButton(2, 4)),
                Flexible(child: getOneKeyboardButton(2, 5)),
              ]
          ),
          Row(
              children: <Widget>[
                Flexible(child: getOneKeyboardButton(3, 5)),
                Flexible(child: getOneKeyboardButton(3, 4)),
                Flexible(child: getOneKeyboardButton(3, 3)),
                Flexible(child: getOneKeyboardButton(3, 2)),
                Flexible(child: getOneKeyboardButton(3, 1)),
                SizedBox(width: fontSize + 2),
                Flexible(child: getOneKeyboardButton(4, 1)),
                Flexible(child: getOneKeyboardButton(4, 2)),
                Flexible(child: getOneKeyboardButton(4, 3)),
                Flexible(child: getOneKeyboardButton(4, 4)),
                Flexible(child: getOneKeyboardButton(0, 0)),
              ]
          ),
          Row(
              children: <Widget>[
                Flexible(child: getOneKeyboardButton(0, 0)),
                Flexible(child: getOneKeyboardButton(5, 4)),
                Flexible(child: getOneKeyboardButton(5, 3)),
                Flexible(child: getOneKeyboardButton(5, 2)),
                Flexible(child: getOneKeyboardButton(5, 1)),
                SizedBox(width: fontSize + 2),
                Flexible(child: getOneKeyboardButton(6, 1)),
                Flexible(child: getOneKeyboardButton(6, 2)),
                Flexible(child: getOneKeyboardButton(0, 0)),
                Flexible(child: getOneKeyboardButton(0, 0)),
                Flexible(child: getOneKeyboardButton(0, 0)),
              ]
          ),
          SizedBox(height: fontSize),
          Flexible(
            child: Text(
                "Note 3: Full component mapping:",
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.left
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset(
            "assets/typing/FullComponents.png",
            width: 400.0,
            height: 250.0),
          ),
          //     SizedBox(height: 18),
        ]
    );
  }
}

