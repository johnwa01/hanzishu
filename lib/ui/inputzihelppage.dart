
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
                top: 100.0, //posiY,
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
      image = "C00.png"; // the empty image without content, actual LC00.png
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
        "assets/components/L" + image,
        width: 30.0,
        height: 55.0,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget getHelpContentView(BuildContext context) {
    var fontSize = 18.0;
    return Column(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: theConst.fontSizes[2] / 2),

          Text(
              "What are Components?",
              style: TextStyle(color: Colors.blue, fontSize: theConst.fontSizes[1]),
              textAlign: TextAlign.start
          ),
          Text(
              "Components are elements of a Character. The Hanzishu Component Input Method breaks Components into two types. Lead Components are the base Components. And each Lead Component houses a collection of sub-components called Expanded Components.",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          SizedBox(height: theConst.fontSizes[2]),
          Text(
              "How it works",
              style: TextStyle(color: Colors.blue, fontSize: theConst.fontSizes[1]),
              textAlign: TextAlign.start
          ),
          Text(
              "The Hanzishu Component Input Method matches each Lead Component with a key on the English keyboard to create a Component-key pairing. Reference this chart to visualize how Lead Components are mapped to English letters.",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          SizedBox(height: theConst.fontSizes[2]),

          Row(
              children: <Widget>[
                Flexible(child: getOneKeyboardButton(1, 5)),
                Flexible(child: getOneKeyboardButton(1, 4)),
                Flexible(child: getOneKeyboardButton(1, 3)),
                Flexible(child: getOneKeyboardButton(1, 2)),
                Flexible(child: getOneKeyboardButton(1, 1)),
                SizedBox(width: fontSize),
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
                SizedBox(width: fontSize),
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
                SizedBox(width: fontSize),
                Flexible(child: getOneKeyboardButton(6, 1)),
                Flexible(child: getOneKeyboardButton(6, 2)),
                Flexible(child: getOneKeyboardButton(0, 0)),
                Flexible(child: getOneKeyboardButton(0, 0)),
                Flexible(child: getOneKeyboardButton(0, 0)),
              ]
          ),
          SizedBox(height: theConst.fontSizes[2]),
          Text(
              "Expanded Components are grouped under each Lead Component-key pairing. To type in Chinese, Components are grouped into sequences of English letters. Each sequence of Components creates a Character.",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          SizedBox(height: theConst.fontSizes[2]),
          Text(
              "The Typing section of this app will:",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	Introduce you to Lead & Expanded Components ",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	Teach you the Component-key pairings and typing method",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	Help you memorize the Component-key pairings",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	Help you practice with guided and free typing",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "By the time you finish, you’ll be ready to type in Chinese on your own!",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          SizedBox(height: theConst.fontSizes[2]),
          Text(
              "Tips",
              style: TextStyle(color: Colors.blue, fontSize: theConst.fontSizes[1]),
              textAlign: TextAlign.start
          ),
          SizedBox(height: theConst.fontSizes[2]),
          Text(
              "Tip 1: Want to use what you type elsewhere? Double click the content in the editing field to copy.",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          SizedBox(height: theConst.fontSizes[2]),
          Text(
              "Tip 2: The Dos and Don’ts of breaking up a Character into Components.",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	DON’T break up Strokes that cross through each other.",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "    o	 ex: Character 井 doesn’t split into separate Components",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	DO break up two strokes that are next to each other or just touching.",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "    o	ex: 明 -> 日 and 月",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "    o	ex: 古 -> 十 and 口 ",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	DO break up Characters into as few Components as possible.",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "    o	ex: 房 -> 户 and 方 (instead of four Components)",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	DO break up Characters into the Component with the most  strokes. ",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "    o	ex: 云 -> 一 (plus another Component with three strokes)",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          SizedBox(height: theConst.fontSizes[2]),
          Text(
              "Tip 3: The Lead Components and their keyboard pairings are visualized on the keyboard chart above.",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	Tap or hold each Lead Component in the chart to see the Expanded Components associated to them.",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	During typing, select Shift+z to show the Component-key pairings. Select Shift+ any key (except z) to show the Expanded Components.",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	To type a Lead Component or its Expanded Component, simply type the corresponding keyboard key.",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          SizedBox(height: theConst.fontSizes[2]),
          Text(
              "Tip 4: Use this table to learn all the Strokes.",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset(
                "assets/typing/Strokes.png",
                width: 390.0,
                height: 150.0),
          ),
          SizedBox(height: theConst.fontSizes[2]),
          Text(
              "How to type a Chinese Character ",
              style: TextStyle(color: Colors.blue, fontSize: theConst.fontSizes[1]),
              textAlign: TextAlign.start
          ),
          Text(
              "1.	Divide the character into components (Lead Components or Expanded Components).",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  a.	If a Character has one Component:",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "    i.	Type the Component",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "    ii.	If the Character doesn’t appear on the list:",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "      1.	Type up to three make-up Strokes (the first, second, and the last stroke of the Component) until the Character appears",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "      2.	Treat all fold Strokes as a Component 乙",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  b.	If a Character has two Components:",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "    i.	 Type the two Components first",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "    ii.	If the Character doesn’t appear on the list:",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "      1.	Type two make-up Strokes (the last Stroke of each Component) until the Character appears",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "      2.	Treat all fold Strokes as a Component 乙",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  c.	If a Character has three or more Components:",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "    i.	Type as many Components as necessary in sequence until the Character appears",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          SizedBox(height: theConst.fontSizes[2]),
          Text(
              "In action ",
              style: TextStyle(color: Colors.blue, fontSize: theConst.fontSizes[1]),
              textAlign: TextAlign.start
          ),
          Text(
              "Ex: Type the Chinese character 品",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	Find the first Component 口",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	Find the corresponding key i",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	Tap it",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	If 品 appears in the Character list (below the editing field), select it by:",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "    o	Tapping the Character",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "    o	 Tapping the spacebar if it’s first in the list",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	If the Character is not listed, repeat the these steps with the second and third Components until you see 品 listed",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
          Text(
              "  •	The English letters in the editing field automatically convert to 品.",
              style: TextStyle(fontSize: theConst.fontSizes[2]),
              textAlign: TextAlign.start
          ),
        ]
    );
  }
}

