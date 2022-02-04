import 'package:flutter/material.dart';
import 'package:hanzishu/data/sentencelist.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/ui/basepainter.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/generalmanager.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/data/zilist.dart';
import 'package:hanzishu/engine/phrasemanager.dart';
import 'package:hanzishu/data/phraselist.dart';

class ConversationPainter extends BasePainter {
  static var lessonLeftEdge = xYLength(10.0);

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
    var sentenceList = lesson.sentenceList;
    var sentenceLength = lesson.sentenceList.length;


    for (int j = 0; j < sentenceLength; j++) {
      //var conv = lesson.getSentence(j);
      var sentId = lesson.sentenceList[j];
      var conv = theSentenceList[sentId].conv;
      var convWithSeparation = theSentenceList[sentId].convWithSeparation;

      displayTextWithValue((j + 1).toString() + ".", 8.0, 30.0 + 150.0 * j, 17.0, Colors.blueAccent);

      DisplayIcon(iconSpeechStrokes, 25.0, 33.0 + 150.0 * j, 20.0, 20.0, Colors.amber/*MaterialColor ofColor*/, 2.0/*ziLineWidth*/);

      // text itself
      for (int i = 0; i < conv.length; i++) {
        var oneChar = conv[i];
        displayTextWithValue(
 //           oneChar, 50.0 + 35.0 * i, 30.0 + 140.0 * j - 30.0 * 0.25, 30.0,
            oneChar, 50.0 + 30.0 * i, 30.0 + 150.0 * j - 30.0 * 0.25, 28.0,
            Colors.blueAccent);
      }

      // text trans
      displayTextWithValue(theSentenceList[sentId].trans, 50.0, 65.0 + 150.0 * j, 17.0, Colors.blueAccent);

      // conWithSepa text
      var xPosi = 50.0;
      for (int i = 0; i < convWithSeparation.length; i++) {
        var oneSeparation = convWithSeparation[i];

        displayTextWithValue(
            oneSeparation, xPosi, 100.0 + 150.0 * j - 20.0 * 0.25, 20.0,
            Colors.blueAccent);

        if (oneSeparation == '|' || Utility.specialChar(oneSeparation)) {
          xPosi += 12.0;
        }
        else {
          xPosi += 25.0;
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
            var width;
            // complete the whole separation block after "|"
            if ((separationCount = Utility.findSeparationCount(convWithSeparation, i)) == 1) {
              id = ZiManager.findIdFromChar(oneSeparation);
              translation += Utility.getFirstMeaning(theZiList[id].meaning);
            }
            else {
              width = 30.0 * separationCount - 5.0;
              var subStr = convWithSeparation.substring(i, i + separationCount);
              phrase = PhraseManager.getPhraseIncludingSpecial(subStr);
              if (phrase != null) {
                translation += Utility.getFirstMeaning(phrase.meaning);
              }
            }
          }
          /*
          else if (Utility.specialChar(oneSeparation)) {
            var oneSepa = oneSeparation;
            if (oneSeparation == "。") {
              oneSepa = ".";
            }
            translation += oneSepa;
          }
          */
        }

        previousChar = oneSeparation;
      }

      displayTextWithValue(translation, 50.0, 125.0 + 150.0 * j, 17.0, Colors.blueAccent);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}