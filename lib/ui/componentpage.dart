import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/componentpainter.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/componenttypinglist.dart';

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
  double screenWidth;

  double getSizeRatio() {
    return Utility.getSizeRatio(screenWidth);
  }

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
    screenWidth = Utility.getScreenWidth(context);

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

    var title = '';
    if (questionType == QuestionType.ComponentGroup) {
      title = 'Memorize component groups';
    }
    else if (questionType == QuestionType.ComponentInGroup) {
      title = 'Memorize components in groups';
    }
    else if (questionType == QuestionType.Component) {
      title = 'Memorize components';
    }
    else if (questionType == QuestionType.ExpandedComponent) {
      title = 'Learn the Expanded Components';
    }

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(title),
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
            padding: EdgeInsets.all(5.0 * getSizeRatio()), //10.0
          ),
          Container( // x and progress bard
            child: LinearProgressIndicator(value: _progressValue), //getProgressBar(context),
            padding: EdgeInsets.all(10 * getSizeRatio()),
          ),
          Container(
            child: getQuestion(context),
            padding: EdgeInsets.all(2 * getSizeRatio()),
          ),
          //Container(
          //  padding: EdgeInsets.all(10), //
          //),
          getAnswers(context),
          Container(
            padding: EdgeInsets.only(top: 15.0 * getSizeRatio()), //5.0
          ),
          Container(
            child: getContinue(context),
            padding: EdgeInsets.all(5),
          ),
        ]
    );
  }

  Widget getAnswers(BuildContext context) {
    if (this.questionType == QuestionType.ComponentGroup) {
      if (theComponentManager.isFirstHeaderOfGroups()) {
        return getFirstHeaderOfGroups();
      }
      else if (theComponentManager.isSecondHeaderOfGroups()) {
        return getSecondHeaderOfGroups();
      }
      else if (theComponentManager.isThirdHeaderOfGroups()) {
        return getThirdHeaderOfGroups();
      }
      else {
        return Container(
          child: getGroupAnswers(context),
         // padding: EdgeInsets.all(5), //20
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
          return getHeaderOfComponent();
        }
      }
      else if (this.questionType == QuestionType.Component && theComponentManager.isHeaderOfRandomComponents()) {
        // just return an empty Widget
      //  if (currentIndex == 0) {
          return getHeaderOfComponent();
      //  }
      //  else {
      //    return Container(width: 0.0, height: 0.0);
      //  }
          //padding: EdgeInsets.all(20), //10
        //);
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
          padding: EdgeInsets.all(20 * getSizeRatio()),
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

  Widget getFirstHeaderOfGroups() {
    return Column(
        children: <Widget>[
          Row(
              children: <Widget>[
                SizedBox(height: 30 * getSizeRatio()),
              ]
          ),
          Row(
              children: <Widget>[
                //SizedBox(width: 20),
                Flexible (
                  child: Text(
                      'Ready to memorize the Component-key pairings?',
                      style: TextStyle(fontSize: 15 * getSizeRatio(), fontWeight: FontWeight.bold)
                  ),
                )
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 40 * getSizeRatio()),
              ]
          ),
        ]
    );
  }

  Widget getSecondHeaderOfGroups() {
    return Column(
        children: <Widget>[
          Row(
              children: <Widget>[
                SizedBox(height: 30 * getSizeRatio()),
              ]
          ),
          Row(
            children: <Widget>[
              //SizedBox(width: 20),
              Flexible (
                child: Text(
                  //'The 25 lead components are divided into six groups and mapped to the left side and right side of the keyboard.',
                  'The pairings are divided into six groups (based on the first Stroke of each Component).',
                  style: TextStyle(fontSize: 15 * getSizeRatio()) // 18
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
              children: <Widget>[
                //SizedBox(width: 20),
                Flexible (
                  child: Text(
                    //'The 25 lead components are divided into six groups and mapped to the left side and right side of the keyboard.',
                      'Learn the above groups.',
                      style: TextStyle(fontSize: 15  * getSizeRatio(), fontWeight: FontWeight.bold) // 18
                  ),
                )
              ]
          ),
          Row(
            children: <Widget>[
              SizedBox(height: 40 * getSizeRatio()),
            ]
          ),
        ]
    );
  }

  Widget getThirdHeaderOfGroups() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          SizedBox(width: 40.0 * getSizeRatio()),
          Row(
              children: <Widget>[
                //SizedBox(width: 20),
                Flexible (
                  child: Text(
                    //'The 25 lead components are divided into six groups and mapped to the left side and right side of the keyboard.',
                      'Learn the above Component-key pairing groups.',
                      style: TextStyle(fontSize: 15 * getSizeRatio(), fontWeight: FontWeight.bold) // 18
                  ),
                )
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 40 * getSizeRatio()),
              ]
          ),
        ]
    );
  }

  Widget getHeaderOfComponentInGroup() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          Row(
              children: <Widget>[
                SizedBox(height: 30 * getSizeRatio()),
              ]
          ),
          Row(
              children: <Widget>[
                //SizedBox(width: 20),
                Flexible (
                  child: Text(
                    'The previous exercise introduced you to the Component-key pairings by group. In this exercise, you’ll memorize the Components within each group.',
                    style: TextStyle(fontSize: 15 * getSizeRatio())  // 20
                  ),
                ),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 20 * getSizeRatio()),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(width: 20 * getSizeRatio()),
                Flexible (
                  child: Text(
                      'Memorize the above Component-key pairings.',
                      style: TextStyle(fontSize: 15 * getSizeRatio(), fontWeight: FontWeight.bold)  // 20
                  ),
                )
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 40 * getSizeRatio()),
              ]
          ),
        ]
    );
  }

  Widget getHeaderOfComponent() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          Row(
              children: <Widget>[
                SizedBox(height: 30 * getSizeRatio()),
              ]
          ),
          Row(
              children: <Widget>[
                //SizedBox(width: 20),
                Flexible (
                  child: Text(
                      'Memorize the above Component-key pairings.',
                      style: TextStyle(fontSize: 15 * getSizeRatio(), fontWeight: FontWeight.bold)  // 20
                  ),
                )
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 40 * getSizeRatio()),
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
      if (currentIndex != 0 && theComponentManager.isGroupOrIndividualAnswerType(answeredPosition) ) {
        return Row(
          children: <Widget>[
            Container(
              child: getResultReminderImage(context), // only used by Expanded
              //padding: EdgeInsets.all(10),
            ),
            getQuestionImage(),
          ]
        );
      }
      else {
        return getQuestionImage();
      }
    }
  }

  Widget getResultReminderImage(BuildContext context) {
    String imagePath;
    double imageWidth = 180.0 * getSizeRatio();
    double imageHeight = 160.0 * getSizeRatio();

    if (currentIndex > 0 && questionType == QuestionType.ExpandedComponent) {
      var compCollection = theExpandedComponentList[currentIndex];
      var comp = theComponentManager.getComponentByGroupAndIndex(compCollection.groupNumber, compCollection.indexInGroup);

      imagePath =
          'assets/typing/' + comp.image;

      return Container(
          alignment: Alignment.topRight, //topLeft,
          child: Image.asset(
              imagePath,
              width: imageWidth,
              height: imageHeight
          )
      );
    }
    else {
      return Container(width: 0.0, height: 0.0);
    }
  }

  Widget getQuestionImage() {
    String imagePath;
    double imageWidth = 390.0 * getSizeRatio();
    double imageHeight = 150.0  * getSizeRatio();

    if (questionType == QuestionType.ComponentGroup) {
      var index = theComponentGroupListInRealExercise[currentIndex];
      imagePath = 'assets/typing/' + theComponentGroupList[index].imageName;
      imageHeight = 200.0 * getSizeRatio();
    }
    else if (questionType == QuestionType.ExpandedComponent) {
      imagePath = 'assets/typing/' + theExpandedComponentList[currentIndex].imageName;
      imageWidth = 160.0 * getSizeRatio();
      imageHeight = 160.0 * getSizeRatio();
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
         imageHeight = 250.0 * getSizeRatio();
      }
      else {
        var componentInGroup = theRandomComponentList[currentIndex];
        var component = theComponentManager.getComponentByGroupAndIndex(componentInGroup.groupNumber, componentInGroup.indexInGroup);
        imageName = component.image;
      }
      imagePath = 'assets/typing/' + imageName;
    }

    return Container(
        //color: Colors.grey,
        //padding: EdgeInsets.all(1.0),
        alignment: Alignment.center,
        child: Image.asset(
            imagePath,
            width: imageWidth,
            height: imageHeight,
            //fit: BoxFit.fitWidth,
        )
    );
  }

  Widget getGroupAnswers(BuildContext context) {
    return Column(
        children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getAnswerQuestion()
              ]
            ),
            Row(
              children: <Widget>[
                SizedBox(height: 10 * getSizeRatio()),  // 20.0
              ]
            ),
            Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 20 * getSizeRatio()),
                Flexible(child: getOneKeyboardAnswer(AnswerPosition.groupPosition1)),
                //Expanded(child: getText(AnswerPosition.groupPosition1)),
                SizedBox(width: 10 * getSizeRatio()),
                Flexible(child: getOneKeyboardAnswer(AnswerPosition.groupPosition2)),
              ],
            ),
            Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 20 * getSizeRatio()),
                Flexible(child: getOneKeyboardAnswer(AnswerPosition.groupPosition3)),
                SizedBox(width: 10 * getSizeRatio()),
                Flexible(child: getOneKeyboardAnswer(AnswerPosition.groupPosition4)),
              ],
            ),
            Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 20 * getSizeRatio()),
                Flexible(child: getOneKeyboardAnswer(AnswerPosition.groupPosition5)),
                SizedBox(width: 10 * getSizeRatio()),
                Flexible(child: getOneKeyboardAnswer(AnswerPosition.groupPosition6)),
              ],
            ),
        ]
    );
  }

  Widget getAnswerQuestion() {
    double size = 15.0 * getSizeRatio(); // 18

    if (answeredPosition != AnswerPosition.continueNext) {
      var questionSize = 0.0; // size
      if (questionType == QuestionType.ExpandedComponent) {
        questionSize = size * 1.5; // 3.0
      }
      return Container(width:0.0, height: questionSize);
    }
    else {
      String question = "Map the Component to its key.";

      if (questionType == QuestionType.ExpandedComponent) {
        var hint = theExpandedComponentList[currentIndex].hint;
        question =
            "Guess the Lead Component and corresponding key for these Expanded Components. (Hint: " +
                hint + ")";
      }
      else if (questionType == QuestionType.ComponentGroup) {
        question = "Match the Component group to its key group.";
      }

      return Flexible(
        child: Text(
            question,
            style: TextStyle(fontSize: size, fontWeight: FontWeight.bold)
        ),
      );
    }
  }

  Widget getIndividualAnswers(BuildContext context) {
    if (questionType == QuestionType.ExpandedComponent) {

      if (theComponentManager.isHeaderOfExpandedComponents()) {

        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(child: Text(
                     "This chart shows the Expanded Components for Lead Component 日（key O). To type an Expanded Component, just type its Lead Component 日（key O).",
                    style: TextStyle(fontSize: 15.0 * getSizeRatio()), // 18
                    textAlign: TextAlign.start),),
                ]
              ),
              Row(
                children: <Widget>[
                  SizedBox(height: 15 * getSizeRatio()),
                ]
              ),
              Row(
                  children: <Widget>[
                    Flexible(child: Text(
                          "Note: The Expanded Components have similar shapes to their Lead Component.",
                        style: TextStyle(fontSize: 15.0 * getSizeRatio(), fontStyle: FontStyle.italic),
                    textAlign: TextAlign.start),),// 18
                  ]
              ),
          ]
        );

        /*
        return Flexible (
          child: Text(
              //'Each Lead Component (in red) has some Expanded Components (in black) associated to it. Those Expanded Components look more or less similar to their corresponding Lead Component and you type the SAME keyboard key for the whole group. Therefore it is important to get more and more familiar with them over the time of actual typing.',
              "This chart shows the Expanded Components for Lead Component 日（O). To type an Expanded Component, just type its Lead Component 日（O). \n\nNote: The Expanded Components have similar shapes to their Lead Component.",
              style: TextStyle(fontSize: 15.0) // 18
          ),
        );
        */
      }
    }

    return Column(
        children: <Widget>[
          Row(
              children: <Widget>[
                getAnswerQuestion(),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 15 * getSizeRatio()),
              ]
          ),
          Row(
              textDirection: TextDirection.ltr,
              //mainAxisSize: MainAxisSize.max,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual15)),
                SizedBox(width: 2),
                Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual14)),
                SizedBox(width: 2),
                Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual13)),
                SizedBox(width: 2),
                Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual12)),
                SizedBox(width: 2),
                Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual11)),
                SizedBox(width: 5),
                Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual21)),
                SizedBox(width: 2),
                Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual22)),
                SizedBox(width: 2),
                Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual23)),
                SizedBox(width: 2),
                Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual24)),
                SizedBox(width: 2),
                Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual25)),
              ]
          ),
        Row(
          children: <Widget>[
            SizedBox(height: 4.0 * getSizeRatio()),
          ]
        ),
        Row(
            textDirection: TextDirection.ltr,
            //mainAxisSize: MainAxisSize.max,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual35)),
              SizedBox(width: 2),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual34)),
              SizedBox(width: 2),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual33)),
              SizedBox(width: 2),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual32)),
              SizedBox(width: 2),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual31)),
              SizedBox(width: 5),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual41)),
              SizedBox(width: 2),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual42)),
              SizedBox(width: 2),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual43)),
              SizedBox(width: 2),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual44)),
              SizedBox(width: 2),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.none)),
            ]
        ),
          Row(
              children: <Widget>[
                SizedBox(height: 4),
              ]
          ),
        Row(
            textDirection: TextDirection.ltr,
            //mainAxisSize: MainAxisSize.max,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual55)),
              SizedBox(width: 2),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual54)),
              SizedBox(width: 2),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual53)),
              SizedBox(width: 2),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual52)),
              SizedBox(width: 2),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual51)),
              SizedBox(width: 5),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual61)),
              SizedBox(width: 2),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.individual62)),
              SizedBox(width: 2),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.none)),
              SizedBox(width: 2),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.none)),
              SizedBox(width: 2),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.none)),
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

  Widget getOneKeyboardAnswer(AnswerPosition position)
  {
    if (position == AnswerPosition.none) {
      return Container(width: 0.0, height: 0.0);
    }

    var answerDisplayValue = theComponentManager.getAnswerDisplayValue(position);
    var currentType = theComponentManager.getCurrentType();

    var backgroundColor = Colors.white;  // make it a non-material color first
    // default without a color frame
    //backgroundColor = Colors.blueAccent;
    // actually no effect if no pressed action since the background will be white in that case.
    bool isPositionAtRightGroup = theComponentManager.isPositionAtRightGroup(position);
    if (currentType == QuestionType.ComponentInGroup) {
      if (!(position != AnswerPosition.center && position != AnswerPosition.none && !isPositionAtRightGroup)) {
        backgroundColor = Colors.blueAccent; //Colors.grey;
      }
    }

    bool isAGroupAnswerType = theComponentManager.isAGroupAnswerType(position);

    if (theComponentManager.isGroupOrIndividualAnswerType(answeredPosition) ) {
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

    // not used condition
    if (position == AnswerPosition.center) {
      backgroundColor = Colors.white;
    }

    var width = 35.0 * getSizeRatio();
    var height = 36.0  * getSizeRatio();
    if (isAGroupAnswerType) {
      width = 150.0  * getSizeRatio();
      height = 40.0  * getSizeRatio();
    }

    return FlatButton(
      color: backgroundColor,
      //textColor: Colors.blueAccent,
      padding: EdgeInsets.all(2.0), //EdgeInsets.zero,
      onPressed: () {
          setPositionState(position);
      },
      child: Image.asset(
        //TODO: temp folder and name
        "assets/letters/L" + answerDisplayValue + ".png", //+ image,
        width: width,
        height: height,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  // Mostly replaced by getOneKeyboardAnswer
  // One center usage left
  Widget getText(AnswerPosition position) {
    var answerDisplayValue = theComponentManager.getAnswerDisplayValue(position);
    var fontSize = 20.0 * getSizeRatio(); // 30.0

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
      fontSize = 100.0 * getSizeRatio();
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

    return Container(
        child: FlatButton(
          child: Text(
            answerDisplayValue, style: TextStyle(fontSize: fontSize),),
          color: backgroundColor, //color,
          textColor: textColor, //Colors.white,
          onPressed: () {
            setPositionState(position);
          },
        )
    );
  }

  // is only used in question in InputZi, therefore only used in center position.
  Widget getZiContainer(/*AnswerPosition position,*/ bool withNonCharFrame) {
    var size = 55.0 * getSizeRatio(); //35
    //if (position == AnswerPosition.center) {
      size = 120.0 * getSizeRatio();
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
    bool isFirstHeaderOfGroups = theComponentManager.isFirstHeaderOfGroups();
    bool isSecondHeaderOfGroups = theComponentManager.isSecondHeaderOfGroups();
    bool isThirdHeaderOfGroups = theComponentManager.isThirdHeaderOfGroups();
    bool isHeaderOfRandomComponents = theComponentManager.isHeaderOfRandomComponents();
    bool isHeaderOfExpandedComponents = theComponentManager.isHeaderOfExpandedComponents();

    if (theComponentManager.isGroupOrIndividualAnswerType(answeredPosition) || isHeaderOfComponentInGroup || isFirstHeaderOfGroups || isSecondHeaderOfGroups || isThirdHeaderOfGroups || isHeaderOfRandomComponents || isHeaderOfExpandedComponents) {
      var result = ""; // = "Correct! ";
      /*
      if (isHeaderOfComponentInGroup) {
        result = "Remember the keys of the above components in this group, then ";
      }
      else if (isHeaderOfRandomComponents) {
        result = "Remember the keys of the above components, then ";
      }
      else if (isFirstHeaderOfGroups) {
        result = "Let us ";
      }
      else if (isSecondHeaderOfGroups) {
        result = "Be able to distinguish the six groups, then ";
      }
      else if (isHeaderOfExpandedComponents) {
        result = "Please read above, then ";
      }
      */
      if (!isHeaderOfComponentInGroup && !isFirstHeaderOfGroups && !isSecondHeaderOfGroups && !isThirdHeaderOfGroups && !isHeaderOfRandomComponents && !isHeaderOfExpandedComponents) { // skip the first one
        //var answerType = theComponentManager.getAnswerType(answeredPosition);

        if (answeredPosition !=
            theComponentManager.getCorrectAnswerPosition()) {
          //TODO: theStatisticsManager.incrementLessonQuizResult(false);
          result = "Incorrect. ";
        }
        else {
          //TODO: theStatisticsManager.incrementLessonQuizResult(true);
          result = "Correct. ";
        }
      }

      result += "Next";

      //_updateProgress();

      return Container(
        child: FlatButton(
          child: Text(result, style: TextStyle(fontSize: 18.0 * getSizeRatio()),),
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

    String title;
    String content;

    //if (correctPercent >= 70.0) {
    //  title = "Congratulation!";
    //  content = "You have passed this quiz with a score of " + corStr + "!";
    //}
    //else {

      if (questionType == QuestionType.ComponentGroup) {
        title = "Good job!";
        content = "You’ve mastered all six Component groups! In the next exercise, you will memorize the Components in each group.";
      }
      if (questionType == QuestionType.ComponentInGroup) {
        title = "Good job!";
        content = "You remember the Components by group! In the next exercise, you will review the Components.";
      }
      if (questionType == QuestionType.Component) {
        title = "Way to go!";
        content = "You know your Lead Components! Let’s test your knowledge with some guided typing.";
      }
      if (questionType == QuestionType.ExpandedComponent) {
        title = "Wow!";
        content = "You know your Expanded Components! Let’s practice with some typing exercises.";
     }
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
