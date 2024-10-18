
import 'package:flutter/material.dart';
import 'package:hanzishu/engine/quizmanager.dart';
import 'dart:ui';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/paintsoundmanager.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/data/paintsoundlist.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/ui/dictionarysearchingpage.dart';
import 'package:hanzishu/ui/drillpagecore.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/ui/quizpage.dart';
import 'package:hanzishu/ui/dictionarypage.dart';
import 'package:hanzishu/ui/breakoutpage.dart';
import 'package:hanzishu/engine/drill.dart';
import 'dart:async';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/engine/zimanager.dart';

class PaintSoundPage extends StatefulWidget {
  final SoundCategory currentSoundCategory;
  final int currentSoundViewIndex;

  PaintSoundPage(this.currentSoundCategory, this.currentSoundViewIndex);

  @override
  _PaintSoundPageState createState() => _PaintSoundPageState();
}

class _PaintSoundPageState extends State<PaintSoundPage> {
  double? screenWidth;
  ScrollController? _scrollController;
  PrimitiveWrapper contentLength = PrimitiveWrapper(0.0);
  OverlayEntry? overlayEntry = null;
  int previousOverlayGroup = 0;
  int previousOverlayIndex = 0;

  SoundCategory? currentSoundCategory;
  int currentSoundViewIndex = 1;
  int currentSoundViewSubIndex = 1;
  int MaxIntroSoundView = 13; // temp number for 200
  int currentStudyIndex = 0;
  /*
  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }
*/

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();
    currentSoundCategory = widget.currentSoundCategory;
    currentSoundViewIndex = widget.currentSoundViewIndex;

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

