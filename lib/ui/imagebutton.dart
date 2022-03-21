import 'package:flutter/material.dart';
import 'package:hanzishu/ui/lessonpage.dart';
import 'package:hanzishu/ui/treepage.dart';
import 'package:hanzishu/ui/listofzipage.dart';
import 'package:hanzishu/ui/breakoutpage.dart';
import 'package:hanzishu/ui/quizpage.dart';
import 'package:hanzishu/ui/conversationpage.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/inputzi.dart';

class OpenHelper {
  static openPage(BuildContext context, int lessonId, LessonSection lessonSection) {
    if (lessonSection == LessonSection.None) {
      openLessonPage(context, lessonId);
    }
    else {
      openLessonSectionPage(context, lessonId, lessonSection);
    }
  }

  static openLessonPage(BuildContext context, int lessonId) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LessonPage(lessonId: lessonId)));
  }

  static openLessonSectionPage(BuildContext context, int lessonId, LessonSection lessonSection) {
    switch (lessonSection) {
      case LessonSection.FullCharacterTree:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TreePage(lessonId: lessonId)));
        break;
      case LessonSection.Characters:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListOfZiPage(lessonId: lessonId)));
        break;
      case LessonSection.Decomposing:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BreakoutPage(lessonId: lessonId)));
        break;
      case LessonSection.Conversation:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConversationPage(lessonId: lessonId)));
        break;
      case LessonSection.Typing:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => InputZiPage(typingType: TypingType.FromLessons, lessonId: lessonId)));
        break;
      case LessonSection.Quiz:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuizPage(lessonId: lessonId)));
        break;
      case LessonSection.None:
        break;
    }
  }

  static Widget getCompletedImage(int lessonNumber) {
    var completed = theStorageHandler.hasLessonCompleted(lessonNumber);
    if (completed) {
      return Ink.image(
        image: AssetImage("assets/core/completedicon.png"),
        width: 16.0,
        height: 16.0,
      );
    }
    else {
      return SizedBox(height: 0.0, width: 0.0);
    }

  }

  static Widget getImageButton(BuildContext context, int lessonNumber, String imagePath, LessonSection lessonSection, bool isLesson, double xSize, double ySize) {
    var lesson = theLessonManager.getLesson(lessonNumber);

    String lessonOrSectionName = "";

    if (isLesson) {
      lessonOrSectionName = lesson.titleTranslation;
      return
        InkWell(
          child: Column(
              children: [
                Ink.image(
                  image: AssetImage(imagePath),
                  width: xSize,
                  height: ySize,
                ),
                Row(
                  children: [
                    Text(
                      lessonOrSectionName, //lesson.titleTranslation, //"Hello",
                      style: TextStyle(fontSize: 14.0, fontFamily: "Raleway"),
                    ),
                    getCompletedImage(lessonNumber),
                  ]
                ),
              ]
          ),

          onTap: () => openPage(context, lessonNumber, lessonSection),
        );
    }
    else {
      switch (lessonSection) {
        case LessonSection.FullCharacterTree:
          lessonOrSectionName = "Character drills";
          break;
        case LessonSection.Characters:
          lessonOrSectionName = "Character list";
          break;
        case LessonSection.Decomposing:
          lessonOrSectionName = "Character breakdown";
          break;
        case LessonSection.Conversation:
          lessonOrSectionName = "Conversation";
          break;
        case LessonSection.Typing:
          lessonOrSectionName = "Typing exercises";
          break;
        case LessonSection.Quiz:
          lessonOrSectionName = "Quiz";
          break;
        case LessonSection.None:
          break;
      }
      return
        InkWell(
          child: Column(
              children: [
                Ink.image(
                  image: AssetImage(imagePath),
                  width: xSize,
                  height: ySize,
                ),
                Text(
                  lessonOrSectionName, //lesson.titleTranslation, //"Hello",
                  style: TextStyle(fontSize: 14.0, fontFamily: "Raleway"),
                ),
              ]
          ),

          onTap: () => openPage(context, lessonNumber, lessonSection),
        );
    }
  }
}