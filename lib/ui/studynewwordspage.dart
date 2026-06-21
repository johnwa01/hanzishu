
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
import 'package:hanzishu/engine/inputzimanager.dart';
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
      List<String> componentCodes = <String>[];
      if (compoundZiAllComponents == null || compoundZiAllComponents.length == 0) {
        DictionaryManager.getAllComponents(searchingZiIndex, componentCodes);
        DictionaryManager.getComponentIdsFromCodes(
            componentCodes, compoundZiAllComponents);
      }

      compoundZiTotalComponentNum = compoundZiAllComponents.length;

      if (compoundZiComponentNum == compoundZiTotalComponentNum + 1) {
        compoundZiCurrentComponentId = searchingZiIndex;
        currentZiListType = ZiListType.searching;
        shouldDrawCenter = true;
      }
      else {
        compoundZiCurrentComponentId = compoundZiAllComponents[compoundZiComponentNum - 1];
        currentZiListType = ZiListType.component;
      }
    }

    screenWidth = Utility.getScreenWidth(context);

    try {
      return Scaffold(
        backgroundColor: Color(0xFFF8F3FF),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: WillPopScope(
            onWillPop: _onWillPop,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 860),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildHeroSection(),
                      SizedBox(height: 22),
                      _buildContentCard(),
                      SizedBox(height: 22),
                      _buildStartSection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e, s) {
      print(s);
    }

    //should not reach here
    return SizedBox(width: 0.0, height: 0.0);
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(26, 24, 26, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF4EEFF),
            Color(0xFFFDFBFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xFFE2D6FA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  getString(widget.titleStringId),
                  style: TextStyle(
                    fontSize: 28,
                    height: 1.12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4E2B91),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Practice any text with Hanzishu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7B6D95),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Paste Chinese text, stories, articles, or lesson content to create your own typing exercise.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: Color(0xFF2B2140),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 18),
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              color: Color(0xFFEDE5FF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.edit_note_rounded,
              size: 62,
              color: Color(0xFF6A35B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Color(0xFFE6DFF6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Color(0xFFEDE5FF),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.subject_rounded,
                  color: Color(0xFF6A35B8),
                  size: 22,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Content',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4E2B91),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    getString(408),
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7B6D95),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 18),
          getTextField(),
          SizedBox(height: 10),
          Text(
            _controller.text.length.toString() + ' / 10,000 characters',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF8A819A),
            ),
          ),
          SizedBox(height: 20),
          _buildIdeasBar(),
        ],
      ),
    );
  }

  Widget _buildIdeasBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFFF5EFFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        spacing: 18,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF6A35B8), size: 22),
              SizedBox(width: 8),
              Text(
                'Try these ideas',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF4E2B91),
                ),
              ),
            ],
          ),
          Text('•  Lesson content', style: TextStyle(color: Color(0xFF4E2B91))),
          Text('•  Short stories', style: TextStyle(color: Color(0xFF4E2B91))),
          Text('•  Competition passages', style: TextStyle(color: Color(0xFF4E2B91))),
          Text('•  Chinese articles', style: TextStyle(color: Color(0xFF4E2B91))),
        ],
      ),
    );
  }

  Widget _buildStartSection() {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 260,
          height: 54,
          child: RawMaterialButton(
            fillColor: Color(0xFF6A35B8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            onPressed: () {
              processInputs();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
                SizedBox(width: 8),
                Text(
                  getString(301),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.shield_outlined, size: 18, color: Color(0xFF6A35B8)),
            SizedBox(width: 6),
            Text(
              'Your text is used only for practice and not stored.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF7B6D95),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget getCopyPasteDictionry() {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        getString(408),
        style: TextStyle(
          fontSize: 16 * getSizeRatioWithLimit(),
          color: Color(0xFF7B6D95),
        ),
      ),
    );
  }

  Widget getTextField() {
    return TextField(
      autocorrect: false,
      enableSuggestions: false,
      controller: _controller,
      focusNode: _textNode,
      autofocus: false,
      style: TextStyle(
        fontSize: 18 * getSizeRatioWithLimit(),
        height: 1.35,
        color: Color(0xFF2B2140),
      ),
      maxLines: 8,
      keyboardType: TextInputType.multiline,
      onChanged: (value) {
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: 'Paste Chinese text here...',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFFDCD4EE), width: 1.3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFF8B63D9), width: 1.8),
        ),
      ),
    );
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
        else { // typingOnly
          resultStr = InputZiManager.validateChars(inputText);
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
                    typingType: TypingType.Custom, lessonId: 0, wordsStudy: convertedText, isSoundPrompt: false, inputMethod: InputMethod.Pinxin, showHint: HintType.Hint1, includeSkipSection: includeSkipSection, showSwitchMethod: false),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                QuizPage(quizTextbook: QuizTextbook.custom, quizCategory: QuizCategory.none, lessonId: 0, wordsStudy: inputText, includeSkipSection: true, showCompletedDialogOnSkip: true,),
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
