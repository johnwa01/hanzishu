import 'package:flutter/material.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/zilist.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/ui/conversationpainter.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/data/sentencelist.dart';
import 'package:hanzishu/engine/phrasemanager.dart';
import 'package:hanzishu/data/phraselist.dart';
import 'package:hanzishu/engine/lessonmanager.dart';

enum ButtonType {
  none,
  char,
  phrase,
  sound
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

  @override
  void initState() {
    super.initState();

    lesson = theLessonList[theCurrentLessonId];
    //lesson.populateNewItemList();
  }


  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);
    thePositionManager.setFrameWidth(screenWidth);

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Conversation"),
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

  Future<bool>_onWillPop() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }

    return Future.value(true);
  }

  showOverlay(BuildContext context, double posiX, double posiY, String meaning) {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }

    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) =>Positioned(
            top: posiY,
            left: posiX,
            child: FlatButton(
              child: Text(meaning, style: TextStyle(fontSize: 20.0),),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {},
            )
        ));
    overlayState.insert(overlayEntry);
  }

  Positioned getPositionedButton(int id, PositionAndSize posiAndSize, ButtonType buttonType) {
    var butt = FlatButton(
      color: Colors.white,
      textColor: Colors.blueAccent,
      onPressed: () {
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
        }

        if (buttonType == ButtonType.sound) {
          var conv = lesson.getSentence(id);
          TextToSpeech.speak(conv);
        }
        else if (buttonType == ButtonType.char){
          var zi = theZiManager.getZi(id);
          TextToSpeech.speak(zi.char);

          var meaning = theZiManager.getPinyinAndMeaning(id);
          showOverlay(context, posiAndSize.transX, posiAndSize.transY, meaning);
        }
        else if (buttonType == ButtonType.phrase){
          var phrase = thePhraseList[id];
          TextToSpeech.speak(phrase.chars);

          var meaning = phrase.getPinyinAndMeaning();
          showOverlay(context, posiAndSize.transX, posiAndSize.transY, meaning);
        }
      },
      onLongPress: () {
        if (buttonType == ButtonType.sound) {
          var conv = lesson.getSentence(id);
          TextToSpeech.speak(conv);
        }
        else if (buttonType == ButtonType.char) {
          var zi = theZiManager.getZi(id);
          TextToSpeech.speak(zi.char);

          var meaning = theZiManager.getPinyinAndMeaning(id);
          showOverlay(context, posiAndSize.transX, posiAndSize.transY, meaning);
        }
        else if (buttonType == ButtonType.phrase){
          var phrase = thePhraseList[id];
          TextToSpeech.speak(phrase.chars);

          var meaning = phrase.getPinyinAndMeaning();
          showOverlay(context, posiAndSize.transX, posiAndSize.transY, meaning);
        }
      },
      child: Text("", style: TextStyle(fontSize: 32.0),),
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

      var position = PositionAndSize(25.0, 33.0 + 140.0 * j, 20.0, 20.0, 0.0, 0.0);
      buttons.add(getPositionedButton(j, position, ButtonType.sound));

      for (int i = 0; i < conv.length; i++) {
        var oneChar = conv[i];
        var id = ZiManager.findIdFromChar(oneChar);

        var position = PositionAndSize(50.0 + 35.0 * i, 30.0 + 140.0 * j, 30.0, 30.0, 0.0, 0.0);

        buttons.add(getPositionedButton(id, position, ButtonType.char));
      }

      ButtonType buttonType;
      var previousChar = "|";
      var xPosi = 50.0;
      for (int i = 0; i < convWithSeparation.length; i++) {
        var oneSeparation = convWithSeparation[i];

        int separationCount = 1;

        if (oneSeparation == "|") {
          xPosi += 12.0;
        }
        else {
          var id = 0;
          if (previousChar == "|") {
            var width;
            // complete the whole separation block after "|"
            if ((separationCount =
                Utility.findSeparationCount(convWithSeparation, i)) == 1) {
              width = 20.0;
              id = ZiManager.findIdFromChar(oneSeparation);
              buttonType = ButtonType.char;
            }
            else {
              width = 25.0 * separationCount;
              var subStr = convWithSeparation.substring(i, i + separationCount);
              id = PhraseManager.getPhraseId(subStr);
              buttonType = ButtonType.phrase;
            }

            if (id != -1) {
              var position = PositionAndSize(
                  xPosi, 100.0 + 140.0 * j, width, 20.0, 0.0, 0.0);
              buttons.add(getPositionedButton(id, position, buttonType));

              xPosi += width;
            }
          }
        }

        previousChar = oneSeparation;
      }
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