
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
import 'package:hanzishu/ui/drillpagecore.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/ui/quizpage.dart';
import 'package:hanzishu/engine/studywords.dart';
import 'package:hanzishu/ui/breakoutpage.dart';

class StudyCustomizedWordsPage extends StatefulWidget {
  Map<int, PositionAndSize> sidePositionsCache = Map();
  Map<int, List<int>>realGroupMembersCache = Map();
  late PositionAndSize centerPositionAndSizeCache;
  final int titleStringId;
  final String customString;
  final studyType;

  StudyCustomizedWordsPage({required this.titleStringId, required this.customString, required this.studyType});

  @override
  _StudyCustomizedWordsPageState createState() => _StudyCustomizedWordsPageState();
}

class _StudyCustomizedWordsPageState extends State<StudyCustomizedWordsPage> with SingleTickerProviderStateMixin {
  int searchingZiIndex = -1;
  late bool shouldDrawCenter;
  late double screenWidth;
  String customString = '';
  //DictionaryStage dicStage;
  //OverlayEntry overlayEntry;
  // PositionAndMeaning previousPositionAndMeaning = PositionAndMeaning(
  //     0.0, 0.0, "");
  FocusNode _textNode = new FocusNode();

  late TextEditingController _controller;

  int compoundZiComponentNum = 0;
  List<int> compoundZiAllComponents = [];
  Timer? compoundZiAnimationTimer;
  int compoundZiCurrentComponentId = -1;
  var currentZiListType = ZiListType.searching;

  String inputText = '';
  int currentIndex = 0;

  double getSizeRatio() {
    return Utility.getSizeRatio(screenWidth);
  }

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();

    if (widget.studyType == StudyType.typingOnly) {
      currentIndex = 2; // directly set to the typing section
    }

    if (widget.studyType == StudyType.typingOnly) {
      _controller = new TextEditingController(text: "你好！请你将内容复制并粘帖到这里，然后开始练习。");
    }
    else {
      _controller = new TextEditingController(text: "您好吗");
    }

    theCurrentCenterZiId = searchingZiIndex;
    //_controller.addListener(handleKeyInput);
    customString = widget.customString;

    if (customString.length != 0) {
      inputText = customString;
    }

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
    if (widget.studyType == StudyType.typingOnly && currentIndex == 2) {
      theIsBackArrowExit = true;
      //this.currentIndex = 0;
      return; //done for typing only, exit now
    }

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
      List<String> componentCodes = <String>[]; //List<String>();
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

    //screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    screenWidth = Utility.getScreenWidth(context);

    try {
      return Scaffold
        (
        appBar: AppBar
          (
          title: Text(getString(widget.titleStringId)/*"Customized ..."*/),
        ),
        body: Container(
            child: WillPopScope(
                child: new Column( //Stack(
                    children: <Widget>[
                      SizedBox(height: 10 * getSizeRatioWithLimit()), //40
                      getCopyPasteDictionry(),
                      SizedBox(height: 10 * getSizeRatioWithLimit()),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 10 * getSizeRatioWithLimit()),
                          getTextField(),
                          //SizedBox(width: 10 * getSizeRatioWithLimit()),
                        ]
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 10 * getSizeRatioWithLimit()),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
                            ),
                            onPressed: () {
                              processInputs();
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

    //should not reach here
    return SizedBox(width: 0.0, height: 0.0);
  }

  Widget getCopyPasteDictionry() {
    //if (inputText != null) {
    //  return SizedBox(width: 0.0, height: 0.0);
    //}
    //else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 10 * getSizeRatioWithLimit()),
            Text(getString(408) /*"Type or copy/paster all your words below"*/,
              style: TextStyle(fontSize: 16 * getSizeRatioWithLimit(),
                  color: Colors.blueGrey),),
            //SizedBox(width: 30 * getSizeRatioWithLimit()),
          ]
      );
    //}
  }

  Widget getTextField() {
    //if (inputText.length != 0) {
    //  return SizedBox(width: 0.0, height: 0.0);
    //}
    //else {
      return SizedBox(
        width: 340 * getSizeRatio(),
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
            fontSize: 18 *
                getSizeRatioWithLimit(), //editFontSize * editFieldFontRatio, // 35
            //height: 1.0 // 1.3
          ),
          maxLines: 8,
          //expands: true,
          keyboardType: TextInputType.text,
          //multiline,  //TextInputType.visiblePassword
          decoration: InputDecoration(
            //hintText: 'This test',
            filled: true,
            fillColor: Colors.lightBlueAccent, //black12,
          ),
        ), //focusNode: _textNode,
      );
    //}
  }

  processInputs() {
    //var latestValue;
    var ziId = -1;
    if (customString != null && customString.length > 0) {
      inputText = customString;
      launchContent(this.currentIndex);
    }
    //TODO: contentIndex++
    else if (_controller.value.text != null && _controller.value.text.length != 0) {
      inputText = _controller.value.text;

      if (inputText != null && inputText.length > 0) {
        var resultStr =  inputText;
        if (widget.studyType != StudyType.typingOnly) {
           resultStr = DictionaryManager.validateChars(inputText);
        }

        if (resultStr.length == 0) {
          showInvalidInputDialog();
        }
        else {
          if (resultStr.length != inputText.length) {
            inputText = resultStr;
          }

          launchContent(this.currentIndex);
        }
      }
    }
    else {
      // assert
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

  launchContent(int contentIndex) {
      //_controller.clear();
      //FocusScope.of(context).unfocus();
      switch (contentIndex) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DrillPageCore(drillCategory: DrillCategory.custom, startingCenterZiId: 1, subItemId: 1, isFromReviewPage: true ,customString: inputText),
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
          /*
        case 2:
        // should add this to BreakoutPage parameter
          theIsFromLessonContinuedSection = true;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BreakoutPage(lessonId: 0, wordsStudy: inputText),
            ),
          ).then((val) => {_getRequests()});
          break;
          */
        case 2:
          bool includeSkipSection = true;
          if (widget.studyType == StudyType.typingOnly) {
            includeSkipSection = false;
          }

          String convertedText = Utility.convertSpecialChars(inputText);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  InputZiPage(
                      typingType: TypingType.Custom, lessonId: 0, wordsStudy: convertedText, isSoundPrompt: false, inputMethod: InputMethod.Pinxin, showHint: HintType.Hint3, includeSkipSection: includeSkipSection, showSwitchMethod: false),
            ),
          ).then((val) => {_getRequests()});
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  QuizPage(quizTextbook: QuizTextbook.custom, quizCategory: QuizCategory.none, lessonId: 0, wordsStudy: inputText, includeSkipSection: true),
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
