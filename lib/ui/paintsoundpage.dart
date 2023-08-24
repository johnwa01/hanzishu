
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
  double screenWidth;
  ScrollController _scrollController;
  PrimitiveWrapper contentLength = PrimitiveWrapper(0.0);
  OverlayEntry overlayEntry;
  int previousOverlayGroup = 0;
  int previousOverlayIndex = 0;

  SoundCategory currentSoundCategory;
  int currentSoundViewIndex = 1;
  int currentSoundViewSubIndex = 1;
  int MaxIntroSoundView = 2; // temp number for now
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

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(423)/*"画音入门"*/),
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
      overlayEntry.remove();
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
            child: FlatButton(
              child: Text(pinyinAndMeaning, style: TextStyle(fontSize: 20.0),),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {},
            )
        ));
    overlayState.insert(overlayEntry);
  }

  Widget getOneKeyboardButton(int keyGroup, int keyIndex)
  {
    var imageIndex = PaintSoundManager.getXIndex(keyGroup, keyIndex);

    return FlatButton(
      color: Colors.white,
      textColor: Colors.blueAccent,
      padding: EdgeInsets.zero,
      onPressed: () {
        //initOverlay();

        //showOverlay(context, keyGroup, keyIndex);
        TextToSpeech.speak("zh-CN", PaintSoundManager.getXChar(keyGroup, keyIndex));
      },
      child: Image.asset(
        "assets/paintx/x1_" + imageIndex.toString() + ".png",
        width: 150.0 * getSizeRatioWithLimit(),
        height: 55.0 * getSizeRatioWithLimit(),
        fit: BoxFit.fitWidth,
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
      return getErGe(context);
    }
    else if (currentSoundCategory == SoundCategory.tongYao) {
      return getTongYao(context);
    }
    else if (currentSoundCategory == SoundCategory.tongHua) {
      return getTongHua(context);
    }
  }

  Widget getPaintIntro(BuildContext context, int soundViewIndex) {
    var fontSize1 = TheConst.fontSizes[1]; //* getSizeRatioWithLimit();
    var fontSize2 = TheConst.fontSizes[2]; //* getSizeRatioWithLimit();

    var fontSize = 18.0 * getSizeRatioWithLimit();
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
          getOneRow(soundViewIndex, 3),
          getOneRow(soundViewIndex, 5),
          getOneRow(soundViewIndex, 7),
          getOneRow(soundViewIndex, 9),
          getOneRow(soundViewIndex, 11),
          getOneRow(soundViewIndex, 13),
          getOneRow(soundViewIndex, 15),

          getContinueAndBackButtons(),
        ]
    );
  }

  Widget getOneRow(int groupIndex, int indexInGroup) {
    var fontSize = 18.0 * getSizeRatioWithLimit();

    return Row(
        children: <Widget>[
          Flexible(child: getOneKeyboardButton(groupIndex, indexInGroup)),
          SizedBox(width: fontSize),
          Flexible(child: getOneKeyboardButton(groupIndex, indexInGroup + 1)),
        ]
    );
  }

  Widget getNextButton() {
    var buttonText = getString(138);

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
    if (currentSoundViewIndex == 1 || currentSoundViewSubIndex == 1) {
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
      child: Text(getString(405),
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
    Widget okButton = FlatButton(
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

  Widget getErGe(context) {
    return Image.asset(
      "assets/paintge/erge" + currentSoundViewIndex.toString() + ".png",
      width: 300.0 * getSizeRatioWithLimit(),  // 350
      height: 500.0 * getSizeRatioWithLimit(), // 150
      fit: BoxFit.fitWidth,
    );
  }

  Widget getTongYao(context) {
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
          Image.asset(
            "assets/paintyao/tongyao" + currentSoundViewIndex.toString() + ".png",
            width: 380.0 * getSizeRatioWithLimit(),  // 350
            height: 550.0 * getSizeRatioWithLimit(), // 150
            fit: BoxFit.fitWidth,
          ),
          //getSecondTongYaoImage(),
          getLessonText(theTongYaoLessonText),
          getDetailedStudies(),
        ]
    );
  }

  Widget getDetailedStudies() {
    return Row(
        children: <Widget>[
          getReadAloud(theTongYaoLessonText),
          getWordStudyButton(),
          getExpandedWordButton("申"),
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
            width: 300.0 * getSizeRatioWithLimit(),  // 350
            height: 500.0 * getSizeRatioWithLimit(), // 150
            fit: BoxFit.fitWidth,
          ),
          getContinueAndBackButtons(),
        ]
    );
  }

  launchContent(int contentIndex) {
    String inputText = "灵巧的"; //TODO: uncomment this line to test under Android simulator
    switch (contentIndex) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DrillPageCore(drillCategory: DrillCategory.custom, startingCenterZiId: 1, subItemId: 1, customString: inputText),
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
                QuizPage(quizTextbook: QuizTextbook.wordsStudy, lessonId: 0, wordsStudy: inputText, fromPaintSound: true),
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
                DrillPageCore(drillCategory: DrillCategory.all, startingCenterZiId: startingCenterZiId, subItemId: 0, customString: null),
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
              TextToSpeech.speak("zh-CN", fullText);
            },
          )
      );
  }

  Widget getLessonText(List<String> text) {
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
        TextToSpeech.speak("zh-CN", text);
      },
      onLongPress: () {
        TextToSpeech.speak("zh-CN", text);
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
            TextToSpeech.speak("zh-CN", rowText);
          },
        )
    );
  }
}
