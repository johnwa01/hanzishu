import 'package:flutter/material.dart';
import 'package:hanzishu/engine/quizmanager.dart';
import 'package:hanzishu/ui/imagebutton.dart';
import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/ui/pinyinpage.dart';
import 'package:hanzishu/engine/pinyin.dart';
import 'package:hanzishu/ui/standardexampage.dart';
import 'package:hanzishu/ui/quizpage.dart';
import 'package:hanzishu/ui/dictionarysearchingpage.dart';
import 'package:hanzishu/ui/drillpagecore.dart';
import 'package:hanzishu/ui/conversationpage.dart';
import 'package:hanzishu/ui/conversationsnowballpage.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/ui/practicesheetpage.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/data/searchingzilist.dart';

class LessonPage extends StatefulWidget {
  final int lessonId;
  LessonPage({this.lessonId});

  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  //_openTreePage(BuildContext context) {
  //_LessonPageState(BuildContext context) {
  //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => TreePage()));
  //}
  double screenWidth;
  int numberOfExercises = 0;

  @override
  void initState() {
    super.initState();

    // should just run once
    // believe initState only runs once, but added a global variable in case ReviewPage has run it already.
    if (!theHavePopulatedLessonsInfo) {
      LessonManager.populateLessonsInfo();
      theHavePopulatedLessonsInfo = true;
    }
  }

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  _getRequests() async {
      this.numberOfExercises += 1;
      if (this.numberOfExercises == 1 && widget.lessonId > 60) {
        this.numberOfExercises += 1; // skip drill section
      }

      if (this.numberOfExercises == 2 && (widget.lessonId < 10 || widget.lessonId > 60 || (widget.lessonId > 33 && widget.lessonId < 41))) { // changed the range together with getPinyinButton()
        this.numberOfExercises += 1; // skip Pinyin section
      }

      if (this.numberOfExercises == 5 && widget.lessonId > 60) {
        this.numberOfExercises += 1; // skip quiz section
      }

      if (!theIsBackArrowExit && theIsFromLessonContinuedSection && numberOfExercises <= 5) {
        // re-init for next section's action
        theIsBackArrowExit = true;
        launchLessonSection(context, theCurrentLessonId, numberOfExercises);
      }
      else {
        // reset
        theIsFromLessonContinuedSection = false; // exit and prepare for next main visit
        theIsBackArrowExit = true;
        numberOfExercises = 0;
      }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);

    //theIsFromLessonContinuedSection = false;
    theCurrentLessonId = widget.lessonId;

