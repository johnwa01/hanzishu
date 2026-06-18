
import 'package:flutter/material.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/ui/quizpainter.dart';
import 'package:hanzishu/engine/quizmanager.dart';
import 'package:hanzishu/engine/standardexammanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/ui/shared/progress_indicator.dart';

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
  String _lastAutoSpokenChar = "";

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

  void _scheduleSpeakCurrentSoundQuestion() {
    if (quizCategory != QuizCategory.soundToZi) {
      return;
    }

    var currentValues = theStandardExamManager.getCurrentValues();
    if (currentValues.length == 0) {
      return;
    }

    var char = currentValues[0].char;
    if (char.length == 0 || char == _lastAutoSpokenChar) {
      return;
    }

    _lastAutoSpokenChar = char;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      TextToSpeech.speak("zh-CN", char);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    thePositionManager.setFrameWidth(screenWidth - 10.0);
    // Only support this type for now.
    QuizType currentType = QuizType.chars; //theQuizManager.getCurrentType();

    // tell manager to get values ready
    theStandardExamManager.getUpdatedValues();
    _scheduleSpeakCurrentSoundQuestion();

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
        title: Text(
          title,
          style: const TextStyle(fontSize: 24.0),
        ),
      ),
      body: Center
        (
        //child: Text("This is Lesson Page."),
        child: getQuizWizard(context /*, widget.lessonId*/),
      ),
    );
  }

  Widget getQuizWizard(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0 * getSizeRatio()),
            child: Column(
              children: <Widget>[
                Container(
                  child: getProgressBar(context),
                  padding: EdgeInsets.only(
                    top: 10.0 * getSizeRatio(),
                    left: 2.0 * getSizeRatio(),
                    right: 2.0 * getSizeRatio(),
                  ),
                ),
                SizedBox(height: 18.0 * getSizeRatio()),
                getTaskPrompt(),
                SizedBox(height: 10.0 * getSizeRatio()),
                getQuestion(context),
                SizedBox(height: (quizCategory == QuizCategory.soundToZi ? 28.0 : 18.0) * getSizeRatio()),
                getAnswers(context),
                SizedBox(height: 24.0 * getSizeRatio()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getProgressBar(BuildContext context) {
    var lessonQuizResult = theStatisticsManager.getLessonQuizResult();
    var current = lessonQuizResult.answ;
    var total = totalMeaningAndSoundQuestions;

    return HzProgressIndicator(
      value: _progressValue,
      current: current,
      total: total,
      thickness: HzProgressThickness.thin,
    );
  }

  Widget getTaskPrompt() {
    String prompt = "";

    if (quizCategory == QuizCategory.meaning) {
      prompt = "Choose the meaning";
    }
    else if (quizCategory == QuizCategory.soundToZi) {
      prompt = "Choose the Hanzi";
    }
    else if (quizCategory == QuizCategory.ziToSound) {
      prompt = "Choose the sound";
    }

    if (prompt.length == 0) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    return Text(
      prompt,
      style: TextStyle(
        fontSize: 14.0,
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget getQuestion(BuildContext context) {
    var value = getValue(AnswerPosition.center);

    Widget child;
    if (quizCategory == QuizCategory.soundToZi) {
      child = getSoundImage(AnswerPosition.center);
    }
    else {
      child = TextButton(
        onPressed: () {
          TextToSpeech.speak("zh-CN", value.char);
        },
        child: Text(
          value.char,
          style: TextStyle(
            fontSize: 72.0 * getSizeRatio(),
            color: Colors.cyan,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    var isSoundQuestion = quizCategory == QuizCategory.soundToZi;

    return Container(
      width: (isSoundQuestion ? 210.0 : 240.0) * getSizeRatio(),
      constraints: BoxConstraints(
        minWidth: isSoundQuestion ? 190.0 : 220.0,
        maxWidth: isSoundQuestion ? 260.0 : 330.0,
      ),
      padding: EdgeInsets.symmetric(
        vertical: (isSoundQuestion ? 6.0 : 8.0) * getSizeRatio(),
        horizontal: 16.0 * getSizeRatio(),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(child: child),
    );
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

    if (quizCategory == QuizCategory.meaning) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          getAnswerCard(AnswerPosition.positionA),
          SizedBox(height: 12.0 * getSizeRatio()),
          getAnswerCard(AnswerPosition.positionB),
          SizedBox(height: 12.0 * getSizeRatio()),
          getAnswerCard(AnswerPosition.positionC),
        ],
      );
    }
    else if (quizCategory == QuizCategory.ziToSound){
      return Column(
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
            Expanded(child: getAnswerCard(AnswerPosition.positionA)),
            SizedBox(width: 12.0 * getSizeRatio()),
            Expanded(child: getAnswerCard(AnswerPosition.positionB)),
            SizedBox(width: 12.0 * getSizeRatio()),
            Expanded(child: getAnswerCard(AnswerPosition.positionC)),
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

  String getAnswerText(AnswerPosition position) {
    var value = getValue(position);

    if (quizCategory == QuizCategory.meaning) {
      return value.meaning;
    }
    else if (quizCategory == QuizCategory.soundToZi) {
      return value.char;
    }
    else {
      if (position == AnswerPosition.positionA) {
        return "A";
      }
      else if (position == AnswerPosition.positionB) {
        return "B";
      }
      else if (position == AnswerPosition.positionC) {
        return "C";
      }
    }

    return "";
  }

  void answerQuestion(AnswerPosition position) {
    answerPosition = position;

    if (answerPosition != theStandardExamManager.getCorrectAnswerPosition()) {
      theStatisticsManager.incrementLessonQuizResult(false);
    }
    else {
      theStatisticsManager.incrementLessonQuizResult(true);
    }

    var lessonQuizResult = theStatisticsManager.getLessonQuizResult();
    _progressValue = lessonQuizResult.answ / totalMeaningAndSoundQuestions;

    setState(() {
      index = theStandardExamManager.getNext();
    });

    if (index == -1) {
      showCompletedDialog(context);
    }
  }

  Widget getAnswerCard(AnswerPosition position) {
    var answerText = getAnswerText(position);
    var isMeaningTest = quizCategory == QuizCategory.meaning;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.0),
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(0.12),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () {
          answerQuestion(position);
        },
        child: Container(
          constraints: BoxConstraints(
            minHeight: isMeaningTest ? 54.0 : 76.0,
          ),
          padding: EdgeInsets.symmetric(
            vertical: isMeaningTest ? 10.0 : 16.0,
            horizontal: 20.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: Colors.blueAccent.withOpacity(0.12),
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              answerText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMeaningTest ? 20.0 : 30.0,
                color: Colors.blueAccent,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          ),
        ),
      ),
    );
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

    var textColor = Colors.blue;
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
      size = quizCategory == QuizCategory.soundToZi ? 88.0 : 150.0;
    }

    var displaySize = size * getSizeRatio();
    if (position == AnswerPosition.center && quizCategory == QuizCategory.soundToZi) {
      displaySize = displaySize.clamp(72.0, 112.0).toDouble();
    }

    return SizedBox(
      height: displaySize,
      width: displaySize,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: Icon(
          Icons.volume_up,
          size: displaySize,
        ),
        color: Colors.cyan,
        onPressed: () {
          TextToSpeech.speak("zh-CN", value.char);
        },
      ),
    );
  }

  showCompletedDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(getString(286)/*"Ok"*/, style: TextStyle(color: Colors.blue)),
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // Placeholder mascot
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.green.shade300,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.sentiment_very_satisfied,
                    size: 52,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  getString(457),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  "$corStr / $subCountPerLevel",
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  theDefaultLocale == "zh_CN"
                      ? "继续练习，让它们记得更牢！"
                      : "Keep practicing to make them even stronger!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () {
                      theIsBackArrowExit = false;
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(getString(286)),
                  ),
                ),
              ],
            ),
          ),
        );
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
