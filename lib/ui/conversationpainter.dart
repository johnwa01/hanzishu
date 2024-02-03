import 'package:flutter/material.dart';
import 'package:hanzishu/data/sentencelist.dart';
import 'dart:ui';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/engine/phrasemanager.dart';

class ConversationPainter extends BasePainter {
  static var lessonLeftEdge = 10.0;

  Color lineColor;
  int lessonId;
  double screenWidth;

  ConversationPainter({
    this.lineColor, this.lessonId, this.screenWidth
  });

  @override
  void paint(Canvas canvas, Size size) {
    width = screenWidth;
    this.canvas = canvas;
    //this.width = size.width;

    displayConversations(lessonId);
  }

  displayConversations(int lessonId) {
    var lesson = theLessonList[theCurrentLessonId];
    var sentenceLength = lesson.sentenceList.length;

    for (int j = 0; j < sentenceLength; j++) {
      //var conv = lesson.getSentence(j);
      var sentId = lesson.sentenceList[j];
      var conv = theSentenceList[sentId].conv;
  //    var convWithSeparation = theSentenceList[sentId].convWithSeparation;

      displayTextWithValue((j + 1).toString() + ".", applyRatioWithLimit(8.0), applyRatioWithLimit(30.0 + 70.0 * j), applyRatioWithLimit(17.0), Colors.blueAccent, false);

      DisplayIcon(iconSpeechStrokes, applyRatioWithLimit(25.0), applyRatioWithLimit(33.0 + 70.0 * j), applyRatioWithLimit(20.0), applyRatioWithLimit(20.0), Colors.amber/*MaterialColor ofColor*/, applyRatioWithLimit(2.0)/*ziLineWidth*/);

      // text itself
      for (int i = 0; i < conv.length; i++) {
        var oneChar = conv[i];
        displayTextWithValue(
 //           oneChar, 50.0 + 35.0 * i, 30.0 + 140.0 * j - 30.0 * 0.25, 30.0,
            oneChar, applyRatioWithLimit(50.0 + 30.0 * i), applyRatioWithLimit(30.0 + 70.0 * j - 30.0 * 0.25), applyRatioWithLimit(28.0),
            Colors.blueAccent, false);
      }

      // text trans
      displayTextWithValue(theSentenceList[sentId].trans, applyRatioWithLimit(50.0), applyRatioWithLimit(65.0 + 70.0 * j), applyRatioWithLimit(15.0), Colors.blueAccent, false);

      /* Not including phrases any more per current plan.
      // conWithSepa text
      var xPosi = applyRatioWithLimit(50.0);
      for (int i = 0; i < convWithSeparation.length; i++) {
        var oneSeparation = convWithSeparation[i];

        displayTextWithValue(
            oneSeparation, xPosi, applyRatioWithLimit(100.0 + 130.0 * j - 20.0 * 0.25), applyRatioWithLimit(20.0),
            Colors.blueAccent, false);

        if (oneSeparation == '|' || Utility.specialChar(oneSeparation)) {
          xPosi += applyRatioWithLimit(12.0);
        }
        else {
          xPosi += applyRatioWithLimit(25.0);
        }
      }

      // conWithSepa translation
      // has to be the English '|', not Chinese '｜'.
      var previousChar = '|';
      String translation = "";
      var phrase;

      for (int i = 0; i < convWithSeparation.length; i++) {
        var oneSeparation = convWithSeparation[i];
        int separationCount = 1;

        if (oneSeparation == '|' || Utility.specialChar(oneSeparation)) {
          var oneSepa = oneSeparation;
          if (oneSeparation == "。") {
            oneSepa = ".";
          }
          translation += ' ' + oneSepa + ' ';
        }
        else {
          var id = 0;
          if (previousChar == '|' || Utility.specialChar(previousChar)) {
            // complete the whole separation block after "|"
            if ((separationCount = Utility.findSeparationCount(convWithSeparation, i)) == 1) {
              id = ZiManager.findIdFromChar(ZiListType.zi, oneSeparation);
              if (id != -1) {
                var firstMeaning = Utility.getFirstMeaning(theZiList[id].char);
                if (firstMeaning != "了") {
                  translation += Utility.getFirstMeaning(theZiList[id].meaning);
                }
              }
            }
            else {
              var subStr = convWithSeparation.substring(i, i + separationCount);
              phrase = PhraseManager.getPhraseIncludingSpecial(subStr);
              if (phrase != null) {
                translation += Utility.getFirstMeaning(phrase.meaning);
              }
            }
          }
        }

        previousChar = oneSeparation;
      }

      displayTextWithValue(translation, applyRatioWithLimit(50.0), applyRatioWithLimit(125.0 + 130.0 * j), applyRatioWithLimit(15.0), Colors.blueAccent, false);
      */
    }

    if (theIsFromLessonContinuedSection) {
      displayTextWithValue(
          getString(285) /*"Continue"*/, applyRatioWithLimit(50.0),
          applyRatioWithLimit(125.0 + 70.0 * (sentenceLength - 1) + 50.0),
          applyRatioWithLimit(15.0), Colors.white, false);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}