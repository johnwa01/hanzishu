import 'package:flutter/material.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/ui/conversationsnowballpage.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/ui/conversationpainter.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/data/sentencelist.dart';
import 'package:hanzishu/engine/phrasemanager.dart';
import 'package:hanzishu/data/phraselist.dart';

enum ButtonType {
  none,
  char,
  phrase,
  specialPhrase,
  sound,
  translationSound,
  launchPage
}

class ConversationPage extends StatefulWidget {
  final int lessonId;
  ConversationPage({this.lessonId});

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  double screenWidth;
  OverlayEntry overlayEntry;
  var lesson;
  PositionAndMeaning previousPositionAndMeaning = PositionAndMeaning(
      0.0, 0.0, "");

  @override
  void initState() {
    super.initState();

    lesson = theLessonList[theCurrentLessonId];
    //lesson.populateNewItemList();
  }

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  double applyRatioWithLimit(double value) {
    return value * getSizeRatioWithLimit();
  }

  @override
  Widget build(BuildContext context) {
    //screenWidth = Utility.getScreenWidth(context);
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    thePositionManager.setFrameWidth(screenWidth);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(4)/*"Conversation"*/),
      ),
      body: Container(
          //height: 200.0,
          //width: 200.0,
          child: WillPopScope(   // just for removing overlay on detecting back arrow
            child: CustomPaint(
              foregroundPainter: ConversationPainter(
                  lineColor: Colors.amber,
                  lessonId: widget.lessonId,
                  screenWidth: screenWidth
              ),
              child: Center(
                child: Stack(
                    children: displayCharsAndCreateHittestButtons(context)
                ),
              ),
            ),
            onWillPop: _onWillPop
          ),
      ),
    );
  }

  initOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
      theDicOverlayEntry = null; //TODO: not used here, remove?
    }
  }

  Future<bool>_onWillPop() {
    initOverlay();

    return Future.value(true);
  }

  showOverlay(BuildContext context, double posiX, double posiY, String meaning) {
    initOverlay();

    if (previousPositionAndMeaning.x != posiX || previousPositionAndMeaning.y != posiY || previousPositionAndMeaning.meaning != meaning) {
      var screenWidth = Utility.getScreenWidth(context);
      var adjustedXValue = Utility.adjustOverlayXPosition(posiX, screenWidth);

      OverlayState overlayState = Overlay.of(context);
      overlayEntry = OverlayEntry(
          builder: (context) =>
              Positioned(
                  top: posiY,
                  left: adjustedXValue,
                  child: FlatButton(
                    child: Text(meaning, style: TextStyle(fontSize: applyRatioWithLimit(20.0)),),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () {initOverlay();},
                  )
              ));
      overlayState.insert(overlayEntry);
      previousPositionAndMeaning.set(posiX, posiY, meaning);
    }
    else {
      previousPositionAndMeaning.set(0.0, 0.0, "");
    }
  }

  Positioned getPositionedButton(int id, PositionAndSize posiAndSize, ButtonType buttonType) {
    var frameColor = Colors.white;
    if (buttonType == ButtonType.launchPage) {
      frameColor = Colors.blueAccent;
    }
    var butt = FlatButton(
      color: frameColor,
      textColor: Colors.blueAccent,

      onPressed: () {
        initOverlay();

        if (buttonType == ButtonType.sound) {
          var conv = lesson.getSentence(id);
          TextToSpeech.speak("zh-CN", conv);
        }
        else if (buttonType == ButtonType.char){
          var zi = theZiManager.getZi(id);
          TextToSpeech.speak("zh-CN", zi.char);
        }
        else if (buttonType == ButtonType.phrase){
          var phrase = thePhraseList[id];
          TextToSpeech.speak("zh-CN", phrase.chars);
          //shortcut for sound only!
        }
        if (buttonType == ButtonType.translationSound) {
          var sent = lesson.getRealSentence(id);
          TextToSpeech.speak("en-US", sent.trans);
        }
        else if (buttonType == ButtonType.launchPage) {
          theIsBackArrowExit = false;
          Navigator.of(context).pop();
        }
      },
      onLongPress: () {
        if (buttonType == ButtonType.sound) {
          var conv = lesson.getSentence(id);
          TextToSpeech.speak("zh-CN", conv);
        }
        else if (buttonType == ButtonType.char) {
          var zi = theZiManager.getZi(id);
          if (zi != null) {
            TextToSpeech.speak("zh-CN", zi.char);
          }

          var meaning = ZiManager.getPinyinAndMeaning(id);
          showOverlay(context, posiAndSize.transX, posiAndSize.transY, meaning);
        }
        else if (buttonType == ButtonType.phrase || buttonType == ButtonType.specialPhrase){
          var phrase;
          if (buttonType == ButtonType.phrase) {
            phrase = thePhraseList[id];
          }
          else {
            phrase = theSpecialPhraseList[id];
          }

          TextToSpeech.speak("zh-CN", phrase.chars);

          var meaning = phrase.getPinyinAndMeaning();
          showOverlay(context, posiAndSize.transX, posiAndSize.transY, meaning);
        }
        else if (buttonType == ButtonType.translationSound) {
          var sent = lesson.getRealSentence(id);
          TextToSpeech.speak("en-US", sent.trans);
        }
        else if (buttonType == ButtonType.launchPage) {
          theIsBackArrowExit = false;
          Navigator.of(context).pop();
        }
      },
      child:
        Text("", style: TextStyle(fontSize: applyRatioWithLimit(32.0))),
      // Note: cannot put char here directly since the gap would be too big.
    );

    var posiCenter = Positioned(
        top: posiAndSize.transY,
        left: posiAndSize.transX,
        height: posiAndSize.height,
        width: posiAndSize.width,
        child: butt
    );

    return posiCenter;
  }

  List<Widget> displayCharsAndCreateHittestButtons(BuildContext context) {
    List<Widget> buttons = [];

    var sentenceLength = lesson.sentenceList.length;
    for (int j = 0; j < sentenceLength; j++) {
      //var conv = lesson.getSentence(j);
      var sentId = lesson.sentenceList[j];
      var conv = theSentenceList[sentId].conv;
      var convWithSeparation = theSentenceList[sentId].convWithSeparation;

      var position = PositionAndSize(applyRatioWithLimit(25.0), applyRatioWithLimit(33.0 + 70.0 * j), applyRatioWithLimit(20.0), applyRatioWithLimit(20.0), 0.0, 0.0);
      buttons.add(getPositionedButton(j, position, ButtonType.sound));

      for (int i = 0; i < conv.length; i++) {
        var oneChar = conv[i];
        var id = ZiManager.findIdFromChar(ZiListType.zi, oneChar);
        if (id != -1) {
          var position = PositionAndSize(
              applyRatioWithLimit(50.0 + 30.0 * i), applyRatioWithLimit(30.0 + 70.0 * j), applyRatioWithLimit(28.0), applyRatioWithLimit(28.0), 0.0, 0.0);
          buttons.add(getPositionedButton(id, position, ButtonType.char));
        }
      }

      var positionTranslation = PositionAndSize(applyRatioWithLimit(50.0), applyRatioWithLimit(33.0 + 70.0 * j + 33.0), applyRatioWithLimit(8.0 * theSentenceList[sentId].trans.length), applyRatioWithLimit(20.0), 0.0, 0.0);
      buttons.add(getPositionedButton(j, positionTranslation, ButtonType.translationSound));

      /* Decide to not show phrase based sentences per current plan.
      ButtonType buttonType;
      var previousChar = '|';
      var phrase;
      var xPosi = applyRatioWithLimit(50.0);
      for (int i = 0; i < convWithSeparation.length; i++) {
        var oneSeparation = convWithSeparation[i];

        int separationCount = 1;

        if (oneSeparation == '|' || Utility.specialChar(oneSeparation)) {
          xPosi += applyRatioWithLimit(12.0);
        }
        else {
          var id = -1;
          if (previousChar == '|' || Utility.specialChar(previousChar)) {
            var width;
            // complete the whole separation block after "|"
            if ((separationCount =
                Utility.findSeparationCount(convWithSeparation, i)) == 1) {
              width = applyRatioWithLimit(25.0); //20.0;
              id = ZiManager.findIdFromChar(ZiListType.zi, oneSeparation);
              buttonType = ButtonType.char;
            }
            else {
              width = applyRatioWithLimit(25.0) * separationCount;
              var subStr = convWithSeparation.substring(i, i + separationCount);
              phrase = PhraseManager.getPhraseByName(subStr);
              if (phrase != null) {
                id = phrase.id;
                buttonType = ButtonType.phrase;
              }
              else {
                phrase = PhraseManager.getSpecialPhraseByName(subStr);
                if (phrase != null) {
                  id = phrase.id;
                  buttonType = ButtonType.specialPhrase;
                }
              }
            }

            if ( id != -1) {
              var position = PositionAndSize(
                  xPosi, applyRatioWithLimit(100.0 + 70.0 * j), width, applyRatioWithLimit(20.0), 0.0, 0.0);
              buttons.add(getPositionedButton(id, position, buttonType));

              xPosi += width;
            }
          }
        }

        previousChar = oneSeparation;
      }
      */
    }

    // for Continue button
    if (theIsFromLessonContinuedSection) {
      var xStartPosi = applyRatioWithLimit(50.0);
      var position = PositionAndSize(
          xStartPosi,
          applyRatioWithLimit(100.0 + 70.0 * (sentenceLength - 1) + 80),
          applyRatioWithLimit(100.0 /*temp width*/), applyRatioWithLimit(20.0),
          0.0, 0.0);
      buttons.add(getPositionedButton(9999, position, ButtonType.launchPage));
    }

    return buttons;
  }

  /*
  Widget getConversationWizard() {
    var lesson = theLessonList[theCurrentLessonId];
    lesson.populateNewItemList();

    return ListView.separated(
      itemCount: lesson.sentenceList.length,
      separatorBuilder/*IndexedWidgetBuilder*/: (BuildContext context, int index) {
        return Divider();
      },
      itemBuilder/*IndexedWidgetBuilder*/: (BuildContext context, int index) {
        return ListTile(
          //title: Text('item $index'),
          //title: Text(theLessonList[index].chars),
          title: Text(lesson.getSentence(index)),
        );
      },
    );
  }
  */
}