import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hanzishu/ui/imagebutton.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/componentpainter.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/engine/statisticsmanager.dart';
import 'package:hanzishu/data/componentlist.dart';
import 'dart:async';

class ComponentPage extends StatefulWidget {
  final QuestionType questionType;
  //final int lessonId;
  bool isChars = true;

  ComponentPage({this.questionType});

  @override
  _ComponentPageState createState() => _ComponentPageState();
}

class _ComponentPageState extends State<ComponentPage> {
  QuestionType questionType;
  AnswerPosition answeredPosition;
  //int lessonId;
  AnswerType answerType;
  int currentIndex;
  double _progressValue;
  int totalQuestions;

  @override
  void initState() {
    super.initState();
    _progressValue = 0.0;

    //TODO
    //theStatisticsManager.initLessonQuizResults();
    theComponentManager.initValues();
    currentIndex = theComponentManager.getFirstIndex(widget.questionType); //TODO: lessonId

    //theStatisticsManager.initLessonQuizResults();

    totalQuestions = theComponentManager.getTotalQuestions(widget.questionType);
    theComponentManager.setCurrentType(questionType); //TODO: need to init every time.
    theComponentManager.initCurrentIndex();

    setState(() {
      answeredPosition = AnswerPosition.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    questionType = widget.questionType; //theComponentManager.getCurrentType();
    theComponentManager.setCurrentType(questionType);
    if (answeredPosition == AnswerPosition.continueNext ||
        answeredPosition == AnswerPosition.none) {
      // get values ready
  //TODO:    theComponentManager.getUpdatedValues(currentIndex);
      theComponentManager.getCurrentNoncharId();
      //currentCategory = theComponentManager.getCurrentCategory();
  //    currentType = theComponentManager.getCurrentType();

      //var lessonQuizResult = theStatisticsManager.getLessonQuizResult();
      _progressValue = currentIndex/totalQuestions;
    }

    if (questionType == QuestionType.none) {
      // Completed the quiz. Save the quiz results and go back to lesson page.
      //theStatisticsManager.saveLessonQuizAndStatisticsToStorage();
    }

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Memorize leading component"),
      ),
      body: Center
        (
        //child: Text("This is Lesson Page."),
        child: getComponentWizard(context /*, widget.lessonId*/),
      ),
    );
  }

