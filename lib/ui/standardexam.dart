
import 'package:flutter/material.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/ui/quizpainter.dart';
import 'package:hanzishu/engine/quizmanager.dart';
import 'package:hanzishu/engine/standardexammanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/texttospeech.dart';

class StandardExam extends StatefulWidget {
  bool isChars = true;

  DrillCategory drillCategory;
  final int subItemId;
  QuizCategory quizCategory;

  StandardExam({this.drillCategory, this.subItemId, this.quizCategory});
  //StandardExam({this.quizTextbook, this.lessonId, this.wordsStudy, this.fromPaintSound});

  @override
  _StandardExamState createState() => _StandardExamState();
}

class _StandardExamState extends State<StandardExam> {
  // No need to show drillCategory and subItem
  double screenWidth;

  AnswerPosition answerPosition;
  QuizTextbook quizTextbook;
  int lessonId;
  String wordsStudy;
  bool fromPaintSound;
  int index;
  double _progressValue;
  int totalMeaningAndSoundQuestions;

  getSizeRatio() {
    var defaultFontSize = screenWidth / 16.0;
    return defaultFontSize / 25.0; // ratio over original hard coded value
  }

  @override
  void initState() {
    super.initState();
    _progressValue = 0.0;

    theStandardExamManager.initValues(widget.drillCategory, widget.subItemId, widget.quizCategory);

    totalMeaningAndSoundQuestions = theStandardExamManager.getTotalQuestions();

    theStatisticsManager.initLessonQuizResults();

    setState(() {
      answerPosition = AnswerPosition.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidth(context);
    // Only support this type for now.
    QuizType currentType = QuizType.chars; //theQuizManager.getCurrentType();

    if (answerPosition == AnswerPosition.continueNext ||
        answerPosition == AnswerPosition.none) {
      // tell manager to get values ready
      theStandardExamManager.getUpdatedValues();

      var lessonQuizResult = theStatisticsManager.getLessonQuizResult();
      _progressValue = lessonQuizResult.answ/totalMeaningAndSoundQuestions;
    }

    if ( index == -1 /*currentType == QuizType.none*/) {
      // Completed the quiz. Save the quiz results and go back to lesson page.
      theStatisticsManager.saveLessonQuizAndStatisticsToStorage();
      // Navigator.of(context).pop(); Note: let showCompletedDialog() to pop back together.
    }

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(getString(6)/*"Quiz")*/),
      ),
      body: Center
        (
        //child: Text("This is Lesson Page."),
        child: getQuizWizard(context /*, widget.lessonId*/),
      ),
    );
  }

  Widget getQuizWizard(BuildContext context) {
    return Column(
        children: <Widget>[
          //Container(
          //  padding: EdgeInsets.all(5),
          //),
          Container( // x and progress bard
            child: LinearProgressIndicator(value: _progressValue), //getProgressBar(context),
            padding: EdgeInsets.only(top: 10 * getSizeRatio(), left: 10 * getSizeRatio(), right: 10 * getSizeRatio()), //25
          ),
          Container(
            child: getQuestion(context),
            //padding: EdgeInsets.all(20),
          ),
          Container(
            padding: EdgeInsets.all(18 * getSizeRatio()), //
          ),
          Container(
            child: getAnswers(context),
            padding: EdgeInsets.all(18 * getSizeRatio()), //40
          ),
          Container(
            padding: EdgeInsets.all(18 * getSizeRatio()), //
          ),
          Container(
            child: getContinue(context),
            //        padding: EdgeInsets.all(10),
          ),
        ]
    );
  }

  Widget getProgressBar(BuildContext context) {
    return Row(
        children: <Widget>[
          Container(
            // text X
          ),
          Container(
            // progress widget
          )
        ]
    );
  }

  Widget getQuestion(BuildContext context) {
    var currentValues = theStandardExamManager.getCurrentValues();

    return getZiContainer(AnswerPosition.center);
  }

