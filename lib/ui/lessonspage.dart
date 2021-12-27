import 'package:flutter/material.dart';
import 'package:hanzishu/ui/imagebutton.dart';
import 'package:hanzishu/utility.dart';

class LessonsPage extends StatefulWidget {
  @override
  _LessonsPageState createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  //_openLessonPage(BuildContext context) {
  //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LessonPage()));
  //}
  // starting lesson number in each row
  //final List<int> lessons = <int>[1, 2, 3, 5, 6, 8, 9, 11, 13, 16, 18, 19, 21, 22, 24, 26, 29, 31, 32, 34, 36, 37, 39, 41, 44, 46, 47, 49, 50, 53, 56, 59];
  final List<int> lessons = <int>[1, 2, 4, 6, 7, 10, 11, 13, 16, 17, 18, 20, 22, 23, 25, 27, 28, 30, 33, 34, 35, 37, 39, 40, 42, 44, 45, 48, 50, 51, 53, 54, 55, 57, 60];

  @override
  Widget build(BuildContext context) {
    Utility.removeDicOverlayEntry();

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Hanzishu"), // "Lessons Page"
      ),
      body: Center
        (
        child: ListView.builder(
          itemCount/*itemExtent*/: lessons.length,
          itemBuilder/*IndexedWidgetBuilder*/: (BuildContext context, int index) {
            int lessonCount = 1;

            // assume last row has one item
            if (index == lessons.length - 1) {
              lessonCount = 1;  // have to specify the number of last row
            }
            else if (index < lessons.length - 1) {
              lessonCount = lessons[index + 1] - lessons[index];
            }

            int level = 1;
            if (index == 4 || index == 8 || index == 11 || index == 14 || index == 18 || index == 21 || index == 24 || index == 27 || index == 30 || index == 34) {
              if (index == 4) {level = 1;}
              else if (index == 8) { level = 2;}
              else if (index == 11) { level = 3;}
              else if (index == 14) { level = 4;}
              else if (index == 18) { level = 5;}
              else if (index == 21) { level = 6;}
              else if (index == 24) { level = 7;}
              else if (index == 27) { level = 8;}
              else if (index == 30) { level = 9;}
              else if (index == 34) { level = 10;}

              return getButtonRowWithLevelEnd(context, lessons[index], lessonCount, level);
            }
            else {
              return getButtonRow(context, lessons[index], lessonCount);
            }
          },
        ),
      ),
    );
  }

  Widget getButtonRowWithLevelEnd(BuildContext context, int lessonNumber, int lessonCount, int level) {
    return Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: getRowSections(context, lessonNumber, lessonCount),
            ),
            padding: EdgeInsets.all(20),
          ),
          Text(
            '$level',
            textAlign: TextAlign.right,
            //style: TextStyle(fontSize: 50.0),
          ),
          Divider(color: Colors.black),
        ]
    );
  }

  Widget getButtonRow(BuildContext context, int lessonNumber, int lessonCount) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: getRowSections(context, lessonNumber, lessonCount),
      ),
      padding: EdgeInsets.all(20),
    );
  }

  List<Widget> getRowSections(BuildContext context, int lessonNumber, int lessonCount) {
    List<Widget> sections = [];
    sections.add(Container(child: OpenHelper.getImageButton(context, lessonNumber, "assets/IMG_6606.PNG", LessonSection.None, true)));

    if (lessonCount >= 2) {
      sections.add(Container(child: OpenHelper.getImageButton(context, lessonNumber + 1, "assets/conversations.png", LessonSection.None, true)));

      if (lessonCount >= 3) {
        sections.add(Container(child: OpenHelper.getImageButton(context, lessonNumber + 2, "assets/charactertree.png", LessonSection.None, true)));
      }
    }

    return sections;
  }
}