import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hanzishu/ui/imagebutton.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/quizpainter.dart';
import 'package:hanzishu/engine/quizmanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/texttospeech.dart';

class QuizPage extends StatefulWidget {
  final int lessonId;
  bool isChars = true;

  QuizPage({this.lessonId});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  AnswerPosition answerPosition;
  int lessonId;

  //QuizCategory currentCategory;
  //QuizType currentType;
  //List<String> currentValues;
  //List<int> currentValuesNonCharIds;
  int index;
  //bool soundIconPressed;

  //_openTreePage(BuildContext context) {
  //_QuizPageState(BuildContext context) {
  //  Navigator.of(context).push(
  //      MaterialPageRoute(builder: (context) => QuizPage()));
  //}

  //_QuizPageState(int lessonId) {
  //  this.lessonId = lessonId;
  //}

  @override
  void initState() {
    super.initState();

    //TODO
    //theStatisticsManager.initLessonQuizResults();
    theQuizManager.initValues();
    index = theQuizManager.getFirstIndex(widget.lessonId); //TODO: lessonId

    setState(() {
      answerPosition = AnswerPosition.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (answerPosition == AnswerPosition.continueNext) {
      index = theQuizManager.getNextIndexForCurrentType();
    }

    QuizType currentType = theQuizManager.getCurrentType();
    if (answerPosition == AnswerPosition.continueNext ||
        answerPosition == AnswerPosition.none) {
        // get values ready
        theQuizManager.getUpdatedValues(
          index, theQuizManager.getCurrentCategory() == QuizCategory.meaning);
        theQuizManager.getCurrentValuesNonCharIds();
      //currentCategory = theQuizManager.getCurrentCategory();
      currentType = theQuizManager.getCurrentType();
    }

    if (currentType == QuizType.none) {
      Navigator.of(context).pop();
      //OpenHelper.openLessonPage(context, 1/*lessonId*/);
    }

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Quiz Page"),
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
          Container(
            //       padding: EdgeInsets.all(30),
          ),
          Container( // x and progress bard
            child: getProgressBar(context),
            padding: EdgeInsets.all(30),
          ),
          Container(
            child: getQuestion(context),
            //padding: EdgeInsets.all(20),
          ),
          Container(
            padding: EdgeInsets.all(30),
          ),
          Container(
            child: getAnswers(context),
            padding: EdgeInsets.all(10),
          ),
          Container(
            child: getContinue(context),
            padding: EdgeInsets.all(20),
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
    if (theQuizManager.getCurrentCategory() == QuizCategory.meaning) { // short button
      return getZiContainer(AnswerPosition.center);
    }
    else {
      var currentValues = theQuizManager.getCurrentValues();

      return Container(
        height: 180.0,
        child: IconButton(
            icon: Icon(
                Icons.volume_up,
                size: 150.0
            ),
            color: Colors.green,
            onPressed: () {
              TextToSpeech.speak(currentValues[0]);
              setState(() {
                setPositionState(AnswerPosition.soundIcon);
              });
            },
        )
      );
    }
  }

  Widget getAnswers(BuildContext context) {
    var currentCategory = theQuizManager.getCurrentCategory();
    var currentType = theQuizManager.getCurrentType();
    if(currentCategory == QuizCategory.meaning || (currentCategory == QuizCategory.sound &&
        (answerPosition == AnswerPosition.soundIcon || answerPosition == AnswerPosition.positionA || answerPosition == AnswerPosition.positionB ||
        answerPosition == AnswerPosition.positionC))) {
      if (currentCategory ==
          QuizCategory.meaning || currentType == QuizType.phrases ||
          currentType == QuizType.conversations) { // phrases and sentences
        return Column(
            children: <Widget>[
              getText(AnswerPosition.positionA),
              getText(AnswerPosition.positionB),
              getText(AnswerPosition.positionC),
            ]
        );
      }
      else {
        // Zi only
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              getZiContainer(AnswerPosition.positionA),
              getZiContainer(AnswerPosition.positionB),
              getZiContainer(AnswerPosition.positionC),
            ]
        );
      }
    }
  }

  setPositionState(AnswerPosition position) {
    if (answerPosition != position) {
      setState(() {
        answerPosition = position;
      });
    }
  }

  int getNoncharId(AnswerPosition position) {
    int noncharId;
    var currentValuesNonCharIds = theQuizManager.getCurrentValuesNonCharIds();

    switch(position) {
      case AnswerPosition.center: {
        noncharId = currentValuesNonCharIds[0];
      }
      break;
      case AnswerPosition.positionA:
        {
          noncharId = currentValuesNonCharIds[1];
        }
        break;
      case AnswerPosition.positionB:
        {
          noncharId = currentValuesNonCharIds[2];
        }
        break;
      case AnswerPosition.positionC:
        {
          noncharId = currentValuesNonCharIds[3];
        }
        break;
      default:
        noncharId = 0;
    }

    return noncharId;
  }

  String getValue(AnswerPosition position) {
    var value;
    var currentValues = theQuizManager.getCurrentValues();

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
    var fontSize = 30.0;
    var currentType = theQuizManager.getCurrentType();
    if (position == AnswerPosition.center &&
        (currentType == QuizType.nonChars || currentType == QuizType.chars || currentType == QuizType.basicChars)) {
      fontSize = 60.0;
    }

    var color = Colors.blueAccent;
    if (answerPosition == AnswerPosition.positionA || answerPosition == AnswerPosition.positionB || answerPosition == AnswerPosition.positionC) {
      if (position == theQuizManager.getCorrectAnswerPosition()) {
        color = Colors.greenAccent;
      }
      else if (position == answerPosition) {
        color = Colors.redAccent;
      }
    }

    return Container(
      child: FlatButton(
        child: Text(value, style: TextStyle(fontSize: fontSize),),
        color: color, //Colors.blueAccent,
        textColor: Colors.white,
        onPressed: () {
          setPositionState(position);
        },
      ),
      //padding: EdgeInsets.all(20),
    );
  }

  Widget getZiContainer(AnswerPosition position) {
    var size = 80.0;
    if (position == AnswerPosition.center) {
      size = 150.0;
    }

    var noncharId = getNoncharId(position);

    var color = Colors.blueAccent;
    if (answerPosition != AnswerPosition.none) {
      if (position == theQuizManager.getCorrectAnswerPosition()) {
        color = Colors.greenAccent;
      }
      else if (position == answerPosition) {
        color = Colors.redAccent;
      }
    }

    if (noncharId != 0) {// nonchar case
      return InkWell(
        onTap: () {
          setPositionState(position);
          //theQuizManager.setAnswered(true);
          },
        child: Container(
          height: size /*250.0*/,
          width: size /*180.0*/,
          // child: FlatButton(
          child: CustomPaint(
            foregroundPainter: QuizPainter(
              lineColor: Colors.amber,
              completeColor: color, //Colors.blueAccent,
              centerId: noncharId //*centerZiId*/,
              //width: 150.0 /*screenWidth*/
            ),
          ),
        ),
      );
    }
    else {
      return getText(position);
    }
  }


  Widget getContinue(BuildContext context) {
    if (answerPosition == AnswerPosition.positionA || answerPosition == AnswerPosition.positionB || answerPosition == AnswerPosition.positionC) {
      var result = "Correct! ";
      if (answerPosition != theQuizManager.getCorrectAnswerPosition()) {
        result = "Incorrect. ";
      }

      result += "Continue";

      return Container(
          child: FlatButton(
            child: Text(result, style: TextStyle(fontSize: 20.0),),
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                  setPositionState(AnswerPosition.continueNext);
              });
            },
          ),
      );
    }
  }
}