    var label;
    if (currentSoundCategory == SoundCategory.intro) {
      label = getString(423)/*"Paint sound symbols"*/;
    }
    else if (currentSoundCategory == SoundCategory.erGe) {
      label = getString(424)/*"Children's songs"*/;
    }
    else if (currentSoundCategory == SoundCategory.tongYao) {
      label = getString(425)/*"Children's folks"*/;
    }
    else if (currentSoundCategory == SoundCategory.tongHua) {
      label = getString(426)/*"Children's fairy tales"*/;
    }

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(label),
      ),
      body: Container(
        //height: 800.00,

        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: WillPopScope(
              child: getPaintSoundView(context),
              onWillPop: _onWillPop
          ),
        ),

      ),
    );
  }

  initOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
      theDicOverlayEntry = null;
    }
  }

  Future<bool>_onWillPop() {
    initOverlay();

    return Future.value(true);
  }

  showOverlay(BuildContext context, double posiX, double posiY, String pinyinAndMeaning) {
    initOverlay();
    var adjustedXValue = Utility.adjustOverlayXPosition(posiX, screenWidth);

    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) =>Positioned(
            top: posiY,
            left: adjustedXValue,
            child: TextButton(
              child: Text(pinyinAndMeaning, style: TextStyle(fontSize: 20.0, color: Colors.white),),
              //color: Colors.blueAccent,
              //textColor: Colors.white,
              onPressed: () {initOverlay();},
            )
        ));
    overlayState.insert(overlayEntry!);
  }

  Widget getOneKeyboardButton(int keyGroup, int keyIndex)
  {
    var imageIndex = PaintSoundManager.getXIndex(keyGroup, keyIndex);
    var path = "assets/paintx/x1_";
    if (currentSoundViewIndex == 2) {
      path = "assets/paintx/x2_";
    }

    return TextButton(
      //color: Colors.white,
      //textColor: Colors.blueAccent,
      //padding: EdgeInsets.zero,
      onPressed: () {
        //initOverlay();

        //showOverlay(context, keyGroup, keyIndex);
        TextToSpeech.speakWithRate("zh-CN", PaintSoundManager.getXChar(keyGroup, keyIndex), 0.1);
      },
      child: Image.asset(
        path + imageIndex.toString() + ".png",
        //width: 150.0 * getSizeRatioWithLimit(),
        //height: 55.0 * getSizeRatioWithLimit(),
        //fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget getPaintSoundView(BuildContext context) {
    if (currentSoundCategory == SoundCategory.intro) {
      return getPaintIntro(context, currentSoundViewSubIndex);
    }
    //else if (currentSoundViewIndex == 0) {
    //  return getPaintIndex(context);
    //}
    else if (currentSoundCategory == SoundCategory.erGe) {
      return getErGeOrTongYao(context);
    }
    else if (currentSoundCategory == SoundCategory.tongYao) {
      return getErGeOrTongYao(context);
    }
    else if (currentSoundCategory == SoundCategory.tongHua) {
      return getTongHua(context);
    }
    else {
      return SizedBox(width: 0.0, height: 0.0);
    }
  }

  Widget getPaintIntro(BuildContext context, int soundViewIndex) {
    var fontSize1 = TheConst.fontSizes[1]; //* getSizeRatioWithLimit();
    var fontSize2 = TheConst.fontSizes[2]; //* getSizeRatioWithLimit();

    var fontSize = 18.0 * getSizeRatioWithLimit();
    var heightGap = 10.0 * getSizeRatioWithLimit();

    return Column(
      //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: fontSize2 / 2),
          Text(
              getString(427)/*"点击每个"*/,
              style: TextStyle(color: Colors.blue, fontSize: fontSize1),
              textAlign: TextAlign.start
          ),
          getOneRow(soundViewIndex, 1),
          SizedBox(height: heightGap),
          getOneRow(soundViewIndex, 3),
          SizedBox(height: heightGap),
          getOneRow(soundViewIndex, 5),
          SizedBox(height: heightGap),
          getOneRow(soundViewIndex, 7),
          SizedBox(height: heightGap),
          getOneRow(soundViewIndex, 9),
          SizedBox(height: heightGap),
          getOneRow(soundViewIndex, 11),
          SizedBox(height: heightGap),
          getOneRow(soundViewIndex, 13),
          SizedBox(height: heightGap),
          getOneRow(soundViewIndex, 15),

          getContinueAndBackButtons(),
        ]
    );
  }

  Widget getOneRow(int groupIndex, int indexInGroup) {
    if (groupIndex == 13 && indexInGroup > 8) {
      return SizedBox(height: 0, width: 0);
    }

    var fontSize = 18.0 * getSizeRatioWithLimit();

    return Row(
        children: <Widget>[
          Flexible(child: getOneKeyboardButton(groupIndex, indexInGroup)),
          SizedBox(width: fontSize * 5),
          Flexible(child: getOneKeyboardButton(groupIndex, indexInGroup + 1)),
        ]
    );
  }

  Widget getNextButton() {
    var buttonText = getString(434);

    if ((currentSoundCategory == SoundCategory.tongHua &&  currentSoundViewSubIndex == theTongHuaPageCount[currentSoundViewIndex-1]) ||
        (currentSoundCategory == SoundCategory.intro &&  currentSoundViewSubIndex == MaxIntroSoundView))
    {
      buttonText = getString(428);
    }

    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
      ),
      onPressed: () {
        if (currentSoundCategory == SoundCategory.intro) {
          if (currentSoundViewSubIndex < MaxIntroSoundView) {
            setState(() {
              currentSoundViewSubIndex += 1;
            });
          }
          else {
            showCompletedDialog(context);
          }
        }
        else if (currentSoundCategory == SoundCategory.tongHua){
          if (currentSoundViewSubIndex < theTongHuaPageCount[currentSoundViewIndex-1]) {
            setState(() {
              currentSoundViewSubIndex += 1;
            });
          }
          else {
            showCompletedDialog(context);
          }
        }
      },
      child: Text(buttonText,
          style: TextStyle(color: Colors.lightBlue)),
    );
  }

  Widget getPreviousButton() {
    if (/*currentSoundViewIndex == 1 || */currentSoundViewSubIndex == 1) {
      return SizedBox(height: 0.0, width: 0.0);
    }

    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
      ),
      onPressed: () {
        if (currentSoundCategory == SoundCategory.intro || currentSoundCategory == SoundCategory.tongHua) {
          if (currentSoundViewSubIndex > 1) {
            setState(() {
              currentSoundViewSubIndex -= 1;
            });
          }
        }
        //else if (currentSoundCategory == SoundCategory.tongHua){
        //  if (currentSoundViewSubIndex > 1) {
        //    setState(() {
        //      currentSoundViewSubIndex -= 1;
        //    });
        //  }
        //}
      },
      child: Text(getString(433),
          style: TextStyle(color: Colors.lightBlue)),
    );
  }

  Widget getContinueAndBackButtons() {
    return Row(
        children: <Widget>[
          getPreviousButton(),
          SizedBox(width: 30 * getSizeRatioWithLimit()),
          getNextButton(),
        ]
    );
  }

  showCompletedDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        theIsBackArrowExit = false;
        Navigator.of(context).pop(); // out this dialog
        Navigator.of(context).pop(); // to the lesson page
      },
    );

    String title;
    String content;

    //if (typingType == TypingType.LeadComponents) {
    title = getString(115)/*"Good job!"*/;
    content = getString(354)/*"You have completed this exercise! Please move on to the next one."*/;
    //}

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
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

