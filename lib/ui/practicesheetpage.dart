import 'package:flutter/material.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/ui/practicesheetcorepage.dart';
import 'dart:ui';
import 'dart:async';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/zimanager.dart';

class PracticeSheetPage extends StatefulWidget {
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  PositionAndSize centerPositionAndSizeCache;
  String initZis;

  PracticeSheetPage({this.initZis});

  @override
  _PracticeSheetPageState createState() => _PracticeSheetPageState();
}

class _PracticeSheetPageState extends State<PracticeSheetPage> with SingleTickerProviderStateMixin {
  int searchingZiIndex;
  bool shouldDrawCenter;
  double screenWidth;
  String initZis;


  FocusNode _textNode = new FocusNode();

  TextEditingController _controller;

  int compoundZiComponentNum = 0;
  List<int> compoundZiAllComponents = [];
  var compoundZiAnimationTimer;
  int compoundZiCurrentComponentId;
  var currentZiListType = ZiListType.searching;

  String inputText;
  int currentIndex = 0;

  bool gridShowZi = true;

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();

    theCurrentCenterZiId = searchingZiIndex;

    setState(() {
      gridShowZi = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getRequests() async {
    this.currentIndex += 1;

    if (!theIsBackArrowExit && this.currentIndex <= inputText.length) {
      // reinit
      theIsBackArrowExit = true;
      launchZi(this.currentIndex);
    }
    else {
      // init all variables
      // either true back arrow or all done
      theIsBackArrowExit = true;
      //theIsFromTypingContinuedSection = false;
      this.currentIndex = 0;
    }
    //}
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    initZis = widget.initZis;
    //if (initZis == null) {
    //  initZis = "合体字练习部件非笔画";
    //}
    _controller = new TextEditingController(text: initZis);

    /*"Grid shows Hanzi"*/
    var gridShowOrNotShowZiString = gridShowZi ? getString(452) : getString(453);/*"Grid (not) show Hanzi"*/;

    try {
      return Scaffold
        (
        appBar: AppBar
          (
          title: Text(getString(449)/*"Hanzi practice sheet"*/),
        ),
        body: Container(
            child: WillPopScope(
                child: new Column( //Stack(
                    children: <Widget>[
                      SizedBox(height: 40 * getSizeRatioWithLimit()),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: 10 * getSizeRatioWithLimit()),
                            Text(getString(408)/*"Type or copy/paster all your words below"*/, style: TextStyle(fontSize: 16 * getSizeRatioWithLimit(), color: Colors.blueGrey), ),
                            SizedBox(width: 15 * getSizeRatioWithLimit()),
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle: TextStyle(fontSize: 16.0 * getSizeRatioWithLimit()),
                              ),
                              onPressed: () {
                                setState(() {
                                  gridShowZi = gridShowZi ? false : true;
                                });
                              },
                              child: Text(gridShowOrNotShowZiString,
                                  style: TextStyle(color: Colors.lightBlue)),
                            ),
                          ]
                      ),
                      SizedBox(height: 10 * getSizeRatioWithLimit()),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 10 * getSizeRatioWithLimit()),
                          SizedBox(
                            width: 280 * getSizeRatioWithLimit(), //double.infinity,
                            //height: 120,
                            child: TextField(
                              autocorrect: false,
                              enableSuggestions: false,
                              controller: _controller,
                              focusNode: _textNode,
                              autofocus: false,
                              style: TextStyle(
                                fontSize: 18 * getSizeRatioWithLimit(), //editFontSize * editFieldFontRatio, // 35
                                //height: 1.0 // 1.3
                              ),
                              maxLines: 1,
                              //expands: true,
                              keyboardType: TextInputType.text, //multiline,  //TextInputType.visiblePassword
                              decoration: InputDecoration(
                                //hintText: 'This test',
                                filled: true,
                                fillColor: Colors.grey, //lightBlueAccent, //black12,
                              ),
                            ),//focusNode: _textNode,
                          ),
                          SizedBox(width: 10 * getSizeRatioWithLimit()),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
                            ),
                            onPressed: () {
                              processInputs();
                              /*
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DictionaryHelpPage(),
                                ),
                              );
                              */
                            },
                            child: Text(getString(301)/*"Start"*/,
                                style: TextStyle(color: Colors.lightBlue)),
                          ),
                        ],
                      ),
                    ]
                ),
                onWillPop: _onWillPop
            )
        ),
      );
    } catch (e, s) {
      print(s);
    }
  }

  processInputs() {
    //var latestValue;
    var ziId = -1;
    if (_controller.value.text != null && _controller.value.text.length != 0) {
      inputText = _controller.value.text;
      var resultStr = DictionaryManager.validateChars(inputText);
      if (resultStr.length == 0) {
        showInvalidInputDialog();
      }
      else {
        if (resultStr.length != inputText.length) {
          inputText = resultStr;
        }

        launchZi(0);
      }
    }
    else {
      // assert
    }
  }

  launchZi(int index) {
    //var ziId = DictionaryManager.getSearchingZiId("灵"/*inputText[index]*/);
    //inputText = "灵巧的"; //TODO
    if (inputText != null && inputText.length > 0) {
      //_controller.clear();
      //FocusScope.of(context).unfocus();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PracticeSheetCorePage(flashcardList: inputText, gridShowZi: gridShowZi),
        ),
      );
    }
    else {
      showInvalidInputDialog();
    }
  }

  showInvalidInputDialog() {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(getString(286)/*Ok*/),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(getString(375)/*Result*/),
      content: Text(
          getString(374)/*cannot find: */ + inputText + "."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<bool>_onWillPop() {
    return Future.value(true);
  }
}
