import 'package:flutter/material.dart';
import 'package:hanzishu/lessonpage.dart';
import 'package:hanzishu/treepage.dart';

class OpenHelper {
  static openPage(BuildContext context, int lessonNumber, bool isSectionPage) {
    if (isSectionPage) {
      openLessonSectionPage(context, lessonNumber);
    }
    else { // lessonPage
      openLessonPage(context, lessonNumber);
    }
  }

  static openLessonPage(BuildContext context, int lessonNumber) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LessonPage(lessonNumber: lessonNumber)));
  }

  static openLessonSectionPage(BuildContext context, int lessonNumber) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => TreePage(lessonNumber: lessonNumber)));
  }

  static Widget getImageButton(BuildContext context, int lessonNumber, String imagePath, bool isSectionPage) {
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
        onPressed: () => openPage(context, lessonNumber, isSectionPage),
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
