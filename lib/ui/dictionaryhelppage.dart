
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
    double fontSize = 18.0;

    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Text(
              "Steps to find a Chinese character",
              style: TextStyle(fontSize: fontSize + 5, fontWeight: FontWeight.bold),
              //textAlign: TextAlign.left
            ),
          ),
          SizedBox(height: fontSize),
          Flexible(
            child: Text(
                "1. From the Basic Character Table, find and tap the FIRST Basic Character that this character contains.\nEx: For Character '你'， tap '小' which is the only/first Basic Character it contains.",
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.left
            ),
          ),
          SizedBox(height: fontSize),
          Flexible(
            child: Text(
                "1a. If the character's first Basic Character is '口' and it also contains other Basic Character(s) that are not '口', tap the first other Basic Character.\nEx: For character '听'， skip '口' and tap '斤'.",
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.left
            ),
          ),
          SizedBox(height: fontSize),
          Flexible(
            child: Text(
                "1b. If the character doesn't contain any Basic Character, get the first stroke of the character and tap the corresponding one at the beginning of the table. Note that all of the fold strokes map to '乙'.\nEx: For character '扎'， tap stroke '一'; for character '丝', tap stroke '乙'.",
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.left
            ),
          ),
          SizedBox(height: fontSize),
          Flexible(
            child: Text(
                "2. With ONE tap above, you will SEE the character you are looking for in a list. Otherwise, the dictionary doesn't support this character.",
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.left
            ),
          ),
          SizedBox(height: fontSize),
          Flexible(
            child: Text(
              "3. You can then choose the character to read its detailed info.",
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              //overflow: TextOverflow.ellipsis,
              //maxLines: 4
            ),
          ),
          SizedBox(height: fontSize),
          Flexible(
            child: Text(
              "Note: The number within the [] of Basic Character Table is the starting stroke count in that group. Same with the character list page.",
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.left,
              //overflow: TextOverflow.ellipsis,
              //maxLines: 4
            ),
          ),
          //     SizedBox(height: 18),
        ]
    );
  }
}