  Widget getAnswers(BuildContext context) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              getZiContainer(AnswerPosition.positionA),
              SizedBox(height: 5.0 * getSizeRatio()),
              getZiContainer(AnswerPosition.positionB),
              SizedBox(height: 5.0 * getSizeRatio()),
              getZiContainer(AnswerPosition.positionC),
            ]
        );
  }

  setPositionState(AnswerPosition position) {
    if (answerPosition != position) {
      setState(() {
        answerPosition = position;
      });
    }
  }

  String getValue(AnswerPosition position) {
    var value;
    var currentValues = theStandardExamManager.getCurrentValues();

    switch(position) {
      case AnswerPosition.center:
        {
          value = currentValues[0];
        }
        break;
      case AnswerPosition.positionA:
        {
          value = currentValues[1];
        }
        break;
      case AnswerPosition.positionB:
        {
          value = currentValues[2];
        }
        break;
      case AnswerPosition.positionC:
        {
          value = currentValues[3];
        }
        break;
      default:
        value = '';
    }

    return value;
  }

  Widget getText(AnswerPosition position) {
    var value = getValue(position);
    var fontSize = 30.0 * getSizeRatio(); // 35.0
    var currentType = theQuizManager.getCurrentType();

    if (position == AnswerPosition.center) {
      if (currentType == QuizType.nonChars || currentType == QuizType.chars || currentType == QuizType.basicChars) {
        fontSize = 120.0 * getSizeRatio(); //60.0;
      }
      else {
        fontSize = 50.0 * getSizeRatio();
      }
    }

    var backgroundColor = Colors.white;  // make it a non-material color first
    backgroundColor = Colors.blueAccent;
    if (answerPosition == AnswerPosition.positionA || answerPosition == AnswerPosition.positionB || answerPosition == AnswerPosition.positionC) {
      //backgroundColor = Colors.blueAccent;
      if (position == theStandardExamManager.getCorrectAnswerPosition()) {
        backgroundColor = Colors.greenAccent;
      }
      else if (position == answerPosition) {
        backgroundColor = Colors.redAccent;
      }
    }

    if (position == AnswerPosition.center) {
      backgroundColor = Colors.white;
    }

    var textColor = Colors.white;
    if (position == AnswerPosition.center) {
      textColor = Colors.cyan; //Colors.blueAccent;
    }

    return Container(
      child: FlatButton(
        child: Text(value, style: TextStyle(fontSize: fontSize),),
        color: backgroundColor, //color,
        textColor: textColor, //Colors.white,
        onPressed: () {
          setPositionState(position);
        },
      ),
      //padding: EdgeInsets.all(20),
    );
  }

  Widget getZiContainer(AnswerPosition position) {
    return getText(position);
  }

  Widget getContinue(BuildContext context) {
    if (answerPosition == AnswerPosition.positionA || answerPosition == AnswerPosition.positionB || answerPosition == AnswerPosition.positionC) {
      var result; // = "Correct! ";
      if (answerPosition != theStandardExamManager.getCorrectAnswerPosition()) {
        theStatisticsManager.incrementLessonQuizResult(false);
        result = getString(283)/*"Incorrect. "*/;
      }
      else {
        theStatisticsManager.incrementLessonQuizResult(true);
        result = getString(284)/*"Correct! "*/;
      }

      result += getString(285)/*"Continue"*/;

      //_updateProgress();

      return Container(
        child: FlatButton(
          child: Text(result, style: TextStyle(fontSize: 25.0 * getSizeRatio(),)),
          color: Colors.cyan,    //blueAccent,
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              setPositionState(AnswerPosition.continueNext);

              index = theStandardExamManager.getNext();
              //}
              if (index == -1) {
                showCompletedDialog(context);
              }
            });
          },
        ),
      );
    }
  }

  showCompletedDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(getString(286)/*"Ok"*/),
      onPressed: () {
        theIsBackArrowExit = false;
        Navigator.of(context).pop(); // out this dialog
        Navigator.of(context).pop(); // to the lesson page
      },
    );

    var lessonQuizResult = theStatisticsManager.getLessonQuizResult();
    var correctPercent = (lessonQuizResult.cor * 100) / lessonQuizResult.answ;
    var corStr = correctPercent.toStringAsFixed(1);

    String title;
    String content;

    if (correctPercent >= 70.0 * getSizeRatio()) {
      title = "Congratulation!";
      content = "You have passed this quiz with a score of " + corStr + "!";

        updateCompleteStatus();
        theHasNewlyCompletedLesson = true;
    }
    else {
      title = "Good effort!";
      content = "You have achieved a score of " + corStr + ". You can come back later to reach 70.";
    }

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  updateCompleteStatus() {
    //var wasCompleted = theStorageHandler.hasLessonCompleted(lessonId);
    //if (!wasCompleted) {
    //  theStorageHandler.updateOneLessonStatus(lessonId, true);
    //  theStorageHandler.SaveToFile();
    //}
  }
}
