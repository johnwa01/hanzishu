
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
  String customString;

  StandardExamPage({required this.drillCategory, required this.subItemId, required this.quizCategory, required this.customString});
  //StandardExamPage({this.quizTextbook, this.lessonId, this.wordsStudy});

  @override
  _StandardExamPageState createState() => _StandardExamPageState();
}

class _StandardExamPageState extends State<StandardExamPage> {
  late DrillCategory drillCategory;
  late double screenWidth;
  late QuizCategory quizCategory;
  late String customString;
  int subItemId = -1;
  int internalStartItemId = -1;
  int internalEndItemId = -1;
  int currentIndex = -1;

  //bool isSoundAnswered;

  late AnswerPosition answerPosition;
  late QuizTextbook quizTextbook;
  int lessonId = -1;
  late String wordsStudy;
  int index = -1;
  double _progressValue = 0.0;
  int totalMeaningAndSoundQuestions = -1;

  getSizeRatio() {
    var defaultFontSize = screenWidth / 16.0;
    return defaultFontSize / 25.0; // ratio over original hard coded value
  }

  @override
  void initState() {
    super.initState();
    _progressValue = 0.0;
    drillCategory = widget.drillCategory;
    quizCategory = widget.quizCategory;
    subItemId = widget.subItemId;
    customString = widget.customString;
    //isSoundAnswered = false;

    theStandardExamManager.initValues(drillCategory, subItemId, quizCategory, customString);

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

    var title;
    if (drillCategory == DrillCategory.hsk) {
      if (quizCategory == QuizCategory.ziToSound) {
        if (subItemId == 0) {
          title = getString(455) + " - " /*+ getString(459) + " - "*/ +
              getString(447);
        }
        else {
          title = getString(455) + " " + getString(399) + subItemId.toString() +
              " - " + getString(447);
        }
      }
      else if (quizCategory == QuizCategory.meaning) {
        if (subItemId == 0) {
          title = getString(455) + " - " /*+ getString(459) + " - "*/ +
              getString(448);
        }
        else {
          title = getString(455) + " " + getString(399) + subItemId.toString() +
              " - " + getString(448);
        }
      }
      else if (quizCategory == QuizCategory.soundToZi) {
        if (subItemId == 0) {
          title = getString(455) + " - " /*+ getString(459) + " - "*/ +
              getString(488);
        }
        else {
          title = getString(455) + " " + getString(399) + subItemId.toString() +
              " - " + getString(488);
        }
      }
    }
    else if (drillCategory == DrillCategory.all) {
      if (quizCategory == QuizCategory.ziToSound) {
        title = getString(447);
      }
      else if (quizCategory == QuizCategory.meaning) {
        title = getString(448);
      }
      else if (quizCategory == QuizCategory.soundToZi) {
        title = getString(488);
      }
    }
    else {
      title = getString(6)/*"Quiz")*/;
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
            padding: EdgeInsets.only(top: 10.0 * getSizeRatio(), left: 10.0 * getSizeRatio(), right: 10.0 * getSizeRatio()), //25
          ),
          Container(
            child: getQuestion(context),
            //padding: EdgeInsets.all(20),
          ),
          Container(
            padding: EdgeInsets.all(18.0 * getSizeRatio()), //
          ),
          Container(
            child: getAnswers(context),
            padding: EdgeInsets.all(18.0 * getSizeRatio()), //40
          ),
          Container(
            padding: EdgeInsets.all(18.0 * getSizeRatio()), //
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

    if (quizCategory == QuizCategory.soundToZi) {
      return getSoundImage(AnswerPosition.center);
    }
    else {
      return getText(AnswerPosition.center);
    }

  }

  Widget getAnswers(BuildContext context) {
    /*
    if (quizCategory == QuizCategory.ziToSound) {
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
              SizedBox(height: 15.0 * getSizeRatio()),
              getText(AnswerPosition.positionB),
              SizedBox(height: 15.0 * getSizeRatio()),
              getText(AnswerPosition.positionC),
            ]
        )
      );
    }
    else if (quizCategory == QuizCategory.ziToSound){
      return Column(
        //textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                getSoundImage(AnswerPosition.positionA),
                SizedBox(height: 15.0 * getSizeRatio()),
                getSoundImage(AnswerPosition.positionB),
                SizedBox(height: 15.0 * getSizeRatio()),
                getSoundImage(AnswerPosition.positionC),
              ]
          ),
          SizedBox(height: 10.0 * getSizeRatio()),
          getSoundABCText(),
        ]
      );
    }
    else if(quizCategory == QuizCategory.soundToZi) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            getText(AnswerPosition.positionA),
            SizedBox(height: 15.0 * getSizeRatio()),
            getText(AnswerPosition.positionB),
            SizedBox(height: 15.0 * getSizeRatio()),
            getText(AnswerPosition.positionC),
          ]
      );
    }

    //should not reach here
    return SizedBox(width: 0.0, height: 0.0);
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
      else if (quizCategory == QuizCategory.soundToZi) {
        strValue = value.char;
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
      child: TextButton(
        child: Text(strValue, style: TextStyle(fontSize: fontSize, color: textColor),),
        //color: backgroundColor, //color,
        //textColor: textColor, //Colors.white,
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
    var size = 50.0;

    if (position == AnswerPosition.center) {
      size = 180.0;
    }

    return Container(
        height: size * getSizeRatio(), //180
        width: size * getSizeRatio(),
        child: IconButton(
          icon: Icon(
            Icons.volume_up,
            size: size * getSizeRatio(),   // 150
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
    Widget okButton = TextButton(
      child: Text(getString(286)/*"Ok"*/),
      onPressed: () {
        theIsBackArrowExit = false;
        Navigator.of(context).pop(); // out this dialog
        Navigator.of(context).pop(); // to the lesson page
      },
    );

    var lessonQuizResult = theStatisticsManager.getLessonQuizResult();
    //var correctPercent = (lessonQuizResult.cor * 100) / lessonQuizResult.answ;
    var subCountPerLevel = theStandardExamManager.getCurrentTestSubListTotal(); //StandardExamManager.hskZiCounts[subItemId-1];
    if (drillCategory == DrillCategory.hsk) {
      if (subItemId >= 1 && subItemId <= 6) {
        subCountPerLevel = 300;
      }
      else if (subItemId == 7) {
        subCountPerLevel = 1200;
      }
      else if (subItemId == 0) {
        subCountPerLevel = 3000;
      }
    }
    var diff = lessonQuizResult.cor - (lessonQuizResult.answ / 3);
    diff = (diff >= 0) ? diff : 0;
    double correctEstimate = subCountPerLevel * diff / (lessonQuizResult.answ * 2 / 3);
    var corStr = correctEstimate.toStringAsFixed(0);

    String  title = "Good effort!";
    //String levelString = subItemId.toString();
    //if (subItemId == 7) {
    //  levelString = "7/8/9";
    //}
    String  content = getString(457) + corStr + ". " + getString(458) + subCountPerLevel.toString() + ".";

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
