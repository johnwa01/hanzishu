
import 'package:flutter/material.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/engine/quizmanager.dart';
import 'dart:ui';
import 'dart:async';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/ui/dictionarypainter.dart';
import 'package:hanzishu/ui/dictionaryhelppage.dart';
import 'package:hanzishu/ui/dictionarysearchingpage.dart';
import 'package:hanzishu/data/firstzilist.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/ui/drillpage.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/ui/quizpage.dart';

class StudyCustomizedWordsPage extends StatefulWidget {
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  PositionAndSize centerPositionAndSizeCache;

  @override
  _StudyCustomizedWordsPageState createState() => _StudyCustomizedWordsPageState();
}

class _StudyCustomizedWordsPageState extends State<StudyCustomizedWordsPage> with SingleTickerProviderStateMixin {
  int searchingZiIndex;
  bool shouldDrawCenter;
  double screenWidth;
  //DictionaryStage dicStage;
  //OverlayEntry overlayEntry;
  // PositionAndMeaning previousPositionAndMeaning = PositionAndMeaning(
  //     0.0, 0.0, "");
  FocusNode _textNode = new FocusNode();

  TextEditingController _controller = new TextEditingController(text: "");

  int compoundZiComponentNum = 0;
  List<int> compoundZiAllComponents = [];
  var compoundZiAnimationTimer;
  int compoundZiCurrentComponentId;
  var currentZiListType = ZiListType.searching;

  String inputText;
  int currentIndex = 0;

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();

    theCurrentCenterZiId = searchingZiIndex;
    //_controller.addListener(handleKeyInput);

    setState(() {
      searchingZiIndex = searchingZiIndex;
      shouldDrawCenter = true;
      compoundZiComponentNum = 0;

      searchingZiIndex = 0;
      //dicStage = DictionaryStage.firstzis;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getRequests() async {
    this.currentIndex += 1;

    if (!theIsBackArrowExit && this.currentIndex <= 3) { //TODO: 3 is the number of current subtasks in study new words
      // reinit
      theIsBackArrowExit = true;
      launchContent(this.currentIndex);
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
    compoundZiCurrentComponentId = searchingZiIndex;
    int compoundZiTotalComponentNum = 0;

    // TODO: components don't seem relative here
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

    try {
      return Scaffold
        (
        appBar: AppBar
          (
          title: Text(getString(409)/*"Customized customized words"*/),
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
                            //SizedBox(width: 30 * getSizeRatioWithLimit()),
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
                              //decoration: InputDecoration(
                              //hintText: 'Test text',
                              //),

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
    //TODO: contentIndex++
    if (_controller.value.text != null && _controller.value.text.length != 0) {
      inputText = _controller.value.text;

      if (inputText != null && inputText.length > 0) {
        var resultStr = DictionaryManager.validateChars(inputText);
        if (resultStr.length == 0) {
          showInvalidInputDialog();
        }
        else {
          if (resultStr.length != inputText.length) {
            inputText = resultStr;
          }

          //inputText = "灵巧的"; //TODO: uncomment this line to test under Android simulator
          // TODO: Check content of inputText.
          launchContent(0);
        }
      }
    }
    else {
      // assert
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

  launchContent(int contentIndex) {
      //_controller.clear();
      //FocusScope.of(context).unfocus();
      switch (contentIndex) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DrillPage(drillCategory: DrillCategory.custom, subItemId: 1, customString: inputText),
            ),
          ).then((val) => {_getRequests()});
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DictionarySearchingPage(
                      dicStage: DictionaryStage.detailedzi,
                      firstOrSearchingZiIndex: -1,
                      flashcardList: inputText,
                      dicCaller: DicCaller.WordsStudy),
            ),
          ).then((val) => {_getRequests()});
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  InputZiPage(
                      typingType: TypingType.WordsStudy, lessonId: 0, wordsStudy: inputText),
            ),
          ).then((val) => {_getRequests()});
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  QuizPage(quizTextbook: QuizTextbook.wordsStudy, lessonId: 0, wordsStudy: inputText),
            ),
          ).then((val) => {_getRequests()});
          break;
        default:
          break;
    }
  }

  Future<bool>_onWillPop() {
    return Future.value(true);
  }

}