/*
  Widget getErGe(BuildContext context) {
    return Image.asset(
      "assets/paintge/erge" + currentSoundViewIndex.toString() + ".png",
      width: 300.0 * getSizeRatioWithLimit(),  // 350
      height: 500.0 * getSizeRatioWithLimit(), // 150
      fit: BoxFit.fitWidth,
    );
  }
*/

  Widget getErGeOrTongYao(BuildContext context) {
    return Column(
      //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(getString(432)/*"Read aloud"*/),
          SizedBox(height: 10),
          //Text(
          //    getString(427)/*"点击每个"*/,
          //    style: TextStyle(color: Colors.blue, fontSize: fontSize1),
          //    textAlign: TextAlign.start
          //),
          getPaintImage(),
          /*
          Image.asset(
            "assets/paintyao/tongyao" + currentSoundViewIndex.toString() + ".png",
            width: 380.0 * getSizeRatioWithLimit(),  // 350
            height: 550.0 * getSizeRatioWithLimit(), // 150
            fit: BoxFit.fitWidth,
          ),
          */
          //getSecondTongYaoImage(),
          getLessonText(),
          getDetailedStudies(),
        ]
    );
  }

  Widget getPaintImage() {
    var path;
    if (currentSoundCategory == SoundCategory.tongYao) {
      path = "assets/paintyao/tongyao";
    }
    else if (currentSoundCategory == SoundCategory.erGe) {
      path = "assets/paintge/erge";
    }

    return Image.asset(
      path + currentSoundViewIndex.toString() + ".png",
      width: 350 /*screenWidth*/ * getSizeRatioWithLimit(),  // 350
      //height: 550.0 * getSizeRatioWithLimit(), // 150
      fit: BoxFit.fitWidth,
    );
  }

  Widget getDetailedStudies() {
    var lessonText;
    var ExpandedWord;

    if (currentSoundCategory == SoundCategory.tongYao) {
      lessonText = theTongYaoLessonText[currentSoundViewIndex-1];
      ExpandedWord = theTongYaoExpandedWord;
    }
    else if (currentSoundCategory == SoundCategory.erGe) {
      lessonText = theErGeLessonText[currentSoundViewIndex-1];
      ExpandedWord = theErGeExpandedWord;
    }
    else if (currentSoundCategory == SoundCategory.tongHua) {
      lessonText = [""];
      ExpandedWord = theTongHuaExpandedWord;
    }

    return Row(
        children: <Widget>[
          getReadAloud(lessonText),
          getWordStudyButton(),
          getExpandedWordButton(ExpandedWord[currentSoundViewIndex-1]),   //"申" - one word per lesson only
          getDictionaryButton(),
        ]
    );
  }

  /*
  Widget getSecondTongYaoImage() {
    if (theTongYaoHasSecondPage[currentSoundViewIndex - 1] == true) {
      return Image.asset(
        "assets/paintyao/tongyao" + currentSoundViewIndex.toString() + "_2.png",
        width: 300.0 * getSizeRatioWithLimit(), // 350
        height: 500.0 * getSizeRatioWithLimit(), // 150
        fit: BoxFit.fitWidth,
      );
    }
    else {
      return SizedBox(height: 0.0, width: 0.0);;
    }
  }
  */

  Widget getTongHua(context) {
    return Column(
        children: [
          Image.asset(
            "assets/painthua/tonghua" + currentSoundViewIndex.toString() + "_" + currentSoundViewSubIndex.toString() + ".png",
            width: screenWidth * getSizeRatioWithLimit(),  // 350
            //height: 500.0 * getSizeRatioWithLimit(), // 150
            fit: BoxFit.fitWidth,
          ),
          getContinueAndBackButtons(),
          getDetailedStudies(),
        ]
    );
  }

  launchContent(int contentIndex) {
    //String inputText = "灵巧的"; //TODO: uncomment this line to test under Android simulator
    var inputText;
    if (currentSoundCategory == SoundCategory.erGe) {
      inputText = theErGeWords[currentSoundViewIndex-1];
    }
    else if (currentSoundCategory == SoundCategory.tongYao) {
      inputText = theTongYaoWords[currentSoundViewIndex-1];
    }
    else if (currentSoundCategory == SoundCategory.tongHua) {
      inputText = theTongHuaWords[currentSoundViewIndex-1];
    }

    switch (contentIndex) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DrillPageCore(drillCategory: DrillCategory.custom, startingCenterZiId: 1, subItemId: 1, isFromReviewPage: false, customString: inputText),
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
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InputZiPage(
                    typingType: TypingType.Custom, lessonId: 0, wordsStudy: inputText, isSoundPrompt: false, inputMethod: InputMethod.Pinxin, showHint: 1, includeSkipSection: true, showSwitchMethod: false),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                QuizPage(quizTextbook: QuizTextbook.custom, quizCategory: QuizCategory.none,lessonId: 0, wordsStudy: inputText, includeSkipSection: false,),
          ),
        ).then((val) => {_getRequests()});
        break;
      default:
        break;
    }
  }

  _getRequests() async {
    this.currentStudyIndex += 1;

    if (!theIsBackArrowExit && this.currentStudyIndex <= 3) { //TODO: 3 is the number of current subtasks in study new words
      // reinit
      theIsBackArrowExit = true;
      launchContent(this.currentStudyIndex);
    }
    else {
      // init all variables
      // either true back arrow or all done
      theIsBackArrowExit = true;
      //theIsFromTypingContinuedSection = false;
      this.currentStudyIndex = 0;
    }
    //}
  }

  Widget getWordStudyButton() {
    if (currentSoundCategory == SoundCategory.tongHua && currentSoundViewSubIndex < theTongHuaPageCount[currentSoundViewIndex - 1]) {
      return SizedBox(height: 0.0, width: 0.0);
    }

    var buttonText = getString(430);

    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
      ),
      onPressed: () {
        launchContent(0);
      },
      child: Text(buttonText,
          style: TextStyle(color: Colors.brown)),
    );
  }

  Widget getExpandedWordButton(String char) {
    if (currentSoundCategory == SoundCategory.tongHua && currentSoundViewSubIndex < theTongHuaPageCount[currentSoundViewIndex - 1]) {
      return SizedBox(height: 0.0, width: 0.0);
    }

    var buttonText = getString(431);

    var startingCenterZiId = ZiManager.findIdFromChar(ZiListType.searching, char);

    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DrillPageCore(drillCategory: DrillCategory.all, startingCenterZiId: startingCenterZiId, subItemId: 0, isFromReviewPage: false ,customString: ''),
          ),
        );
      },
      child: Text(buttonText,
          style: TextStyle(color: Colors.brown)), // lightBlue
    );
  }

  Widget getDictionaryButton() {
    var buttonText = getString(92);

    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 20.0 * getSizeRatioWithLimit()),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DictionaryPage(),
          ),
        );
      },
      child: Text(buttonText,
          style: TextStyle(color: Colors.brown)),
    );
  }

  Widget getReadAloud(List<String> text) {
      //var currentValues = "今天有点累人, 明天再看好吗？";
      if (currentSoundCategory == SoundCategory.tongHua/* && text.length == 0 && text[0].length == 0*/) {
        return SizedBox(height: 0.0, width: 0.0);
      }

      String fullText = "";
      for(int i=0; i< text.length; i++) {
        fullText += text[i];
      }

      return Container(
          height: 60.0 * getSizeRatioWithLimit(), //180
          width: 60.0 * getSizeRatioWithLimit(),
          child: IconButton(
            icon: Icon(
              Icons.volume_up,
              size: 45.0 * getSizeRatioWithLimit(),   // 150
            ),
            color: Colors.cyan, //Colors.green,
            onPressed: () {
              // 0.5 is the standard rate
              TextToSpeech.speakWithRate("zh-CN", fullText, 0.1);
            },
          )
      );
  }

  Widget getLessonText() {
    var text;
    if (currentSoundCategory == SoundCategory.erGe) {
      text = theErGeLessonText[currentSoundViewIndex-1];
    }
    else if (currentSoundCategory == SoundCategory.tongYao) {
      text = theTongYaoLessonText[currentSoundViewIndex-1];;
    }

    var fontSize = 18.0 * getSizeRatioWithLimit();
    return Column(
      //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
          getTextRows(text),
    );
  }

  List<Widget> getTextRows(List<String> text) {
    var fontSize = 18.0 * getSizeRatioWithLimit();
    List<Widget> wizardsAndButtons = [];
    wizardsAndButtons.add(SizedBox(height: fontSize / 2));
    //wizardsAndButtons.add(Text(
    //  getString(427)/*"点击每个"*/,
    //  style: TextStyle(color: Colors.blue, fontSize: fontSize),
    //  textAlign: TextAlign.start
    //));

    for (int i = 0; i < text.length; i++) {
      wizardsAndButtons.add(getOneTextRow(text[i]));
    }

    return wizardsAndButtons;
  }

  Widget getOneTextRow(String text) {
    var fontSize = 18.0 * getSizeRatioWithLimit();
    List<Widget> buttons = [];

    return Row(
        children: //<Widget>[
          getTextWordButtons(text)
        //]
    );
  }

  List<Widget> getTextWordButtons(String rowText) {
    List<Widget> buttons = [];
    buttons.add(Flexible(child: getReadOneRowAloud(rowText)));
    for (int i = 0; i < rowText.length; i++) {
      buttons.add(Flexible(child: getTextWordButton(rowText[i])));
    }

    return buttons;
  }

  Widget getTextWordButton(String text) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 30.0 * getSizeRatioWithLimit()),
      ),
      onPressed: () {
        initOverlay();
        TextToSpeech.speakWithRate("zh-CN", text, 0.1);
      },
      onLongPress: () {
        TextToSpeech.speakWithRate("zh-CN", text, 0.1);
        var ziId = ZiManager.findIdFromChar(ZiListType.searching, text);
        showOverlay(context, 150 * getSizeRatioWithLimit(), 200 * getSizeRatioWithLimit(), "[" + theSearchingZiList[ziId].pinyin + "] " + theSearchingZiList[ziId].meaning);
      },
      child: Text(text,
          style: TextStyle(color: Colors.lightBlue)),
    );
  }

  Widget getReadOneRowAloud(String rowText) {
    return Container(
        height: 30.0 * getSizeRatioWithLimit(), //180
        width: 30.0 * getSizeRatioWithLimit(),
        child: IconButton(
          icon: Icon(
            Icons.volume_up,
            size: 30.0 * getSizeRatioWithLimit(),   // 150
          ),
          color: Colors.cyan, //Colors.green,
          onPressed: () {
            TextToSpeech.speakWithRate("zh-CN", rowText, 0.1);
          },
        )
    );
  }
}
