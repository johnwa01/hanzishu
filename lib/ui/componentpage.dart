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
    if (currentIndex < 0) {
      return Container(width: 0.0, height: 0.0);
    }

    // Need to do this every time
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
        title: Text("Memorize lead components"),
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
          //Container(
          //  padding: EdgeInsets.all(10), //
          //),
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
      if (theComponentManager.isHeaderOfGroups()) {
        // just return an empty Widget
        //return Container(
        //  padding: EdgeInsets.all(40), //10
        //);
        return getHeaderOfGroups();
      }
      else {
        return Container(
          child: getGroupAnswers(context),
          padding: EdgeInsets.all(20), //10
        );
      }
    }
    else if(this.questionType == QuestionType.Component  || this.questionType == QuestionType.ComponentInGroup || this.questionType == QuestionType.ComponentGroup || this.questionType == QuestionType.ExpandedComponent) {
      if (this.questionType == QuestionType.ComponentInGroup && theComponentManager.isHeaderOfComponentInGroup()) {
        if (currentIndex == 0) {
          // only for the first time
          return getHeaderOfComponentInGroup();
        }
        else {
          // just return an empty Widget
          return Container(
            padding: EdgeInsets.all(40), //10
          );
        }
      }
      else if (this.questionType == QuestionType.Component && theComponentManager.isHeaderOfRandomComponents()) {
        // just return an empty Widget
        return Container(
          padding: EdgeInsets.all(40), //10
        );
      }
      //else if (this.questionType == QuestionType.ExpandedComponent && theComponentManager.isHeaderOfExpandedComponents()) {
        // just return an empty Widget
      //  return Container(
      //    padding: EdgeInsets.all(40), //10
      //  );
      //}
      else {
        return Container(
          child: getIndividualAnswers(context),
          padding: EdgeInsets.all(20),
        );
      }
    }
  }

  /*
  Widget getHeaderOfExpandedComponents() {
    return Column(
        children: <Widget>[
          Row(
              children: <Widget>[
                SizedBox(height: 40),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(width: 20),
                Flexible (
                  child: Text(
                      'Each lead component has some expanded components associated to it. Those expanded components look more or less similar to their corresponding lead component and share the same keyboard key. It is important to get more and more familiar with them over the time of actual typing.',
                      style: TextStyle(fontSize: 20)
                  ),
                )
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 40),
              ]
          ),
        ]
    );
  }
*/
  
  Widget getHeaderOfGroups() {
    return Column(
        children: <Widget>[
          Row(
              children: <Widget>[
                SizedBox(height: 40),
              ]
          ),
          Row(
            children: <Widget>[
              SizedBox(width: 20),
              Flexible (
                child: Text(
                  'Note: The lead components are divided into six groups and mapped to the left side and right side of the keyboard.',
                  style: TextStyle(fontSize: 18)
                ),
              )
            ]
          ),
          Row(
            children: <Widget>[
              SizedBox(height: 40),
            ]
          ),
        ]
    );
  }

  Widget getHeaderOfComponentInGroup() {
    return Column(
        children: <Widget>[
          Row(
              children: <Widget>[
                SizedBox(height: 40),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(width: 20),
                Flexible (
                  child: Text(
                    'Note: A Component Number contains two digits. The first digit is the Group Number, and the second digit is the Internal Number within the group.',
                    style: TextStyle(fontSize: 20)
                  ),
                )
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 40),
              ]
          ),
        ]
    );
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
    if (questionType == QuestionType.Component) {
      //if (theComponentManager.isHeaderOfRandomComponents()) {
        return getQuestionImage();
      //}
      //else {
      //  return getZiContainer(/*AnswerPosition.center, */ false);
      //}
    }  // TODO: combine with the above
    else if (questionType == QuestionType.ComponentInGroup) {
      //if (theComponentManager.isHeaderOfComponentInGroup()) {
        return getQuestionImage();
      //}
      //else {
      //  return getZiContainer(/*AnswerPosition.center, */ false);
      //}
    }
    else if (questionType == QuestionType.ComponentGroup) {
      return getQuestionImage();
    }
    else if (questionType == QuestionType.ExpandedComponent) {
      //if(theComponentManager.isHeaderOfExpandedComponents()) {
      //  return getHeaderOfExpandedComponents();
      //}
      //else {
        return getQuestionImage();
      //}
    }
  }

  Widget getQuestionImage() {
    String imagePath;
    double imageWidth = 400.0;
    double imageHeight = 150.0;

    if (questionType == QuestionType.ComponentGroup) {
      var index = theComponentGroupListInRealExercise[currentIndex];
      imagePath = 'assets/typing/' + theComponentGroupList[index].imageName;
      imageHeight = 200.0;
    }
    else if (questionType == QuestionType.ExpandedComponent) {
      imagePath = 'assets/typing/' + theExpandedComponentList[currentIndex].imageName;
      imageWidth = 180.0;
      imageHeight = 160.0;
    }
    else if (questionType == QuestionType.ComponentInGroup) {
      var groupNumberOfcomponentInGroup = theComponentInGroupList[currentIndex].groupNumber;
      var imageName;
      if (theComponentManager.isHeaderOfComponentInGroup()) {
        imageName = theComponentGroupWithIdList[groupNumberOfcomponentInGroup - 1].imageName;
      }
      else {
        var indexOfComponentInGroup = theComponentInGroupList[currentIndex].indexInGroup;
        var component = theComponentManager.getComponentByGroupAndIndex(groupNumberOfcomponentInGroup, indexOfComponentInGroup);
        imageName = component.image;
      }
      imagePath = 'assets/typing/' + imageName;
    }
    else if (questionType == QuestionType.Component) { // for the header only
      var imageName;
      if (theComponentManager.isHeaderOfRandomComponents()) {
         imageName = 'GG6.png';
         imageHeight = 250.0;
      }
      else {
        var componentInGroup = theRandomComponentList[currentIndex];
        var component = theComponentManager.getComponentByGroupAndIndex(componentInGroup.groupNumber, componentInGroup.indexInGroup);
        imageName = component.image;
      }
      imagePath = 'assets/typing/' + imageName;
    }

    return Container(
        alignment: Alignment.center,
        child: Image.asset(
            imagePath,
            width: imageWidth,
            height: imageHeight
        )
    );
  }

  Widget getGroupAnswers(BuildContext context) {
    return Column(
        children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Which group is it?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
              ]
            ),
            Row(
              children: <Widget>[
                SizedBox(height: 20),
              ]
            ),
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
    String question = 'Which is its ID?';
    double size = 20.0;

    if (questionType == QuestionType.ExpandedComponent) {
      var hint = theExpandedComponentList[currentIndex].hint;
      question = "Guess their Lead Component & choose its Component Number. (Hint: " + hint + ")";
      size = 18.0;

      if (theComponentManager.isHeaderOfExpandedComponents()) {
        return Flexible (
          child: Text(
              'Note: Each Lead Component (in red) has some Expanded Components associated to it. Those Expanded Components look more or less similar to their corresponding Lead Component and share the same keyboard key. It is important to get more and more familiar with them over the time of actual typing.',
              style: TextStyle(fontSize: size)
          ),
        );
      }
      else {

      }
    }

    return Column(
        children: <Widget>[
          Row(
              children: <Widget>[
                Flexible (
                  child: Text(
                    question,
                    style: TextStyle(fontSize: size, fontWeight: FontWeight.bold)
                  ),
                ),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 20),
              ]
          ),
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

  Widget getText(AnswerPosition position) {
    var answerDisplayValue = theComponentManager.getAnswerDisplayValue(position);
    var fontSize = xYLength(20.0); // 30.0
    var currentType = theComponentManager.getCurrentType();

    var backgroundColor = Colors.white;  // make it a non-material color first
    backgroundColor = Colors.blueAccent;

    if (theComponentManager.isGroupOrIndividualAnswerType(answeredPosition) ) {
      //backgroundColor = Colors.blueAccent;
      //var answerType = theComponentManager.getAnswerType(answeredPosition);
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

    // actually no effect if no pressed action since the background will be white in that case.
    bool isPositionAtRightGroup = theComponentManager.isPositionAtRightGroup(position);
    if (position != AnswerPosition.center && position != AnswerPosition.none && !isPositionAtRightGroup) {
      backgroundColor = Colors.grey;
    }

    var textColor = Colors.white;

    if (position == AnswerPosition.center) {
      textColor = Colors.cyan; //Colors.blueAccent;
    }

    //if (isPositionEnabled) {
      return Container(
        child: FlatButton(
          child: Text(
            answerDisplayValue, style: TextStyle(fontSize: fontSize),),
          color: backgroundColor, //color,
          textColor: textColor, //Colors.white,
          onPressed: () {
            setPositionState(position);
          },
        ),
        //padding: EdgeInsets.all(20),
      );
    //}
    /*
    else {
      return Container(
        child: FlatButton(
          child: Text(
            answerDisplayValue, style: TextStyle(fontSize: fontSize),),
          color: backgroundColor, //color,
          textColor: textColor, //Colors.white,
        ),
        //padding: EdgeInsets.all(20),
      );
    }
    */
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
    bool isHeaderOfComponentInGroup = theComponentManager.isHeaderOfComponentInGroup();
    bool isHeaderOfGroups = theComponentManager.isHeaderOfGroups();
    bool isHeaderOfRandomComponents = theComponentManager.isHeaderOfRandomComponents();
    bool isHeaderOfExpandedComponents = theComponentManager.isHeaderOfExpandedComponents();

    if (theComponentManager.isGroupOrIndividualAnswerType(answeredPosition) || isHeaderOfComponentInGroup || isHeaderOfGroups || isHeaderOfRandomComponents || isHeaderOfExpandedComponents) {
      var result = ""; // = "Correct! ";
      if (isHeaderOfComponentInGroup  || isHeaderOfRandomComponents) {
        result = "Remember Component Numbers, then ";
      }
      else if (isHeaderOfGroups) {
        result = "Remember Group Numbers, then ";
      }
      else if (isHeaderOfExpandedComponents) {
      }
      else {
        //var answerType = theComponentManager.getAnswerType(answeredPosition);
        if (answeredPosition !=
            theComponentManager.getCorrectAnswerPosition()) {
          //TODO: theStatisticsManager.incrementLessonQuizResult(false);
          result = "Incorrect.";
        }
        else {
          //TODO: theStatisticsManager.incrementLessonQuizResult(true);
          result = "Correct! ";
        }
      }

      result += "continue";

      //_updateProgress();

      return Container(
        child: FlatButton(
          child: Text(result, style: TextStyle(fontSize: xYLength(18.0)),),
          color: Colors.blueAccent, // Colors.brown,
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              setPositionState(AnswerPosition.continueNext);

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

    //if (correctPercent >= 70.0) {
    //  title = "Congratulation!";
    //  content = "You have passed this quiz with a score of " + corStr + "!";
    //}
    //else {
      title = "Good job!";
      content = "You have completed this exercise and can move on to the next one.";
      //content = "You have achieved a score of " + corStr + ". You can come back later to reach 70.";
    //}


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
