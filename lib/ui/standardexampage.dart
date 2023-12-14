
import 'package:flutter/material.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/ui/quizpainter.dart';
import 'package:hanzishu/engine/quizmanager.dart';
import 'package:hanzishu/engine/standardexammanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/texttospeech.dart';

class StandardExamPage extends StatefulWidget {
  bool isChars = true;

  DrillCategory drillCategory;
  final int subItemId;
  QuizCategory quizCategory;

  StandardExamPage({this.drillCategory, this.subItemId, this.quizCategory});
  //StandardExamPage({this.quizTextbook, this.lessonId, this.wordsStudy, this.fromPaintSound});

  @override
  _StandardExamPageState createState() => _StandardExamPageState();
}

class _StandardExamPageState extends State<StandardExamPage> {
  // No need to show drillCategory and subItem
  double screenWidth;
  QuizCategory quizCategory;
  int currentIndex;

  //bool isSoundAnswered;

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
    quizCategory = widget.quizCategory;
    //isSoundAnswered = false;

    theStandardExamManager.initValues(widget.drillCategory, widget.subItemId, widget.quizCategory);

    totalMeaningAndSoundQuestions = theStandardExamManager.getTotalQuestions();

    theStatisticsManager.initLessonQuizResults();

    setState(() {
      index = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    // Only support this type for now.
    QuizType currentType = QuizType.chars; //theQuizManager.getCurrentType();

      // tell manager to get values ready
      theStandardExamManager.getUpdatedValues();

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

    return getText(AnswerPosition.center);
  }

  Widget getAnswers(BuildContext context) {
    /*
    if (quizCategory == QuizCategory.sound) {
      String strValue = getValue(AnswerPosition.positionA).char;
      strValue += getValue(AnswerPosition.positionB).char;
      strValue += getValue(AnswerPosition.positionC).char;
      TextToSpeech.speakWithRate("zh-CN", strValue, 0.1);
    }
    */

    if (quizCategory ==
        QuizCategory.meaning) { // phrases and sentences
      return IntrinsicWidth(
        child: Column(
          //textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              getText(AnswerPosition.positionA),
              SizedBox(height: 5.0 * getSizeRatio()),
              getText(AnswerPosition.positionB),
              SizedBox(height: 5.0 * getSizeRatio()),
              getText(AnswerPosition.positionC),
            ]
        )
      );
    }
    else {
      return Column(
        //textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                getSoundImage(AnswerPosition.positionA),
                SizedBox(height: 5.0 * getSizeRatio()),
                getSoundImage(AnswerPosition.positionB),
                SizedBox(height: 5.0 * getSizeRatio()),
                getSoundImage(AnswerPosition.positionC),
              ]
          ),
          SizedBox(height: 10.0 * getSizeRatio()),
          getSoundABCText(),
        ]
      );
    }
  }

  Widget getSoundABCText() {
    //if (isSoundAnswered) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            getText(AnswerPosition.positionA),
            SizedBox(height: 5.0 * getSizeRatio()),
            getText(AnswerPosition.positionB),
            SizedBox(height: 5.0 * getSizeRatio()),
            getText(AnswerPosition.positionC),
          ]
      );
    //}
    //else {
    //  return SizedBox(width: 0, height: 0);
    //}
  }

  SearchingZi getValue(AnswerPosition position) {
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
        value = null;
    }

    return value;
  }

  Widget getText(AnswerPosition position) {
    var value = getValue(position);
    var strValue = "";
    var fontSize = 30.0 * getSizeRatio(); // 35.0
    var currentType = theQuizManager.getCurrentType();

    if (position == AnswerPosition.center) {
      strValue = value.char;
      if (currentType == QuizType.nonChars || currentType == QuizType.chars || currentType == QuizType.basicChars) {
        fontSize = 120.0 * getSizeRatio(); //60.0;
      }
      else {
        fontSize = 50.0 * getSizeRatio();
      }
    }

    var backgroundColor = Colors.white;  // make it a non-material color first
    backgroundColor = Colors.blueAccent;
    if (position == AnswerPosition.positionA || position == AnswerPosition.positionB || position == AnswerPosition.positionC) {
      if (quizCategory == QuizCategory.meaning) {
        strValue = value.meaning;
      }
      else {
        //strValue = value.char;
        if (position == AnswerPosition.positionA) {
          strValue = "A";
        }
        else if (position == AnswerPosition.positionB) {
          strValue = "B";
        }
        else if (position == AnswerPosition.positionC) {
          strValue = "C";
        }
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
        child: Text(strValue, style: TextStyle(fontSize: fontSize),),
        color: backgroundColor, //color,
        textColor: textColor, //Colors.white,
        onPressed: () {
          if (position != AnswerPosition.center) {
            //setPositionState(position);
            answerPosition = position;

            //if (answerPosition == AnswerPosition.positionA || answerPosition == AnswerPosition.positionB || answerPosition == AnswerPosition.positionC) {
            if (answerPosition !=
                theStandardExamManager.getCorrectAnswerPosition()) {
              theStatisticsManager.incrementLessonQuizResult(false);
            }
            else {
              theStatisticsManager.incrementLessonQuizResult(true);
            }
            //}

            //setPositionState(AnswerPosition.continueNext);

            //theStandardExamManager.getUpdatedValues();
            var lessonQuizResult = theStatisticsManager.getLessonQuizResult();
            _progressValue =
                lessonQuizResult.answ / totalMeaningAndSoundQuestions;

            //isSoundAnswered = false;
            setState(() {
              index = theStandardExamManager.getNext();
            });

            if (index == -1) {
              //  theStorageHandler.updateOneLessonStatus(lessonId, true);
              //  theStorageHandler.SaveToFile();
              //theStatisticsManager.saveLessonQuizAndStatisticsToStorage();
              showCompletedDialog(context);
            }
          }
        },
      ),
      //padding: EdgeInsets.all(20),
    );
  }

  Widget getSoundImage(AnswerPosition position) {
    var value = getValue(position);

    return Container(
        height: 50.0 * getSizeRatio(), //180
        width: 50.0 * getSizeRatio(),
        child: IconButton(
          icon: Icon(
            Icons.volume_up,
            size: 50.0 * getSizeRatio(),   // 150
          ),
          color: Colors.cyan, //Colors.green,
          onPressed: () {
            TextToSpeech.speak("zh-CN", value.char);

            //setState(() {
              //isSoundAnswered = true;
            //});
          },
        )
    );
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

      //updateCompleteStatus();
      //theHasNewlyCompletedLesson = true;
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

  /*
  updateCompleteStatus() {
    //var wasCompleted = theStorageHandler.hasLessonCompleted(lessonId);
    //if (!wasCompleted) {
    //  theStorageHandler.updateOneLessonStatus(lessonId, true);
    //  theStorageHandler.SaveToFile();
    //}
  }
  */
}
