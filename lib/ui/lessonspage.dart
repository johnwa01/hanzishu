import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hanzishu/engine/fileio.dart';
import 'package:flutter/material.dart';
import 'package:hanzishu/ui/imagebutton.dart';

import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/levellist.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/lessonpage.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/localization/string_en_US.dart';
import 'package:hanzishu/localization/string_zh_CN.dart';
import 'dart:ui';
import 'dart:io';

class LessonsPage extends StatefulWidget {
  @override
  _LessonsPageState createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  bool hasLoadedStorage;
  int newFinishedLessons;
  String currentLocale;

  //_openLessonPage(BuildContext context) {
  //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LessonPage()));
  //}
  // starting lesson number in each row
  //final List<int> lessons = <int>[1, 2, 3, 5, 6, 8, 9, 11, 13, 16, 18, 19, 21, 22, 24, 26, 29, 31, 32, 34, 36, 37, 39, 41, 44, 46, 47, 49, 50, 53, 56, 59];
  //final List<int> lessons = <int>[1, 2, 4, 6, 7, 10, 11, 13, 16, 17, 18, 20, 22, 23, 25, 27, 28, 30, 33, 34, 35, 37, 39, 40, 42, 44, 45, 48, 50, 51, 53, 54, 55, 57, 60];
  final List<int> lessons = <int>[
       1, 2, 4, 5, 7, 9,//1, 2, 4, 6, 8,
       10, 11, 13, 15,
       17, 18, 20,
       22, 23, 25,
       27, 28, 30, 32,
       34, 35, 37,
       39, 40, 42,
       44, 45, 47, 49,
       50, 51, 53,
       54, 55, 57, 59, 60];

  @override
  void initState() {
    super.initState();

    setState(() {
      this.hasLoadedStorage = false;
      this.newFinishedLessons = 0;
      this.currentLocale = theDefaultLocale;
    });
  }

  handleStorage() {
    // doing nothing for web for now
    if (!kIsWeb) {
      if (!theStorageHandler.getHasTriedToLoadStorage()) {
        var fileIO = CounterStorage();
        theFileIOFile = fileIO;
        theStorageHandler.setHasTriedToLoadStorage();
        fileIO.readString().then((String value) {
          // just once, doesn't matter whether it loads any data or not
          if (value != null) {
            var storage = theStorageHandler.getStorageFromJson(value);
            if (storage != null) {
              updateDefaultLocale(storage.language);
              theStorageHandler.setStorage(storage);
              setState(() {
                this.hasLoadedStorage = true;
              });
            }
          }
        });
      }
    }
  }

