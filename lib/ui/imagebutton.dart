import 'package:flutter/material.dart';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/ui/lessonpage.dart';
import 'package:hanzishu/ui/treepage.dart';
import 'package:hanzishu/ui/characterlistpage.dart';
import 'package:hanzishu/utility.dart';

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
        MaterialPageRoute(builder: (context) => LessonPage(/*lessonId-TODO?*/)));
  }

  static openLessonSectionPage(BuildContext context, int lessonId, LessonSection lessonSection) {
    switch (lessonSection) {
      case LessonSection.FullCharacterTree:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TreePage(lessonId: lessonId)));
        break;
      case LessonSection.Characters:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CharacterListPage(lessonId: lessonId)));
        break;
      case LessonSection.Assembling:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TreePage(lessonId: lessonId)));
        break;
      case LessonSection.Conversation:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TreePage(lessonId: lessonId)));
        break;
      case LessonSection.Quiz:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TreePage(lessonId: lessonId)));
        break;
    }
  }

  static Widget getImageButton(BuildContext context, int lessonNumber, String imagePath, LessonSection lessonSection) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 110,
      height: 120,
      child: FlatButton(
        child: Column(
            children: [
              Image.asset(
                imagePath,
                width: 90.0,
                height: 100.0,
              ),
              Text(
                "Hello",
                style: TextStyle(fontSize: 11.0, fontFamily: "Raleway"),
              ),
            ]
        ),
        onPressed: () => openPage(context, lessonNumber, lessonSection),
        textColor: Colors.white,
        color: colorScheme.primary,
        //color: Color(0xFF226597),
        shape: OutlineInputBorder(
            borderSide: BorderSide(
                style: BorderStyle.solid, width: 1.0, color: Colors.black),
            borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }
}