    String lessonName = getString(7) /*"Lesson"*/ + " " + theCurrentLessonId.toString() + ": " + getString(theLessonList[theCurrentLessonId].titleId)/* + " " + theLessonList[theCurrentLessonId].title*/;

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(lessonName),   // "Lesson page"
      ),
      body: Center
        (
        //child: Text("This is Lesson Page."),
        child: getLessonSections(context, widget.lessonId),
      ),
    );
  }

  launchLessonSection(BuildContext context, int lessonId, int lessonSection) {
    var pinyinType = PinyinType.OnlyNewZi;
    if (lessonId <= Lesson.numberOfLessonsInUnit1) {
      pinyinType = PinyinType.None;
    }
    //else if (lessonId > Lesson.numberOfLessonsInUnit1 && lessonId <= Lesson.numberOfLessonsInLevel1) { // TODO: change to numberOfLessonsInUnit1ToUnit5
    //  pinyinType = PinyinType.OnlyFirst;
    //}

    switch (lessonSection) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ConversationPage(lessonId: lessonId, pinyinType: pinyinType),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 1:
        theAllZiLearned = false;
        /*
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TreePage(lessonId: lessonId),
          ),
        ).then((val) => {_getRequests()});
        */
        var convChars = theLessonManager.getConvChars(lessonId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DrillPageCore(drillCategory: DrillCategory.custom, startingCenterZiId: 1, subItemId: lessonId, isFromReviewPage: false, customString: convChars),
          ),
        ).then((val) => {_getRequests()});
        break;
        case 2:
          int pinyinLesson = lessonId - 10; // starting from lesson 10 by default
          if (lessonId >= 37) {             // second round of pinyin starting from lesson 37. no pinyin from 34 to 36.
            pinyinLesson = lessonId - 37;
          }

          bool includeSkipSection = false;
          if (theIsFromLessonContinuedSection) {
            includeSkipSection = true;
          }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PinyinPage(currentPinyinLessonId: pinyinLesson, includeSkipSection: includeSkipSection),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 3:
        bool includeSkipSection = false;
        if (theIsFromLessonContinuedSection) {
          includeSkipSection = true;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  InputZiPage(typingType: TypingType.FromLessons, lessonId: lessonId, wordsStudy: null, isSoundPrompt: false, inputMethod: InputMethod.Pinxin, showHint: 1, includeSkipSection: includeSkipSection, showSwitchMethod: false)
          ),
        ).then((val) => {_getRequests()});
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ConversationSnowballPage(lessonId: lessonId, pinyinType: pinyinType), //InputZiPage(),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 5:
        //if (lessonId <= Lesson.numberOfLessonsInLevel1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  QuizPage(quizTextbook: QuizTextbook.hanzishu,
                      quizCategory: QuizCategory.none,
                      lessonId: lessonId,
                      wordsStudy: null,
                      includeSkipSection: true),
            ),
          ).then((val) => {_getRequests()});
        //}
        /*
        else {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  StandardExamPage(drillCategory: DrillCategory.custom,
                      subItemId: 0,
                      quizCategory: QuizCategory.ziToSound,
                      customString: theLessonList[theCurrentLessonId].convChars),
              ),
          ).then((val) => {_getRequests()});;
        }
        */
        break;
      case 6:
        var initZis = getConvCharsForLesson(lessonId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PracticeSheetPage(initZis: initZis),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 7:
        var convChars = theLessonManager.getConvChars(lessonId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DictionarySearchingPage(
                    dicStage: DictionaryStage.detailedzi,
                    firstOrSearchingZiIndex: -1,
                    flashcardList: convChars,
                    dicCaller: DicCaller.Flashcard),
          ),
        ).then((val) => {_getRequests()});
        break;
      default:
        break;
    }
  }

  // not sure why needs this, seems like just lesson.convChars?
  String getConvCharsForLesson(int lessonId) {
    String initZis = '';
    var lesson = theLessonManager.getLesson(lessonId);
    var length = lesson.convCharsIds.length;
    for (int i = 0; i < length; i++) {
      initZis += theSearchingZiList[lesson.convCharsIds[i]].char;
    }

    return initZis;
  }

  Widget getLessonSections(BuildContext context, int lessonId) {
    // put scrollview since I get render overflow issue
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //Container(
          //  padding: EdgeInsets.all(5),
          //),
          Container(
            child: Text(getString(8) + lessonId.toString()/*"Please complete exercises in order."*/, style: TextStyle(fontSize: 20.0),),
            padding: EdgeInsets.all(15),
          ),
          //Container(
          //  alignment: Alignment.topRight, //topLeft,
          //  onPressed: () {
          //    launchLessonSection(context, 1, 0);
          //  },
          //}
          InkWell(
            child: //Column(
              //children: [
                Ink.image(
                  image: AssetImage("assets/core/lessonimage.png"),
                  width: 170 * getSizeRatioWithLimit(), //130
                  height: 110 * getSizeRatioWithLimit(), //80
                ),
                //Text(
                //  lessonOrSectionName, //lesson.titleTranslation, //"Hello",
                //  style: TextStyle(fontSize: 14.0, fontFamily: "Raleway"),
                //),
              //]
            //),
            onTap: () => { theIsFromLessonContinuedSection = true,
                        launchLessonSection(context, lessonId, 0), }
          ),
          SizedBox(
            height: 60.0, //40
          ),
          Container(
            child: Text(getString(403), style: TextStyle(fontSize: 16.0),),
            //padding: EdgeInsets.all(15),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                getButton(context, lessonId, 0),
                getButton(context, lessonId, 1),
              ],
            ),
            //padding: EdgeInsets.all(20),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                getPinyinButton(context, lessonId, 2),
                getButton(context, lessonId, 3),
              ],
            ),
            //padding: EdgeInsets.all(20),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                getButton(context, lessonId, 4),
                getButton(context, lessonId, 5),
              ],
            ),
            //padding: EdgeInsets.all(20),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                getButton(context, lessonId, 6),
                getButton(context, lessonId, 7),
              ],
            ),
            //padding: EdgeInsets.all(20),
          ),
        ]
      ),
    );
  }

  Widget getPinyinButton(BuildContext context, int lessonId, int lessonSection) {
    if ((lessonId >= 10 && lessonId <= 33) || (lessonId >= 41 && lessonId <= 60)) {  // changed the range together with _getRequests()
      return getButton(context, lessonId, lessonSection);
    }
    else {
      return SizedBox(width: 0.0, height: 0.0);
    }
  }


  Widget getButton(BuildContext context, int lessonId, int lessonSection) {
    String buttonTitle = "";
    switch (lessonSection) {
      case 0:
        if (lessonId <= Lesson.numberOfLessonsInLevel1) {
          buttonTitle = getString(4);
        }
        else {
          buttonTitle = getString(482);
        }
        break;
      case 1:
        buttonTitle = getString(456);
        break;
      case 2: // new
        buttonTitle = getString(505);
        break;
      case 3:
        buttonTitle = getString(5);
        break;
      case 4:
        buttonTitle = getString(373);
        break;
      case 5:
        buttonTitle = getString(6);
        break;
      case 6:
        buttonTitle = getString(454);
        break;
      case 7:
        buttonTitle = getString(2); // Flashcards
        break;
      default:
        break;
    }

    var butt = FlatButton(
      color: Colors.white,
      textColor: Colors.black,
      onPressed: () {
        launchLessonSection(context, lessonId, lessonSection);
      },
      child: Text(buttonTitle, style: TextStyle(fontSize: getSizeRatioWithLimit() * 14.0)),
    );

    return butt;
  }
}