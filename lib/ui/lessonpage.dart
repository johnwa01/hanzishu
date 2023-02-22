import 'package:flutter/material.dart';
import 'package:hanzishu/ui/imagebutton.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/ui/treepage.dart';
import 'package:hanzishu/ui/listofzipage.dart';
import 'package:hanzishu/ui/breakoutpage.dart';
import 'package:hanzishu/ui/quizpage.dart';
import 'package:hanzishu/ui/conversationpage.dart';
import 'package:hanzishu/ui/conversationsnowballpage.dart';
import 'package:hanzishu/ui/inputzipage.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/data/lessonlist.dart';

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

  _getRequests() async {
    //if (theNewlyCompletedTypingExercise != -1) {
      //exerciseCompleted[theNewlyCompletedTypingExercise] = true;
      //theNewlyCompletedTypingExercise = -1;

      //setState(() {
      // force refresh every time to make sure to pick up completed icon
      this.numberOfExercises += 1;
      //});

      if (!theIsBackArrowLessonExit && numberOfExercises <= 6) {
        // re-init for next section's action
        theIsBackArrowLessonExit = true;
        launchLessonSection(context, theCurrentLessonId, numberOfExercises);
      }
      else {
        // reset
        numberOfExercises = 0;
      }
    //}
  }

  @override
  Widget build(BuildContext context) {
    theCurrentLessonId = widget.lessonId;

    String lessonName = getString(7) /*"Lesson"*/ + " " + theCurrentLessonId.toString() + ": " + getString(BaseLessonTitleTranslationStringID + theLessonList[theCurrentLessonId].titleId)/* + " " + theLessonList[theCurrentLessonId].title*/;

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
    switch (lessonSection) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TreePage(lessonId: lessonId),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ListOfZiPage(lessonId: lessonId),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BreakoutPage(lessonId: lessonId),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ConversationPage(lessonId: lessonId),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ConversationSnowballPage(lessonId: lessonId), //InputZiPage(),
          ),
        ).then((val) => {_getRequests()});
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InputZiPage(typingType: TypingType.FromLessons, lessonId: lessonId)
          ),
        ).then((val) => {_getRequests()});
        break;
      case 6:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                QuizPage(lessonId: lessonId),
          ),
        ).then((val) => {_getRequests()});
        break;
      default:
        break;
    }
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
            child: Text(getString(8) + lessonId.toString()/*"Please complete exercises in order."*/, style: TextStyle(fontSize: 16.0),),
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
                  image: AssetImage("assets/core/characterlist.png"),
                  width: 130,
                  height: 80,
                ),
                //Text(
                //  lessonOrSectionName, //lesson.titleTranslation, //"Hello",
                //  style: TextStyle(fontSize: 14.0, fontFamily: "Raleway"),
                //),
              //]
            //),

            onTap: () => launchLessonSection(context, 1, 0),
          ),
/*
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OpenHelper.getImageButton(context, lessonId, "assets/core/characterdrill.png", LessonSection.FullCharacterTree, false, 131, 81),
                OpenHelper.getImageButton(context, lessonId, "assets/core/characterlist.png", LessonSection.Characters, false, 131, 81),
              ],
            ),
            padding: EdgeInsets.all(20),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OpenHelper.getImageButton(context, lessonId, "assets/core/breakout.png", LessonSection.Decomposing, false, 131, 81),
                OpenHelper.getImageButton(context, lessonId, "assets/core/conversations.png", LessonSection.Conversation, false, 131, 81),
              ],
            ),
            padding: EdgeInsets.all(20),
          ),
          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  OpenHelper.getImageButton(context, lessonId, "assets/core/typing.png", LessonSection.Typing, false, 131, 80),
                  OpenHelper.getImageButton(context, lessonId, "assets/core/quiz.png", LessonSection.Quiz, false, 131,80),
                ],
            ),
            padding: EdgeInsets.all(20),
          ),
*/
        ]
      ),
    );
  }
}