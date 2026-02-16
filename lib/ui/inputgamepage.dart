import 'package:flutter/material.dart';
import 'package:hanzishu/data/searchingzilist.dart';
//import 'package:hanzishu/ui/InputGamecorepage.dart';
import 'dart:ui';
import 'dart:async';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/inputzi.dart';

class InputGamePage extends StatefulWidget {
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  late PositionAndSize centerPositionAndSizeCache;
  final String? gameid;

  InputGamePage({required this.gameid});

  @override
  _InputGamePageState createState() => _InputGamePageState();
}

class _InputGamePageState extends State<InputGamePage> with SingleTickerProviderStateMixin {
  int searchingZiIndex = -1;
  late bool shouldDrawCenter;
  late double screenWidth;
  //late String initZis;
  late String? currentGameId;


  FocusNode _textNode = new FocusNode();

  late TextEditingController _controller;

  int compoundZiComponentNum = 0;
  List<int> compoundZiAllComponents = [];
  Timer? compoundZiAnimationTimer;
  int compoundZiCurrentComponentId = -1;
  var currentZiListType = ZiListType.searching;

  String inputText = '';
  int currentIndex = 0;

  bool gridShowZi = true;

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();

    currentGameId = widget.gameid;

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
      launchInputGame(this.currentIndex);
    }
    else {
      theIsBackArrowExit = true;
      this.currentIndex = 0;
    }
    //}
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    //initZis = widget.initZis;
    //if (initZis == null) {
    //  initZis = "合体字练习部件非笔画";
    //}
    _controller = new TextEditingController(text: ""/*initZis*/);

    /*"Grid shows Hanzi"*/
    var gridShowOrNotShowZiString = gridShowZi ? getString(452) : getString(453);/*"Grid (not) show Hanzi"*/;
    String displ = "";
    if (theDefaultLocale == "en_US") {
      displ = getString(408); // copy/paste ...
    }

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
                            Text(displ/*"Type or copy/paster all your words below"*/, style: TextStyle(fontSize: 16 * getSizeRatioWithLimit(), color: Colors.blueGrey), ),
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

    // should not reach here
    return SizedBox(width: 0.0, height: 0.0);
  }

  processInputs() {
    //var latestValue;
    var ziId = -1;
    //if (_controller.value.text != null && _controller.value.text.length != 0) {
      inputText = _controller.value.text;
      //valid the input string here!
      //var resultStr = DictionaryManager.validateChars(inputText);
      if (inputText.length == 0) {
        showInvalidInputDialog();
      }
      else {
        //if (inputText.length != inputText.length) {
        //  inputText = resultStr;
        //}

        launchInputGame(int.parse(currentGameId!));
      }
    //}
    //else {
      // assert
    //}
  }

  launchInputGame(int gameid) {
    //var ziId = DictionaryManager.getSearchingZiId("灵"/*inputText[index]*/);
    //inputText = "灵巧的"; //TODO
    if (inputText != null && inputText.length > 0) {
      //_controller.clear();
      //FocusScope.of(context).unfocus();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              InputZiPage(typingType: TypingType.InputGame, lessonId: int.parse(currentGameId!), wordsStudy: '', isSoundPrompt: false, inputMethod: InputMethod.Pinxin, showHint: HintType.Hint1, includeSkipSection: false, showSwitchMethod: false), //InputZiPage(),
        ),
      );
    }
    else {
      showInvalidInputDialog();
    }
  }

  showInvalidInputDialog() {
    // set up the button
    Widget okButton = TextButton(
      child: Text(getString(286)/*Ok*/, style: TextStyle(color: Colors.blue)),
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
