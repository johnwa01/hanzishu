import 'package:flutter/material.dart';
import 'package:hanzishu/lessonpage.dart';

class OpenHelper {
  static openLessonPage(BuildContext context, int lessonNumber) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LessonPage(lessonNumber: lessonNumber)));
  }

  static Widget getImageButton(BuildContext context, int lessonNumber) {
    return SizedBox(
      width: 120,
      height: 120,
      child: FlatButton(
        child: Column(
            children: [
              Image.asset(
                "assets/charactertree.png",
                width: 100.0,
                height: 100.0,
              ),
              Text(
                "Hello",
                style: TextStyle(fontSize: 11.0, fontFamily: "Raleway"),
              ),
            ]
        ),
        onPressed: () => openLessonPage(context, lessonNumber),
        textColor: Colors.white,
        color: Color(0xFF226597),
        shape: OutlineInputBorder(
            borderSide: BorderSide(
                style: BorderStyle.solid, width: 1.0, color: Colors.black),
            borderRadius: new BorderRadius.circular(20.0)),
      ),
    );
  }
}
