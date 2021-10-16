//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:hanzishu/ui/reviewpage.dart';
import 'package:hanzishu/ui/quizresultpage.dart';
import 'package:hanzishu/engine/statisticsmanager.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/studytimepage.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/ui/componentpage.dart';

class InputZiHelpPage extends StatefulWidget {
  @override
  _InputZiHelpPageState createState() => _InputZiHelpPageState();
}

class _InputZiHelpPageState extends State<InputZiHelpPage> {
  OverlayEntry overlayEntry;
  int previousOverlayGroup = 0;
  int previousOverlayIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Help on Typing Chinese Characters"),
      ),
      body: Center
        (
        child: WillPopScope(
            child: getHelpContentView(context),
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
                left: 120.0, //posiX,
                child: Image.asset(
                  "assets/typing/" + fullExpandedComp.imageName,
                  width: 150.0,
                  height: 180.0,
                  //fit: BoxFit.fitWidth,
                ),
              ));
      overlayState.insert(overlayEntry);
      previousOverlayGroup = keyGroup;
      previousOverlayIndex = keyIndex;
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
    return Column(
        children: <Widget>[
          Flexible(
            child: Text(
              "Steps to type a character",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              //textAlign: TextAlign.left
            ),
          ),
          SizedBox(height: 18),
          Flexible(
            child: Text(
                "1. Divide the character into components. (Don't break strokes that are crossed through each other.)",
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.left
            ),
          ),
          SizedBox(height: 18),
          Flexible(
            child: Text(
                "2a. For character with 1 component, type it first, then its 1st, 2nd, and last stroke.",
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.left
            ),
          ),
          Flexible(
            child: Text(
                "2b. For character with 2 components, type them first, then last stroke of the 1st and 2nd component.",
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.left
            ),
          ),
          Flexible(
            child: Text(
              "2c. For character with 3 or more components, type all of the components in sequence.",
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.left
            ),
          ),
          SizedBox(height: 18),
          Flexible(
            child: Text(
                "3. You can pick the desired character whenever you see it from the list below typing field.",
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.left
            ),
          ),
          SizedBox(height: 18),
          Flexible(
            child: Text(
              "Note: The lead components are shown below and mapped to the keyboard. You can click them to see expanded components associated to them. To type a lead component or its expanded component, simply type the corresponding keyboard key.",
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 4
            ),
          ),
          SizedBox(height: 18),
          /*
          Container(
              alignment: Alignment.center,
              child: Image.asset(
                  "assets/typing/GG1.png",
                  width: 400.0,
                  height: 200.0
              )
          ),
          */
          Row(
            children: <Widget>[
              Flexible(child: getOneKeyboardButton(1, 5)),
              Flexible(child: getOneKeyboardButton(1, 4)),
              Flexible(child: getOneKeyboardButton(1, 3)),
              Flexible(child: getOneKeyboardButton(1, 2)),
              Flexible(child: getOneKeyboardButton(1, 1)),
              SizedBox(width: 20),
              Flexible(child: getOneKeyboardButton(2, 1)),
              Flexible(child: getOneKeyboardButton(2, 2)),
              Flexible(child: getOneKeyboardButton(2, 3)),
              Flexible(child: getOneKeyboardButton(2, 4)),
              Flexible(child: getOneKeyboardButton(2, 5)),
            ]
          ),
          Row(
              children: <Widget>[
                Flexible(child: getOneKeyboardButton(3, 1)),
                Flexible(child: getOneKeyboardButton(3, 2)),
                Flexible(child: getOneKeyboardButton(3, 3)),
                Flexible(child: getOneKeyboardButton(3, 4)),
                Flexible(child: getOneKeyboardButton(3, 5)),
                SizedBox(width: 20),
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
                SizedBox(width: 20),
                Flexible(child: getOneKeyboardButton(6, 1)),
                Flexible(child: getOneKeyboardButton(6, 2)),
                Flexible(child: getOneKeyboardButton(0, 0)),
                Flexible(child: getOneKeyboardButton(0, 0)),
                Flexible(child: getOneKeyboardButton(0, 0)),
              ]
          ),

          SizedBox(height: 18),
/*
          Flexible (
            child: Text(
                "You can go through the preparation stages as shown in the previous page to learn how to type.",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
            ),
          ),
 */
        ]
    );
  }
}