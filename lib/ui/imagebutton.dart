import 'package:flutter/material.dart';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/ui/lessonpage.dart';
import 'package:hanzishu/ui/treepage.dart';
//import 'package:hanzishu/ui/characterlistpage.dart';
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
      case LessonSection.Assembling:
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
    }
  }

  static Widget getImageButton(BuildContext context, int lessonNumber, String imagePath, LessonSection lessonSection, bool isLesson) {
    final colorScheme = Theme.of(context).colorScheme;
    var lesson = theLessonManager.getLesson(lessonNumber);

    String lessonOrSectionName = "";

    if (isLesson) {
      lessonOrSectionName = lesson.titleTranslation;
    }
    else {
      switch (lessonSection) {
        case LessonSection.FullCharacterTree:
          lessonOrSectionName = "Character Tree";
          break;
        case LessonSection.Characters:
          lessonOrSectionName = "Character List";
          break;
        case LessonSection.Assembling:
          lessonOrSectionName = "Character Break Out";
          break;
        case LessonSection.Conversation:
          lessonOrSectionName = "Conversation";
          break;
        case LessonSection.Typing:
          lessonOrSectionName = "Typing";
          break;
        case LessonSection.Quiz:
          lessonOrSectionName = "Quiz";
          break;
      }
    }

    return
      InkWell(
        child: Column(
            children: [
              //Container(
                //decoration: BoxDecoration(
                //  color: Colors.transparent,
                //  border: Border.all(color: Colors.blue, width: 1.0),
                //  borderRadius: BorderRadius.circular(40),
                //),
                Ink.image(
                  image: AssetImage(imagePath),
                  width: 110.0,
                  height: 110.0,
                ),
              //),
              Text(
                lessonOrSectionName, //lesson.titleTranslation, //"Hello",
                style: TextStyle(fontSize: 16.0, fontFamily: "Raleway"),
              ),
            ]
        ),

        onTap: () => openPage(context, lessonNumber, lessonSection),
    );

    /*
    return SizedBox(
      width: 110,
      height: 130,
      child: FlatButton(
        child: Column(
            children: [
              Image.asset(
                imagePath,
                width: 90.0,
                height: 100.0,
              ),
              Text(
                lessonOrSectionName, //lesson.titleTranslation, //"Hello",
                style: TextStyle(fontSize: 12.0, fontFamily: "Raleway"),
              ),
            ]
        ),
        onPressed: () => openPage(context, lessonNumber, lessonSection),
        textColor: Colors.blueAccent, //Colors.white,
        color: colorScheme.primary,
        //color: Color(0xFF226597),
        shape: OutlineInputBorder(
            borderSide: BorderSide(
                style: BorderStyle.solid, width: 1.0, color: Colors.black),
            borderRadius: BorderRadius.circular(20.0)),
      ),
    );
    */
  }
}