  Widget getComponentWizard(BuildContext context) {
    return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
          ),
          Container( // x and progress bard
            child: LinearProgressIndicator(value: _progressValue), //getProgressBar(context),
            padding: EdgeInsets.all(10),
          ),
          Container(
            child: getQuestion(context),
            padding: EdgeInsets.all(10),
          ),
          Container(
            padding: EdgeInsets.all(10), //
          ),
          getAnswers(context),
          Container(
            child: getContinue(context),
            padding: EdgeInsets.all(20),
          ),
        ]
    );
  }

  Widget getAnswers(BuildContext context) {
    if (this.questionType == QuestionType.ComponentGroup) {
      return Container(
        child: getGroupAnswers(context),
        padding: EdgeInsets.all(20), //10
      );
    }
    else if(this.questionType == QuestionType.Component  || this.questionType == QuestionType.ComponentInGroup  ||this.questionType == QuestionType.ExpandedComponent) {
      return Container(
        child: getIndividualAnswers(context),
        padding: EdgeInsets.all(20),
      );
    }
  }

  /*
  Widget getOneIndividualAnswers(BuildContext context, int index) {
    if (this.questionType != QuestionType.LeadingComponent) {
      return null;
    }

    return Container(
      child: getIndividualAnswers(context, index),
      padding: EdgeInsets.all(5), //10
    );
  }
*/

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
    if (questionType == QuestionType.Component || questionType == QuestionType.ComponentInGroup) {
      return getZiContainer(/*AnswerPosition.center, */ false);
    }
    else if (questionType == QuestionType.ComponentGroup || questionType == QuestionType.ExpandedComponent) {
      return getQuestionImage();
    }
  }

  Widget getQuestionImage() {
    String imagePath;

    if (questionType == QuestionType.ComponentGroup) {
      imagePath = 'assets/' + theComponentGroupList[currentIndex].imageName;
    }
    else if (questionType == QuestionType.ExpandedComponent) {
      imagePath = 'assets/' + theExpandedComponentList[currentIndex].imageName;
    }

    return Container(
        alignment: Alignment.center,
        child: Image.asset(
            imagePath,
            width: 200,
            height: 200
        )
    );
  }

  Widget getGroupAnswers(BuildContext context) {
    return Column(
        children: <Widget>[
              Row(
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  Expanded(child: getText(AnswerPosition.groupPosition1)),
                  SizedBox(width: 20),
                  Expanded(child: getText(AnswerPosition.groupPosition2)),
                ],
              ),
            Row(
              textDirection: TextDirection.ltr,
              children: <Widget>[
                Expanded(child: getText(AnswerPosition.groupPosition3)),
                SizedBox(width: 20),
                Expanded(child: getText(AnswerPosition.groupPosition4)),
              ],
            ),
            Row(
              textDirection: TextDirection.ltr,
              children: <Widget>[
                Expanded(child: getText(AnswerPosition.groupPosition5)),
                SizedBox(width: 20),
                Expanded(child: getText(AnswerPosition.groupPosition6)),
              ],
            ),
        ]
    );
  }

  Widget getIndividualAnswers(BuildContext context) {
    return Column(
        children: <Widget>[
          Row(
              textDirection: TextDirection.ltr,
              //mainAxisSize: MainAxisSize.max,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(child: getText(AnswerPosition.individual15)),
                SizedBox(width: 5),
                Expanded(child: getText(AnswerPosition.individual14)),
                SizedBox(width: 5),
                Expanded(child: getText(AnswerPosition.individual13)),
                SizedBox(width: 5),
                Expanded(child: getText(AnswerPosition.individual12)),
                SizedBox(width: 5),
                Expanded(child: getText(AnswerPosition.individual11)),
                SizedBox(width: 10),
                Expanded(child: getText(AnswerPosition.individual21)),
                SizedBox(width: 5),
                Expanded(child: getText(AnswerPosition.individual22)),
                SizedBox(width: 5),
                Expanded(child: getText(AnswerPosition.individual23)),
                SizedBox(width: 5),
                Expanded(child: getText(AnswerPosition.individual24)),
                SizedBox(width: 5),
                Expanded(child: getText(AnswerPosition.individual25)),
              ]
          ),
        Row(
          children: <Widget>[
            SizedBox(height: 15),
          ]
        ),
        Row(
            textDirection: TextDirection.ltr,
            //mainAxisSize: MainAxisSize.max,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(child: getText(AnswerPosition.individual35)),
              SizedBox(width: 5),
              Expanded(child: getText(AnswerPosition.individual34)),
              SizedBox(width: 5),
              Expanded(child: getText(AnswerPosition.individual33)),
              SizedBox(width: 5),
              Expanded(child: getText(AnswerPosition.individual32)),
              SizedBox(width: 5),
              Expanded(child: getText(AnswerPosition.individual31)),
              SizedBox(width: 10),
              Expanded(child: getText(AnswerPosition.individual41)),
              SizedBox(width: 5),
              Expanded(child: getText(AnswerPosition.individual42)),
              SizedBox(width: 5),
              Expanded(child: getText(AnswerPosition.individual43)),
              SizedBox(width: 5),
              Expanded(child: getText(AnswerPosition.individual44)),
              SizedBox(width: 5),
              Expanded(child: getText(AnswerPosition.none)),
            ]
        ),
          Row(
              children: <Widget>[
                SizedBox(height: 15),
              ]
          ),
        Row(
            textDirection: TextDirection.ltr,
            //mainAxisSize: MainAxisSize.max,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(child: getText(AnswerPosition.none)),
              SizedBox(width: 5),
              Expanded(child: getText(AnswerPosition.individual54)),
              SizedBox(width: 5),
              Expanded(child: getText(AnswerPosition.individual53)),
              SizedBox(width: 5),
              Expanded(child: getText(AnswerPosition.individual52)),
              SizedBox(width: 5),
              Expanded(child: getText(AnswerPosition.individual51)),
              SizedBox(width: 10),
              Expanded(child: getText(AnswerPosition.individual61)),
              SizedBox(width: 5),
              Expanded(child: getText(AnswerPosition.individual62)),
              SizedBox(width: 5),
              Expanded(child: getText(AnswerPosition.none)),
              SizedBox(width: 5),
              Expanded(child: getText(AnswerPosition.none)),
              SizedBox(width: 5),
              Expanded(child: getText(AnswerPosition.none)),
            ]
        )
      ]
    );
  }

  void setPositionState(AnswerPosition position) {
    if (answeredPosition != position) {
      setState(() {
        answeredPosition = position;
      });
    }
  }


  int getCurrentNoncharId(/*AnswerPosition position*/) {
    return theComponentManager.getCurrentNoncharId();

    /*
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
    */

    //return noncharId;
  }

  String getAnswerDisplayValue(AnswerPosition position) {
    if (position == AnswerPosition.none) {
      return "";
    }

    var value;
    //var currentValues = theComponentManager.getCurrentValues();

    switch(position) {
      case AnswerPosition.center:
        {
          value = theComponentManager.getCurrentComponentValue(); //"好"; //currentValues[0];
        }
        break;
      case AnswerPosition.groupPosition1:
        {
          value = "Group 1";
        }
        break;
      case AnswerPosition.groupPosition2:
        {
          value = "Group 2";
        }
        break;
      case AnswerPosition.groupPosition3:
        {
          value = "Group 3";
        }
        break;
      case AnswerPosition.groupPosition4:
        {
          value = "Group 4";
        }
        break;
      case AnswerPosition.groupPosition5:
        {
          value = "Group 5";
        }
        break;
      case AnswerPosition.groupPosition6:
        {
          value = "Group 6";
        }
        break;
      case AnswerPosition.individual11:
        {
          value = "11";
        }
        break;
      case AnswerPosition.individual12:
        {
          value = "12";
        }
        break;
      case AnswerPosition.individual13:
        {
          value = "13";
        }
        break;
      case AnswerPosition.individual14:
        {
          value = "14";
        }
        break;
      case AnswerPosition.individual15:
        {
          value = "15";
        }
        break;
      case AnswerPosition.individual21:
        {
          value = "21";
        }
        break;
      case AnswerPosition.individual22:
        {
          value = "22";
        }
        break;
      case AnswerPosition.individual23:
        {
          value = "23";
        }
        break;
      case AnswerPosition.individual24:
        {
          value = "24";
        }
        break;
      case AnswerPosition.individual25:
        {
          value = "25";
        }
        break;
      case AnswerPosition.individual31:
        {
          value = "31";
        }
        break;
      case AnswerPosition.individual32:
        {
          value = "32";
        }
        break;
      case AnswerPosition.individual33:
        {
          value = "33";
        }
        break;
      case AnswerPosition.individual34:
        {
          value = "34";
        }
        break;
      case AnswerPosition.individual35:
        {
          value = "35";
        }
        break;
      case AnswerPosition.individual41:
        {
          value = "41";
        }
        break;
      case AnswerPosition.individual42:
        {
          value = "42";
        }
        break;
      case AnswerPosition.individual43:
        {
          value = "43";
        }
        break;
      case AnswerPosition.individual44:
        {
          value = "44";
        }
        break;
      case AnswerPosition.individual51:
        {
          value = "51";
        }
        break;
      case AnswerPosition.individual52:
        {
          value = "52";
        }
        break;
      case AnswerPosition.individual53:
        {
          value = "53";
        }
        break;
      case AnswerPosition.individual54:
        {
          value = "54";
        }
        break;
      case AnswerPosition.individual61:
        {
          value = "61";
        }
        break;
      case AnswerPosition.individual62:
        {
          value = "62";
        }
        break;
      default:
        value = '';
    }

    return value;
  }

  Widget getText(AnswerPosition position) {
    var answerDisplayValue = getAnswerDisplayValue(position);
    var fontSize = xYLength(20.0); // 30.0
    var currentType = theComponentManager.getCurrentType();

    var backgroundColor = Colors.white;  // make it a non-material color first
    backgroundColor = Colors.blueAccent;
    if (theComponentManager.isGroupOrIndividualAnswerType(answeredPosition) ) {
      //backgroundColor = Colors.blueAccent;
      var answerType = theComponentManager.getAnswerType(answeredPosition);
      if (position == theComponentManager.getCorrectAnswerPosition()) {
        backgroundColor = Colors.greenAccent;
      }
      else if (position == answeredPosition) {
        backgroundColor = Colors.redAccent;
      }
    }

    if (position == AnswerPosition.none) {
      backgroundColor = Colors.white;
    }

    if (position == AnswerPosition.center) {
      backgroundColor = Colors.white;
      fontSize = xYLength(100.0);
    }

    var textColor = Colors.white;

    if (position == AnswerPosition.center) {
      textColor = Colors.cyan; //Colors.blueAccent;
    }

    return Container(
      child: FlatButton(
        child: Text(answerDisplayValue, style: TextStyle(fontSize: fontSize),),
        color: backgroundColor, //color,
        textColor: textColor, //Colors.white,
        onPressed: () {
          setPositionState(position);
        },
      ),
      //padding: EdgeInsets.all(20),
    );
  }

  // is only used in question in InputZi, therefore only used in center position.
  Widget getZiContainer(/*AnswerPosition position,*/ bool withNonCharFrame) {
    var size = xYLength(55.0); //35
    //if (position == AnswerPosition.center) {
      size = xYLength(120.0);
    //}

    var backgroundColor = Colors.white;  // make it a non-material color first
    /*
    var backgroundColor = Colors.blueAccent;
    if (theComponentManager.isGroupOrIndividualAnswerType(answerPosition) ) {
      //backgroundColor = Colors.blueAccent;
      var answerType = theComponentManager.getAnswerType(answerPosition);
      if (position == theComponentManager.getCorrectAnswerPosition(answerType)) {
        backgroundColor = Colors.greenAccent;
      }
      else if (position == answerPosition) {
        backgroundColor = Colors.redAccent;
      }
    }
    */

    var lineColor = Colors.grey; //Colors.amber;  //TODO: want to be white like other text, but white is not a MaterialColor
    /*
    if (position == AnswerPosition.center) {
      lineColor = Colors.cyan;
    }
    */

    if (!theComponentManager.isCurrentComponentChar()) {// nonchar case
      int noncharCompId = theComponentManager.getCurrentComponentId();
      return InkWell(
        /*
        onTap: () {
          theStatisticsManager.trackTimeAndTap();
          setPositionState(position);
          //theComponentManager.setAnswered(true);
        },
        */
        child: Container(
          height: size /*250.0*/,
          width: size /*180.0*/,
          // child: FlatButton(
          child: CustomPaint(
            foregroundPainter: ComponentPainter(
              lineColor: lineColor, //lineColor, //Colors.amber,
              completeColor: backgroundColor, //color, //Colors.blueAccent,
              centerId: noncharCompId,
              withNonCharFrame: withNonCharFrame,//*centerZiId*/,
              //width: 150.0 /*screenWidth*/
            ),
          ),
        ),
      );
    }
    else {
      return getText(AnswerPosition.center);
    }
  }


  Widget getContinue(BuildContext context) {
    if (theComponentManager.isGroupOrIndividualAnswerType(answeredPosition) ) {
      var result; // = "Correct! ";
      //var answerType = theComponentManager.getAnswerType(answeredPosition);
      if (answeredPosition != theComponentManager.getCorrectAnswerPosition()) {
        //TODO: theStatisticsManager.incrementLessonQuizResult(false);
        result = "Incorrect. ";
      }
      else {
        //TODO: theStatisticsManager.incrementLessonQuizResult(true);
        result = "Correct! ";
      }

      result += "Continue";

      //_updateProgress();

      return Container(
        child: FlatButton(
          child: Text(result, style: TextStyle(fontSize: xYLength(25.0)),),
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              setPositionState(AnswerPosition.continueNext);

              //if (answerPosition == AnswerPosition.continueNext) {
              // prepare for next one
              // Could be done in Build(), but Build won't allow showCompletedDialog() there.
              currentIndex = theComponentManager.getNextIndex();
              theComponentManager.resetCorrectAnswerPosition();
              //}
              //if (theComponentManager.getCurrentType() == QuestionType.none) {
              if (currentIndex == -1) {
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
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // out this dialog
        Navigator.of(context).pop(); // to the lesson page
      },
    );

    //var lessonQuizResult = theStatisticsManager.getLessonQuizResult();
    var correctPercent = 75; //(lessonQuizResult.cor * 100) / lessonQuizResult.answ;
    var corStr = correctPercent.toStringAsFixed(1);

    String title;
    String content;

    if (correctPercent >= 70.0) {
      title = "Congratulation!";
      content = "You have passed this quiz with a score of " + corStr + "!";
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
}