  void updateDefaultLocale(String localeFromPhysicalStorage) {
    if (localeFromPhysicalStorage != null && (localeFromPhysicalStorage == 'en_US' || localeFromPhysicalStorage == 'zh_CN')) {
      if (theDefaultLocale != localeFromPhysicalStorage) {
        theDefaultLocale = localeFromPhysicalStorage;

        // let main page refresh to pick up the language change for navigation bar items
        final BottomNavigationBar navigationBar = globalKeyNav.currentWidget;
        navigationBar.onTap(0);
      }
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
        title: Text(getString(10)/*"Hanzishu Lessons"*/), // "Lessons Page"
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
            if (index == 0 || index == 6 || index == 10 || index == 13 || index == 16 || index == 20 || index == 23 || index == 26 || index == 30 || index == 33) {

                if (index == 0) {level = 1;}
                else if (index == 6) { level = 2;}
                else if (index == 10) { level = 3;}
                else if (index == 13) { level = 4;}
                else if (index == 16) { level = 5;}
                else if (index == 20) { level = 6;}
                else if (index == 23) { level = 7;}
                else if (index == 26) { level = 8;}
                else if (index == 30) { level = 9;}
                else if (index == 33) { level = 10;}
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

  // not use for now
  Widget getADivider(int lessonNumber) {
    if (lessonNumber == 1) {
    return Container(width: 0.0, height: 0.0);
    }
    else {
      return Divider(color: Colors.black);
    }
  }

  Widget getButtonRowWithLevelBegin(BuildContext context, int lessonNumber, int lessonCount, int level) {
    return Column(
      children: <Widget>[
        //getADivider(lessonNumber),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Text(
                getString(9)/*"Unit"*/ + " " + '$level' + ": " + getString(BaseLevelDescriptionStringID + level)/*theLevelList[level].description*/,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 16.0),
              ),
              getSpaceAsNeeded(level),
              getLanguageSwitchButtonAsNeeded(level),
              //
            ]
          ),
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

  Widget getSpaceAsNeeded(int level) {
    if (level != 1) {
      return SizedBox(width: 0, height: 0);
    }

    return SizedBox(width: 60, height: 0);
  }

  Widget getLanguageSwitchButtonAsNeeded(int level) {
    if (level != 1) {
      return SizedBox(width: 0, height: 0);
    }

    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 16.0),
      ),
      onPressed: () {
        setState(() {
          currentLocale = changeTheDefaultLocale();
          //currentIndex = 1;
          //currentIndex = theInputZiManager.getNextIndex(typingType, /*currentIndex,*/ lessonId);;
        });
      },
      child: Text(getOppositeDefaultLocale(), /*English/中文*/
          style: TextStyle(color: Colors.blue)),
    );
  }

  String getOppositeDefaultLocale() {
    int idForLanguageTypeString = 378; /*English/中文*/
    // according to theDefaultLocale
    String localString = "";

    switch (theDefaultLocale) {
      case "en_US":
        {
          localString = theString_zh_CN[idForLanguageTypeString].str; // theString_en_US[id].str;
        }
        break;
      case "zh_CN":
        {
          localString = theString_en_US[idForLanguageTypeString].str; // theString_zh_CN[id].str;
        }
        break;
      default:
        {
        }
        break;
    }

    return localString;
  }

  String changeTheDefaultLocale() {
    if (theDefaultLocale == "en_US") {
      theDefaultLocale = "zh_CN";
    }
    else if (theDefaultLocale == "zh_CN") {
      theDefaultLocale = "en_US";
    }

    theStorageHandler.setLanguage(theDefaultLocale);
    theStorageHandler.SaveToFile();

    // let main page refresh to pick up the language change for navigation bar items
    final BottomNavigationBar navigationBar = globalKeyNav.currentWidget;
    navigationBar.onTap(0);

    return theDefaultLocale;
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
    //var modNumber = realNumber % 10;
    var path = "assets/lessons/L" + realNumber.toString() + ".png";
    //if (modNumber == 9) {
    //  path = "assets/IMG_6606.PNG";
    //}
    sections.add(Container(child: /*OpenHelper.*/getImageButton(context, realNumber, path/*charactertree.png*/, LessonSection.None, true, 110, 110)));

    if (lessonCount >= 2) {
      realNumber++;
      //modNumber = realNumber % 10;
      var path = "assets/lessons/L" + realNumber.toString() + ".png";
      //if (modNumber == 9) {
      //  path = "assets/IMG_6606.PNG";
      //}
      sections.add(Container(child: /*OpenHelper.*/getImageButton(context, realNumber, path/*conversations.png*/, LessonSection.None, true, 110, 110)));

      if (lessonCount >= 3) {
        realNumber++;
        //modNumber = realNumber % 10;
        var path = "assets/lessons/L" + realNumber.toString() + ".png";
        //if (modNumber == 9) {
        //  path = "assets/IMG_6606.PNG";
        //}
        sections.add(Container(child: /*OpenHelper.*/getImageButton(context, realNumber,  path/*charactertree.png*/, LessonSection.None, true, 110, 110)));
      }
    }

    return sections;
  }

  _getRequests() async {
    if (theHasNewlyCompletedLesson) {
      setState(() {
        // force refresh to pick up the completed icon for the lesson
        this.newFinishedLessons += 1;
      });

      theHasNewlyCompletedLesson = false;
    }
  }

  openPage(BuildContext context, int lessonId) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LessonPage(lessonId: lessonId))).then((val)=>{_getRequests()});
  }

  Widget getImageButton(BuildContext context, int lessonNumber, String imagePath, LessonSection lessonSection, bool isLesson, double xSize, double ySize) {
    //var lesson = theLessonManager.getLesson(lessonNumber);
    //String lessonOrSectionName = "";
      //lessonOrSectionName = lesson.titleTranslation;

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
                        getString(BaseLessonTitleTranslationStringID + lessonNumber), //lessonOrSectionName, //lesson.titleTranslation, //"Hello",
                        style: TextStyle(fontSize: 14.0, fontFamily: "Raleway"),
                      ),
                      OpenHelper.getCompletedImage(lessonNumber),
                    ]
                ),
              ]
          ),

          onTap: () => openPage(context, lessonNumber),
        );
    }
}