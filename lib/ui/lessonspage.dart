import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hanzishu/engine/fileio.dart';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/engine/lessonunitmanager.dart';
import 'package:hanzishu/engine/paintsoundmanager.dart';
import 'package:flutter/material.dart';
import 'package:hanzishu/ui/imagebutton.dart';

import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/lessonunitlist.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/lessonpage.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/localization/string_en_US.dart';
import 'package:hanzishu/localization/string_zh_CN.dart';
import 'package:hanzishu/ui/paintsoundpage.dart';
import 'package:hanzishu/ui/wordlaunchpage.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/ui/componentpage.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/engine/lessonunit.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:video_player/video_player.dart';
import 'dart:ui';
import 'dart:io';
import 'package:hanzishu/engine/thirdpartylesson.dart';

class LessonsPage extends StatefulWidget {
  @override
  _LessonsPageState createState() => _LessonsPageState();
}

var courseMenuList = [
  // allocate local language during run time
  CourseMenu(1, 429),
  CourseMenu(2, 423),
  //CourseMenu(3, 424),
  //CourseMenu(4, 425),
  //CourseMenu(5, 426),
];

class _LessonsPageState extends State<LessonsPage> {
  static List<int> NumberOfLessonsInLevel = [60, 2];

  late bool hasLoadedStorage;
  int newFinishedLessons = -1;

  late String currentLocale;

  late double screenWidth;

  late List<DropdownMenuItem<CourseMenu>> _dropdownCourseMenuItems;
  late CourseMenu _selectedCourseMenu;

  int currentSoundPaintSection = -1;
  late SoundCategory currentSoundCategory;

  int numberOfExercises = 0;

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

