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
  LessonPage({required this.lessonId});

  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  //_openTreePage(BuildContext context) {
  //_LessonPageState(BuildContext context) {
  //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => TreePage()));
  //}
  double screenWidth = 0.0;
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
      if (this.numberOfExercises == 2 && widget.lessonId > 60) {
        this.numberOfExercises += 1; // skip drill section
      }

      if (this.numberOfExercises == 1 && (widget.lessonId < 10 || widget.lessonId > 60 || (widget.lessonId > 33 && widget.lessonId < 41))) { // changed the range together with getPinyinButton()
        this.numberOfExercises += 1; // skip Pinyin section
      }

      if (this.numberOfExercises == 6 && widget.lessonId > 60) {
        this.numberOfExercises += 1; // skip quiz section
      }

      if (!theIsBackArrowExit && theIsFromLessonContinuedSection && numberOfExercises <= 6) {
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
    thePositionManager.setFrameWidth(screenWidth - 10.0);

    //theIsFromLessonContinuedSection = false;
    theCurrentLessonId = widget.lessonId;

    String lessonName = getString(7) /*"Lesson"*/ + " " + theCurrentLessonId.toString() + ": " + getString(theLessonList[theCurrentLessonId].titleId)/* + " " + theLessonList[theCurrentLessonId].title*/;

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(lessonName),   // "Lesson page"
      ),
      body: Align
        (
        alignment: Alignment.topCenter,
        //child: Text("This is Lesson Page."),
        child: getLessonSections(context, widget.lessonId),
      ),
    );
  }

  launchLessonSection(BuildContext context, int lessonId, int lessonSection) {
    var pinyinType = PinyinType.Full;
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
        int pinyinLesson = lessonId - 10; // starting from lesson 10 by default
        //if (lessonId >= 37) {             // second round of pinyin starting from lesson 37. no pinyin from 34 to 36.
        //  pinyinLesson = lessonId - 37;
        //}

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
      case 2:
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
      case 3:
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
      case 4:
        bool includeSkipSection = false;
        if (theIsFromLessonContinuedSection) {
          includeSkipSection = true;
        }

        HintType lessonShowHint = HintType.Hint3;
        if (lessonId > 30) { // half way of beginner level
          lessonShowHint = HintType.Hint0; // default to no hint
        }

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  InputZiPage(typingType: TypingType.FromLessons, lessonId: lessonId, wordsStudy: '', isSoundPrompt: false, inputMethod: InputMethod.Pinxin, showHint: lessonShowHint, includeSkipSection: includeSkipSection, showSwitchMethod: false)
          ),
        ).then((val) => {_getRequests()});
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ConversationSnowballPage(lessonId: lessonId, pinyinType: pinyinType), //InputZiPage(),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 6:
        //if (lessonId <= Lesson.numberOfLessonsInLevel1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  QuizPage(quizTextbook: QuizTextbook.hanzishu,
                      quizCategory: QuizCategory.none,
                      lessonId: lessonId,
                      wordsStudy: '',
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
      case 7:
        var initZis = getConvCharsForLesson(lessonId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PracticeSheetPage(initZis: initZis),
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
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Column(
            children: <Widget>[
              //Container(
              //  padding: EdgeInsets.all(5),
              //),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Icon( Icons.sentiment_very_satisfied, size: 100, color: Colors.orange, ),
              ),

              Container(
                child: Text(getString(8) + lessonId.toString()/*"Please complete exercises in order."*/, style: TextStyle(fontSize: 20.0),),
                padding: EdgeInsets.all(15),
              ),

              InkWell(
                onTap: () {
                  theIsFromLessonContinuedSection = true;
                  launchLessonSection(context, lessonId, 0);
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.play_circle_fill,
                        size: 72,
                        color: Colors.blueAccent,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Start Lesson",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 60.0, //40
              ),

              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    //       getButton(context, lessonId, 6),
                    //getButton(context, lessonId, 7),
                    InkWell(
                      onTap: () {
                        launchLessonSection(context, lessonId, 7);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 280,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Hanzi Practice Sheet",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //padding: EdgeInsets.all(20),
            ),
          ]
        ),
        ),
    );
  }

  Widget getPinyinButton(BuildContext context, int lessonId, int lessonSection) {
    if ((lessonId >= 10 && lessonId <= 60)) {  // changed the range together with _getRequests()
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
        buttonTitle = getString(505);
        break;
      case 2:
        buttonTitle = getString(456);
        break;
      case 3:
        buttonTitle = getString(2);
        break;
      case 4:
        buttonTitle = getString(5);
        break;
      case 5:
        buttonTitle = getString(373);
        break;
      case 6:
        buttonTitle = getString(6);
        break;
      case 7:
        buttonTitle = getString(454);
        break;
      default:
        break;
    }

    var butt = TextButton(
      //color: Colors.white,
      //textColor: Colors.black,
      onPressed: () {
        launchLessonSection(context, lessonId, lessonSection);
      },
      child: Text(buttonTitle, style: TextStyle(fontSize: getSizeRatioWithLimit() * 14.0, color: Colors.black)),
    );

    return butt;
  }
}