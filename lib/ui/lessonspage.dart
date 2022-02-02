import 'dart:io';
import 'package:hanzishu/engine/fileio.dart';
import 'package:flutter/material.dart';
import 'package:hanzishu/ui/imagebutton.dart';

import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/levellist.dart';
import 'package:hanzishu/utility.dart';

class LessonsPage extends StatefulWidget {
  @override
  _LessonsPageState createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  bool hasLoadedStorage;
  //_openLessonPage(BuildContext context) {
  //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LessonPage()));
  //}
  // starting lesson number in each row
  //final List<int> lessons = <int>[1, 2, 3, 5, 6, 8, 9, 11, 13, 16, 18, 19, 21, 22, 24, 26, 29, 31, 32, 34, 36, 37, 39, 41, 44, 46, 47, 49, 50, 53, 56, 59];
  final List<int> lessons = <int>[1, 2, 4, 6, 7, 10, 11, 13, 16, 17, 18, 20, 22, 23, 25, 27, 28, 30, 33, 34, 35, 37, 39, 40, 42, 44, 45, 48, 50, 51, 53, 54, 55, 57, 60];

  @override
  void initState() {
    super.initState();

    setState(() {
      this.hasLoadedStorage = false;
    });
  }

  handleStorage() {
    if (!theStorageHandler.getHasTriedToLoadStorage()) {
      var fileIO = CounterStorage();
      theStorageHandler.setHasTriedToLoadStorage();
      fileIO.readString().then((String value) {
        // just once, doesn't matter whether it loads any data or not
        if (value != null) {
          var storage = theStorageHandler.getStorageFromJson(value);
          if (storage != null) {
            theStorageHandler.setStorage(storage);
            setState(() {
              this.hasLoadedStorage = true;
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // do here so that it'll refresh the lessonspage to reflect the lesson completed status from storage.
    // also away from the main thread I think.
    // do it only once
    handleStorage();

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
            //if (index == 0 || index == 4 || index == 8 || index == 11 || index == 14 || index == 18 || index == 21 || index == 24 || index == 27 || index == 30 || index == 34) {
            if (index == 0 || index == 5 || index == 9 || index == 12 || index == 15 || index == 19 || index == 22 || index == 25 || index == 28 || index == 31) {

                if (index == 0) {level = 1;}
                else if (index == 5) { level = 2;}
                else if (index == 9) { level = 3;}
                else if (index == 12) { level = 4;}
                else if (index == 15) { level = 5;}
                else if (index == 19) { level = 6;}
                else if (index == 22) { level = 7;}
                else if (index == 25) { level = 8;}
                else if (index == 28) { level = 9;}
                else if (index == 31) { level = 10;}
                //else if (index == 34) { level = 10;}
                //return getLevel(context, level);
                return getButtonRowWithLevelBegin(context, lessons[index], lessonCount, level);
              }
              else {
                return getButtonRow(context, lessons[index], lessonCount);
              }
            }
          ),
      ),
    );
  }

  Widget getButtonRowWithLevelBegin(BuildContext context, int lessonNumber, int lessonCount, int level) {
    return Column(
      children: <Widget>[
        Text(
          "Unit " + '$level' + ": " + theLevelList[level].description,
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 20.0),
        ),
        Divider(color: Colors.black),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: getRowSections(context, lessonNumber, lessonCount),
          ),
          padding: EdgeInsets.all(20),
        ),
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
    var realNumber = lessonNumber;
    var modNumber = realNumber % 10;
    var path = "assets/lessons/L" + modNumber.toString() + ".png";
    //if (modNumber == 9) {
    //  path = "assets/IMG_6606.PNG";
    //}
    sections.add(Container(child: OpenHelper.getImageButton(context, realNumber, path/*charactertree.png*/, LessonSection.None, true)));

    if (lessonCount >= 2) {
      realNumber++;
      modNumber = realNumber % 10;
      var path = "assets/lessons/L" + modNumber.toString() + ".png";
      //if (modNumber == 9) {
      //  path = "assets/IMG_6606.PNG";
      //}
      sections.add(Container(child: OpenHelper.getImageButton(context, realNumber, path/*conversations.png*/, LessonSection.None, true)));

      if (lessonCount >= 3) {
        realNumber++;
        modNumber = realNumber % 10;
        var path = "assets/lessons/L" + modNumber.toString() + ".png";
        //if (modNumber == 9) {
        //  path = "assets/IMG_6606.PNG";
        //}
        sections.add(Container(child: OpenHelper.getImageButton(context, realNumber,  path/*charactertree.png*/, LessonSection.None, true)));
      }
    }

    return sections;
  }
}