  final List<int> level2Lessons = <int>[
    1, 2,
    4, 6, 7,
    8, 10,
    11, 13,
    15, 17,
    19,
    21, 23, 25, 27, 28, 30, 32, 34, 35, 37, 39, 40, 42,
    44, 45, 47, 49,
    50, 51, 53,
    54, 55, 57, 59, 60];

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      this.hasLoadedStorage = false;
      this.newFinishedLessons = 0;
      currentSoundCategory = SoundCategory.hanzishuLessons;
      currentSoundPaintSection = 0;
      _dropdownCourseMenuItems = buildDropdownCourseMenuItems(courseMenuList);
      _selectedCourseMenu = _dropdownCourseMenuItems[0].value!;
    });
  }

  @override
  void dispose() {
    super.dispose();
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
        final BottomNavigationBar navigationBar = globalKeyNav.currentWidget as BottomNavigationBar;
        navigationBar.onTap!(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // do here so that it'll refresh the lessonspage to reflect the lesson completed status from storage.
    // also away from the main thread I think.
    // do it only once
    screenWidth = Utility.getScreenWidth(context);

    // make sure it picks up the right locale
    _dropdownCourseMenuItems = buildDropdownCourseMenuItems(courseMenuList);
//    _selectedCourseMenu = _dropdownCourseMenuItems[0].value;

    handleStorage();

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(10)/*"Hanzishu Lessons"*/), // "Lessons Page"
      ),
      body: Center
        (
        child: getCoursePage(),
      ),
    );
  }

  Widget getCoursePage() {
    if (_selectedCourseMenu.id == 1) {
      return getHanzishuLessons();
    }
    else if (_selectedCourseMenu.id == 2) {
      //return getPaintIndex(context, SoundCategory.intro);
      return getHanzishuLessons2();
    }
    else if (_selectedCourseMenu.id == 3) {
      return getPaintIndex(context, SoundCategory.erGe);
    }
    else if (_selectedCourseMenu.id == 4) {
      return getPaintIndex(context, SoundCategory.tongYao);
    }
    else if (_selectedCourseMenu.id == 5) {
      return getPaintIndex(context, SoundCategory.tongHua);
    }
    else {
      return SizedBox(width: 0.0, height: 0.0);
    }
  }

  Widget getHanzishuLessons() {
    return ListView.builder(
        itemCount/*itemExtent*/: lessons.length,
        itemBuilder/*IndexedWidgetBuilder*/: (BuildContext context, int index) {
          //NOTE: the index has to go with row, not lesson, that's why the more complicated approach here.
          int lessonCount = 1;

          // assume last row has one item
          if (index == lessons.length - 1) {
            lessonCount = 1;  // have to specify the number of last row
          }
          else if (index < lessons.length - 1) {
            lessonCount = lessons[index + 1] - lessons[index];
          }

          int unit = 1;
          //if (index == 0 || index == 4 || index == 8 || index == 11 || index == 14 || index == 18 || index == 21 || index == 24 || index == 27 || index == 30 || index == 34) {
          if (index == 0 || index == 6 || index == 10 || index == 13 || index == 16 || index == 20 || index == 23 || index == 26 || index == 30 || index == 33) {

            if (index == 0) {unit = 1;}
            else if (index == 6) { unit = 2;}
            else if (index == 10) { unit = 3;}
            else if (index == 13) { unit = 4;}
            else if (index == 16) { unit = 5;}
            else if (index == 20) { unit = 6;}
            else if (index == 23) { unit = 7;}
            else if (index == 26) { unit = 8;}
            else if (index == 30) { unit = 9;}
            else if (index == 33) { unit = 10;}
            //else if (index == 34) { unit = 10;}
            //return getLessonUnit(context, unit);
            return getButtonRowWithUnitBegin(context, lessons[index], lessonCount, unit, 1 /*level 1*/);
          }
          else {
            return getButtonRow(context, lessons[index], lessonCount, unit, 1/*level*/);
          }
        }
    );
  }

  Widget getHanzishuLessons2() {
    int unit = 1;
    return ListView.builder(
        itemCount/*itemExtent*/: 12, //TODO: update everytime with new lessons. //level2Lessons.length, // Note: this is a row count.
        itemBuilder/*IndexedWidgetBuilder*/: (BuildContext context, int index) {
          int lessonCount = 1;

          // assume last row has one item
          if (index == level2Lessons.length - 1) {
            lessonCount = 1;  // have to specify the number of last row
          }
          else if (index < level2Lessons.length - 1) {
            lessonCount = level2Lessons[index + 1] - level2Lessons[index];
          }

          //if (index == 0 || index == 4 || index == 8 || index == 11 || index == 14 || index == 18 || index == 21 || index == 24 || index == 27 || index == 30 || index == 34) {
          if (index == 0 || index == 2 || index == 5 || index == 7 || index == 9 || index == 11 || index == 23 || index == 26 || index == 30 || index == 33) {

            if (index == 0) {unit = 1;}
            else if (index == 2) { unit = 2;}
            else if (index == 5) { unit = 3;}
            else if (index == 7) { unit = 4;}
            else if (index == 9) { unit = 5;}
            else if (index == 11) { unit = 6;}
            else if (index == 12) { unit = 7;}
            else if (index == 26) { unit = 8;}
            else if (index == 30) { unit = 9;}
            else if (index == 33) { unit = 10;}
            //else if (index == 34) { unit = 10;}
            //return getLessonUnit(context, unit);
            return getButtonRowWithUnitBegin(context, level2Lessons[index], lessonCount, unit + 10, 2/*level*/); // for level 2
          }
          else {
            //unit += 10; // for level 2
            return getButtonRow(context, level2Lessons[index], lessonCount, unit + 10, 2/*level*/); // for level 2
          }
        }
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

  List<DropdownMenuItem<CourseMenu>> buildDropdownCourseMenuItems(List courseMenuList) {
    List<DropdownMenuItem<CourseMenu>> items = []; //List();
    for (CourseMenu courseMenu in courseMenuList) {
      items.add(
        DropdownMenuItem(
          value: courseMenu,
          child: Text(getString(courseMenu.stringId)),
        ),
      );
    }
    return items;
  }

  Widget getButtonRowWithUnitBegin(BuildContext context, int lessonNumber, int lessonCount, int unit, int levelNumber) {
    return Column(
      children: <Widget>[
        //getADivider(lessonNumber),
        getUnitReview(unit-1), // "unit - 1" is the real unit for last unit's review
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              getCourseType(context, lessonNumber),
              SizedBox(width: 30, height: 0),
              //SizedBox(width: 30, height: 0),
              //getSpaceAsNeeded(unit),
              getLanguageSwitchButtonAsNeeded(unit),
              //
            ]
          ),
        ),
        Text(
          getString(9)/*"Unit"*/ + " " + '$unit' + ": " + LessonUnitManager.getLessonUnitDescriptionString(unit),
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 16.0),
        ),
        Divider(color: Colors.black),
        getTypingCourseForLesson(unit),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: getRowSections(context, lessonNumber, lessonCount, unit, levelNumber),
          ),
          padding: EdgeInsets.all(20),
        ),
      ]
    );
  }

  Widget getTypingCourseForLesson(int unit) {
    if (unit == 1) {
      return
        InkWell(
          child: Column(
              children: [
                Ink.image(
                  image: AssetImage("assets/lessons/L28.png"),
                  width: 110.0, //xSize,
                  height: 110.0, //ySize,
                ),
                //Row(
                    //children: [
                      Text(
                        "0. " + getString(494),
                        style: TextStyle(fontSize: 14.0, fontFamily: "Raleway"),
                      ),
                      //OpenHelper.getCompletedImage(lessonNumber),
                   // ]
                //),
              ]
          ),

          onTap: () {
            theIsFromTypingContinuedSection = true;
            LaunchExercise(0);
          },
        );
    }
    else {
      return SizedBox(width: 0, height: 0);
    }
  }

  Widget getUnitReviewAtLesson(int unit, int lesson) {
    if (lesson != 60) { //first lesson of last row of lessons
      return SizedBox(width: 0, height: 0);
    }

    return getUnitReview(unit);
  }

  Widget getLanguageSwitchButtonAsNeeded(int unit) {
    if (unit != 1 && unit != 11)  {
      return SizedBox(width: 0, height: 0);
    }

    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 16.0),
      ),
      onPressed: () {
        setState(() {
          currentLocale = changeTheDefaultLocale();
          _dropdownCourseMenuItems = buildDropdownCourseMenuItems(courseMenuList);
        });
      },
      child: Text(getOppositeDefaultLocale(), /*English/中文*/
          style: TextStyle(color: Colors.blue)),
    );
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
    final BottomNavigationBar navigationBar = globalKeyNav.currentWidget as BottomNavigationBar;
    navigationBar.onTap!(0);

    return theDefaultLocale;
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

  Widget getSpaceAsNeeded(int unit) {
    if (unit != 1) {
      return SizedBox(width: 0, height: 0);
    }

    return SizedBox(width: 60, height: 0);
  }

  Widget getButtonRow(BuildContext context, int lessonNumber, int lessonCount, int unit, int level) {
    return Column(
        children: <Widget>[
          getButtonRowOneContainer(lessonNumber, lessonCount, unit, level),
          //getADivider(lessonNumber),
          getUnitReviewAtLesson(10, lessonNumber),
        ]
    );
  }

  Widget getButtonRowOneContainer(int lessonNumber, int lessonCount, int unit, int level) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: getRowSections(context, lessonNumber, lessonCount, unit, level),
      ),
      padding: EdgeInsets.all(20),
    );
  }

  List<Widget> getRowSections(BuildContext context, int lessonNumber, int lessonCount, int unit, int level) {
    int realNumber = lessonNumber;
    if (level == 2) {
      realNumber += NumberOfLessonsInLevel[0];
    }

    List<Widget> sections = [];
    //var modNumber = realNumber % 10;
    var path = LessonManager.getLessonImagePath(realNumber, unit); //"assets/lessons/L" + lessonNumber.toString() + ".png";
    //if (modNumber == 9) {
    //  path = "assets/IMG_6606.PNG";
    //}
    sections.add(Container(child: /*OpenHelper.*/getImageButton(context, realNumber, unit, path/*charactertree.png*/, LessonSection.None, true, 110, 110)));

    if (lessonCount >= 2) {
      realNumber++;
      //modNumber = realNumber % 10;
      var path = LessonManager.getLessonImagePath(realNumber, unit); //"assets/lessons/L" + lessonNumber.toString() + ".png";
      //if (modNumber == 9) {
      //  path = "assets/IMG_6606.PNG";
      //}
      sections.add(Container(child: /*OpenHelper.*/getImageButton(context, realNumber,unit,  path/*conversations.png*/, LessonSection.None, true, 110, 110)));

      if (lessonCount >= 3) {
        realNumber++;
        //modNumber = realNumber % 10;
        var path = LessonManager.getLessonImagePath(realNumber, unit); //"assets/lessons/L" + lessonNumber.toString() + ".png";
        //if (modNumber == 9) {
        //  path = "assets/IMG_6606.PNG";
        //}
        sections.add(Container(child: /*OpenHelper.*/getImageButton(context, realNumber,  unit, path/*charactertree.png*/, LessonSection.None, true, 110, 110)));
      }
    }

    return sections;
  }

  _getLessonRequests() async {
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
        MaterialPageRoute(builder: (context) => LessonPage(lessonId: lessonId))).then((val)=>{_getLessonRequests()});
  }

  Widget getImageButton(BuildContext context, int lessonNumber, int unit, String imagePath, LessonSection lessonSection, bool isLesson, double xSize, double ySize) {
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
                        LessonManager.getLessonTitle(lessonNumber, unit),
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

  Widget getCourseType(BuildContext context, int lessonNumber) {
      if (currentSoundCategory == SoundCategory.hanzishuLessons && lessonNumber != 1 && lessonNumber != 61) {
        return SizedBox(width: 0, height: 0);
      }

      return DropdownButton(
        value: _selectedCourseMenu,
        items: _dropdownCourseMenuItems,
        onChanged: (selectedCourseMenu) {
          setState(() {
            _selectedCourseMenu = selectedCourseMenu as CourseMenu;
          });
        },
        //onChangeDropdownCourseItem,
      );
  }

  Widget getUnitReview(int realUnit) {
    if (realUnit == 0 || realUnit == 10) { // first unit in level 1 and level 2
      return SizedBox(width: 0, height: 0);
    }

    return RawMaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(33),
          ),
          side: BorderSide(color: Colors.blue, width: 0.5)
      ),
      fillColor: Colors.blue,
      onPressed: () {
        var newHanziPerLevel = LessonUnitManager.getNewHanzi(realUnit);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>
                WordLaunchPage(drillCategory: DrillCategory.custom,
                    subItemId: realUnit, //subItemId,
                    customString: newHanziPerLevel/*"品笑井输入法"*/, thirdPartyType: ThirdPartyType.none)));
      },
      child: Text(getString(296) + ' ' + getString(387) + ' ' + realUnit.toString(), //"Review unit 1"
          style: TextStyle(color: Colors.brown)), // lightBlue
    )
    ;
  }

  onChangeDropdownCourseItem(CourseMenu selectedCourseMenu) {
    setState(() {
      _dropdownCourseMenuItems = buildDropdownCourseMenuItems(courseMenuList);
      _selectedCourseMenu = selectedCourseMenu;
    });
  }

  Widget getPaintIndex(BuildContext context, SoundCategory soundCategory) {
    currentSoundCategory = soundCategory;
    var count = 26; // one extra for pulldown menu
    var courseType;

    if (soundCategory == SoundCategory.intro) {
      count = 3; // where 1 is the temp number for intro buttons, will be 2
      courseType = 2;
    }
    else if (soundCategory == SoundCategory.erGe) {
      courseType = 3;
    }
    else if (soundCategory == SoundCategory.tongYao) {
      courseType = 4;
    }
    else if (soundCategory == SoundCategory.tongHua) {
      courseType = 5;
    }

    return ListView.builder(
        shrinkWrap: true,
        itemCount/*itemExtent*/: count,
        itemBuilder/*IndexedWidgetBuilder*/: (BuildContext context, int index) {
          if (index == 0) {
            return getCourseType(context, courseType); // courseType == level
          }
          else {
            return getSoundButtonRow(context, index);
          }
        }
    );
  }

  Widget getSoundButtonRow(BuildContext context, int index) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: getPaintRowSections(context, index),
      ),
      padding: EdgeInsets.all(20),
    );
  }

  List<Widget> getPaintRowSections(BuildContext context, int index) {
    List<Widget> sections = [];

    var path;
    var indexBase;

    if (SoundCategory.intro == currentSoundCategory) {
      if (index == 1) {
        path = "assets/paintx/x1_1.png";
      }
      else if (index == 2) {
        path = "assets/paintx/x2_56.png";
      }
      indexBase = index - 1;
    }
    if (SoundCategory.erGe == currentSoundCategory) {
      path = "assets/lessons/L58.png";
      indexBase = (index - 1) * 4;
    }
    else if (SoundCategory.tongYao == currentSoundCategory) {
      path = "assets/lessons/L59.png";
      indexBase = (index - 1) * 4;
    }
    else if (SoundCategory.tongHua == currentSoundCategory) {
      path = "assets/lessons/L60.png";
      indexBase = (index - 1) * 4;
    }

    sections.add(Container(child: getPaintImageButton(context, indexBase + 1, path, 60 * getSizeRatioWithLimit(), 60 * getSizeRatioWithLimit())));
    if (SoundCategory.intro != currentSoundCategory) {
      sections.add(Container(
          child: getPaintImageButton(context, indexBase + 2, path, 60 * getSizeRatioWithLimit(), 60 * getSizeRatioWithLimit())));
      sections.add(Container(
          child: getPaintImageButton(context, indexBase + 3, path, 60 * getSizeRatioWithLimit(), 60 * getSizeRatioWithLimit())));
      sections.add(Container(
          child: getPaintImageButton(context, indexBase + 4, path, 60 * getSizeRatioWithLimit(), 60 * getSizeRatioWithLimit())));
    }

    return sections;
  }

  Widget getPaintImageButton(BuildContext context, int lessonNumber, String imagePath, double xSize, double ySize) {
    return InkWell(
        child: Column(
            children: [
              Ink.image(
                image: AssetImage(imagePath),
                width: xSize,
                height: ySize,
              ),
              Text(
                lessonNumber.toString(),
                style: TextStyle(fontSize: 14.0, fontFamily: "Raleway"),
              ),
            ]
        ),

        onTap: () {
          setState(() {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => PaintSoundPage(currentSoundCategory, lessonNumber)));
          });
        }

    );
  }

  _getRequests() async {
    //setState(() {
    // force refresh every time to make sure to pick up completed icon
    this.numberOfExercises += 1;
    //});

    if (!theIsBackArrowExit && this.numberOfExercises <= 4) {
      // reinit
      theIsBackArrowExit = true;
      LaunchExercise(this.numberOfExercises);
    }
    else {
      // init all variables
      // either true back arrow or all done
      theIsBackArrowExit = true;
      theIsFromTypingContinuedSection = false;
      this.numberOfExercises = 0;
    }
    //}
  }

  LaunchExercise(int exerciseNumber) {
    switch (exerciseNumber) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InputZiPage(
                    typingType: TypingType.FirstTyping, lessonId: 0,  wordsStudy: '', isSoundPrompt: false, inputMethod: InputMethod.Pinxin, showHint: 3, includeSkipSection: true, showSwitchMethod: false),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ComponentPage(questionType: QuestionType.Component),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InputZiPage(typingType: TypingType.LeadComponents,
                    lessonId: 0, wordsStudy: '', isSoundPrompt: false, inputMethod: InputMethod.Pinxin, showHint: 1, includeSkipSection: true, showSwitchMethod: false) //InputZiPage(),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ComponentPage(questionType: QuestionType.ExpandedComponent),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InputZiPage(
                    typingType: TypingType.ExpandedReview, lessonId: 0,  wordsStudy: '', isSoundPrompt: false, inputMethod: InputMethod.Pinxin, showHint: 3, includeSkipSection: true, showSwitchMethod: false), //InputZiPage(),
          ),
        ).then((val) => {_getRequests()});
        break;
        /*
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InputZiPage(
                    typingType: TypingType.SingleComponent, lessonId: 0, isSoundPrompt: false, inputMethod: InputMethod.Pinxin, showHint: 3, includeSkipSection: false, showSwitchMethod: false), //InputZiPage(),
          ),
        ).then((val) => {_getRequests()});
        break;
        */
      default:
        break;
    }
  }
}