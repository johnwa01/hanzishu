
import 'package:flutter/material.dart';
import 'package:hanzishu/ui/quizpainter.dart';
import 'package:hanzishu/engine/quizmanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/texttospeech.dart';

class QuizPage extends StatefulWidget {
  final QuizTextbook quizTextbook;
  final int lessonId;
  final String wordsStudy;
  bool isChars = true;

  QuizPage({this.quizTextbook, this.lessonId, this.wordsStudy});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  double screenWidth;
  AnswerPosition answerPosition;
  QuizTextbook quizTextbook;
  int lessonId;
  String wordsStudy;
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

    //TODO
    //theStatisticsManager.initLessonQuizResults();
    lessonId = widget.lessonId;
    quizTextbook = widget.quizTextbook;
    wordsStudy = widget.wordsStudy;
    theQuizManager.initValues();
    index = theQuizManager.getFirstIndex(lessonId); //TODO: lessonId

    theStatisticsManager.initLessonQuizResults();

    totalMeaningAndSoundQuestions = theQuizManager.getTotalQuestions(lessonId) * 2;

    setState(() {
      answerPosition = AnswerPosition.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    //if (answerPosition == AnswerPosition.continueNext) {
    //  index = theQuizManager.getNextIndexForCurrentType();
    //}

    screenWidth = Utility.getScreenWidthForTreeAndDict(context);

    QuizType currentType = theQuizManager.getCurrentType();
    if (answerPosition == AnswerPosition.continueNext ||
        answerPosition == AnswerPosition.none) {
        // get values ready
        theQuizManager.getUpdatedValues(
          index, theQuizManager.getCurrentCategory() == QuizCategory.meaning);
        theQuizManager.getCurrentValuesNonCharIds();
      //currentCategory = theQuizManager.getCurrentCategory();
      currentType = theQuizManager.getCurrentType();

      var lessonQuizResult = theStatisticsManager.getLessonQuizResult();
      _progressValue = lessonQuizResult.answ/totalMeaningAndSoundQuestions;
    }

    if (currentType == QuizType.none) {
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
            alignment: Alignment.topRight,
            child: getSkipThisSection(),
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
    if (theQuizManager.getCurrentCategory() == QuizCategory.meaning) { // short button
      return getZiContainer(AnswerPosition.center, false);
    }
    else {
      var currentValues = theQuizManager.getCurrentValues();

      return Container(
        height: 150.0 * getSizeRatio(), //180
          width: 150.0 * getSizeRatio(),
        child: IconButton(
            icon: Icon(
                Icons.volume_up,
                size: 150.0 * getSizeRatio(),   // 150
            ),
            color: Colors.cyan, //Colors.green,
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
          ),
        );
      }
      else {
        // Zi only
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              getZiContainer(AnswerPosition.positionA, true),
              SizedBox(height: 5.0 * getSizeRatio()),
              getZiContainer(AnswerPosition.positionB, true),
              SizedBox(height: 5.0 * getSizeRatio()),
              getZiContainer(AnswerPosition.positionC, true),
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
    var fontSize = 30.0 * getSizeRatio(); // 35.0
    var currentType = theQuizManager.getCurrentType();

    if (currentType == QuizType.conversations) {
      fontSize = 25 * getSizeRatio();
    }

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
      if (position == theQuizManager.getCorrectAnswerPosition()) {
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

  Widget getZiContainer(AnswerPosition position, bool withNonCharFrame) {
    var size = 55.0 * getSizeRatio(); //35
    if (position == AnswerPosition.center) {
      size = 120.0 * getSizeRatio();
    }

    var noncharId = getNoncharId(position);

    //var backgroundColor = Colors.white;  // make it a non-material color first
    var backgroundColor = Colors.blueAccent;
    if (answerPosition == AnswerPosition.positionA || answerPosition == AnswerPosition.positionB || answerPosition == AnswerPosition.positionC) {
      //backgroundColor = Colors.blueAccent;
      if (position == theQuizManager.getCorrectAnswerPosition()) {
        backgroundColor = Colors.greenAccent;
      }
      else if (position == answerPosition) {
        backgroundColor = Colors.redAccent;
      }
    }

    var lineColor = Colors.grey; //Colors.amber;  //TODO: want to be white like other text, but white is not a MaterialColor
    if (position == AnswerPosition.center) {
      lineColor = Colors.cyan;
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
              lineColor: lineColor, //lineColor, //Colors.amber,
              completeColor: backgroundColor, //color, //Colors.blueAccent,
              centerId: noncharId,
              withNonCharFrame: withNonCharFrame,//*centerZiId*/,
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

  Widget getSkipThisSection() {
    if (theIsFromLessonContinuedSection) {
      return FlatButton(
        child: Text(
          getString(401) /*"Skip this section"*/, style: TextStyle(fontSize: 14.0),),
        color: Colors.white,
        textColor: Colors.blueAccent,
        onPressed: () {
          theIsBackArrowExit = false;
          Navigator.of(context).pop();
        },
      );
    }
    else {
      return SizedBox(width: 0, height: 0);
    }
  }

  Widget getContinue(BuildContext context) {
    if (answerPosition == AnswerPosition.positionA || answerPosition == AnswerPosition.positionB || answerPosition == AnswerPosition.positionC) {
      var result; // = "Correct! ";
      if (answerPosition != theQuizManager.getCorrectAnswerPosition()) {
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

                //if (answerPosition == AnswerPosition.continueNext) {
                  // prepare for next one
                  // Could be done in Build(), but Build won't allow showCompletedDialog() there.
                  index = theQuizManager.getNextIndexForCurrentType();
                //}
                if (theQuizManager.getCurrentType() == QuizType.none) {
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
      // save the info to storage
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
    var wasCompleted = theStorageHandler.hasLessonCompleted(lessonId);
    if (!wasCompleted) {
      theStorageHandler.updateOneLessonStatus(lessonId, true);
      theStorageHandler.SaveToFile();
    }
  }

  /*
  //NOTE: setState within the Timer so that this function will be called repeatedly.
  void _updateProgress() {
    const oneSec = const Duration(seconds: 5);
    new Timer(oneSec, () {     //timeout(oneSec, (Timer t) {   //periodic
      //setState(() {
           _progressValue += 0.2;
        // we "finish" downloading here
        if (_progressValue.toStringAsFixed(1) == '1.0') {
          //_loading = false;
          //t.cancel();
          //_progressValue: 0.0;
          return;
        }
      //});
    });
  }
  */
}