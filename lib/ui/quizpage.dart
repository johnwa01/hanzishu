
import 'package:flutter/material.dart';
import 'package:hanzishu/ui/quizpainter.dart';
import 'package:hanzishu/engine/quizmanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/texttospeech.dart';
import 'package:hanzishu/ui/shared/progress_indicator.dart';

class QuizPage extends StatefulWidget {
  final QuizTextbook quizTextbook;
  final quizCategory;
  final int lessonId;
  final String wordsStudy;
  final includeSkipSection;
  final bool showCompletedDialogOnSkip;
  bool isChars = true;

  QuizPage({required this.quizTextbook, required this.quizCategory, required this.lessonId, required this.wordsStudy, required this.includeSkipSection, this.showCompletedDialogOnSkip = false,});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late double screenWidth;
  late AnswerPosition answerPosition;
  late QuizTextbook quizTextbook;
  late QuizCategory quizCategory;
  late bool includeSkipSection;
  int lessonId = -1;
  String wordsStudy = '';
  int index = -1;
  double _progressValue = 0.0;
  int totalMeaningAndSoundQuestions = -1;
  String _lastAutoSpokenSoundToZiValue = '';

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
    quizCategory = widget.quizCategory;
    includeSkipSection = widget.includeSkipSection;
    theQuizManager.initValues(quizTextbook, quizCategory, wordsStudy);
    index = theQuizManager.getFirstIndex(quizTextbook, lessonId); //TODO: lessonId

    //if (quizTextbook != QuizTextbook.custom) {
    theStatisticsManager.initLessonQuizResults();
    //}

    totalMeaningAndSoundQuestions = theQuizManager.getTotalQuestions(quizTextbook, lessonId);
    if (quizTextbook != QuizTextbook.custom) {
      totalMeaningAndSoundQuestions *= 2;
    }

    //theQuizManager.setCurrentCategory(QuizCategory.soundToZi);

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
    thePositionManager.setFrameWidth(screenWidth - 10.0);
    //bool isCurrentCategoryMeaning = theQuizManager.getCurrentCategory() == QuizCategory.meaning;
    //if (fromPaintSound) {
    //  isCurrentCategoryMeaning = false; // directly skip to the sound category
    //}

    QuizType currentType = theQuizManager.getCurrentType();
    if (answerPosition == AnswerPosition.continueNext ||
        answerPosition == AnswerPosition.none) {
      // get values ready
      theQuizManager.getUpdatedValues(index, theQuizManager.getCurrentCategory() == QuizCategory.meaning);
      theQuizManager.getCurrentValuesNonCharIds();
      //currentCategory = theQuizManager.getCurrentCategory();
      currentType = theQuizManager.getCurrentType();

      var lessonQuizResult = theStatisticsManager.getLessonQuizResult();
      _progressValue = lessonQuizResult.answ/totalMeaningAndSoundQuestions;

      _prepareSoundToZiQuestion();
    }

    if (currentType == QuizType.none && quizTextbook != QuizTextbook.custom) {
      // Completed the quiz. Save the quiz results and go back to lesson page.
      theStatisticsManager.saveLessonQuizAndStatisticsToStorage();

      // Navigator.of(context).pop(); Note: let showCompletedDialog() to pop back together.
    }

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(
          getQuizTitle(),
          style: const TextStyle(fontSize: 24.0),
        ),
      ),
      body: Align
        (
        alignment: Alignment.topCenter,
        child: getQuizWizard(context /*, widget.lessonId*/),
      ),
    );
  }

  void _prepareSoundToZiQuestion() {
    if (theQuizManager.getCurrentCategory() != QuizCategory.soundToZi) {
      return;
    }

    var currentValues = theQuizManager.getCurrentValues();
    if (currentValues.length == 0) {
      return;
    }

    var currentSound = currentValues[0];
    answerPosition = AnswerPosition.soundIcon;

    if (_lastAutoSpokenSoundToZiValue != currentSound) {
      _lastAutoSpokenSoundToZiValue = currentSound;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        TextToSpeech.speak("zh-CN", currentSound);
      });
    }
  }

  String getQuizTitle() {
    if (quizCategory == QuizCategory.meaning) {
      return getString(448); // Test Hanzi Meaning
    }
    else if (quizCategory == QuizCategory.ziToSound) {
      return getString(447); // Test Hanzi to Sound
    }
    else if (quizCategory == QuizCategory.soundToZi) {
      return getString(488); // Test Sound to Hanzi
    }

    return getString(6); // Quiz
  }

  Widget getQuizWizard(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              18.0 * getSizeRatio(),
              28.0 * getSizeRatio(),
              18.0 * getSizeRatio(),
              0.0,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 2.0 * getSizeRatio(),
                    left: 2.0 * getSizeRatio(),
                    right: 2.0 * getSizeRatio(),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: getProgressBar(context),
                      ),
                      if (includeSkipSection) ...[
                        SizedBox(width: 14.0 * getSizeRatio()),
                        getSkipThisSection(),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 30.0 * getSizeRatio()),
                getTaskPrompt(),
                SizedBox(height: 15.0 * getSizeRatio()),
                getQuestion(context),
                SizedBox(height: 15.0 * getSizeRatio()),
                getAnswers(context),
                SizedBox(height: 20.0 * getSizeRatio()),
                getContinue(context),
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

    return HzProgressIndicator(
      value: _progressValue,
      current: lessonQuizResult.answ,
      total: totalMeaningAndSoundQuestions,
      thickness: HzProgressThickness.thick,
    );
  }

  Widget getTaskPrompt() {
    String prompt = "";

    if (theQuizManager.getCurrentCategory() == QuizCategory.meaning) {
      prompt = "Choose the meaning";
    }
    else if (theQuizManager.getCurrentCategory() == QuizCategory.ziToSound) {
      prompt = "Tap speakers to listen, then choose A, B, or C.";
    }
    else if (theQuizManager.getCurrentCategory() == QuizCategory.soundToZi) {
      prompt = "Listen, then choose the Hanzi.";
    }

    if (prompt.length == 0) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    return Text(
      prompt,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14.0,
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget getQuestion(BuildContext context) {
    Widget child;

    if (theQuizManager.getCurrentCategory() == QuizCategory.meaning ||
        theQuizManager.getCurrentCategory() == QuizCategory.ziToSound) {
      child = getZiContainer(AnswerPosition.center, false);
    }
    else {
      var currentValues = theQuizManager.getCurrentValues();

      child = SizedBox(
        height: 95.0 * getSizeRatio(),
        width: 95.0 * getSizeRatio(),
        child: IconButton(
          icon: Icon(
            Icons.volume_up,
            size: 90.0 * getSizeRatio(),
          ),
          color: Colors.cyan,
          onPressed: () {
            TextToSpeech.speak("zh-CN", currentValues[0]);
            setState(() {
              setPositionState(AnswerPosition.soundIcon);
            });
          },
        ),
      );
    }

    return Container(
      width: 240.0 * getSizeRatio(),
      constraints: const BoxConstraints(
        minWidth: 220.0,
        maxWidth: 330.0,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 8.0 * getSizeRatio(),
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
    var currentCategory = theQuizManager.getCurrentCategory();
    var currentType = theQuizManager.getCurrentType();
    if(currentCategory == QuizCategory.meaning || currentCategory == QuizCategory.ziToSound || (currentCategory == QuizCategory.soundToZi &&
        (answerPosition == AnswerPosition.soundIcon || answerPosition == AnswerPosition.positionA || answerPosition == AnswerPosition.positionB ||
            answerPosition == AnswerPosition.positionC))) {
      if (currentCategory ==
          QuizCategory.meaning ||currentType == QuizType.phrases ||
          currentType == QuizType.conversations) { // phrases and sentences
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            getMeaningAnswerCard(AnswerPosition.positionA),
            SizedBox(height: 18.0 * getSizeRatio()),
            getMeaningAnswerCard(AnswerPosition.positionB),
            SizedBox(height: 18.0 * getSizeRatio()),
            getMeaningAnswerCard(AnswerPosition.positionC),
          ],
        );
      }
      else if (currentCategory == QuizCategory.ziToSound) {
        // Zi only
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getOneZiToSoundAnswer(AnswerPosition.positionA),
            SizedBox(width: 48.0 * getSizeRatio()),
            getOneZiToSoundAnswer(AnswerPosition.positionB),
            SizedBox(width: 48.0 * getSizeRatio()),
            getOneZiToSoundAnswer(AnswerPosition.positionC),
          ],
        );
      }
      else {
        // Zi only
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getHanziAnswerCard(AnswerPosition.positionA),
            SizedBox(width: 48.0 * getSizeRatio()),
            getHanziAnswerCard(AnswerPosition.positionB),
            SizedBox(width: 48.0 * getSizeRatio()),
            getHanziAnswerCard(AnswerPosition.positionC),
          ],
        );
      }
    }

    //should not reach here
    return SizedBox(width: 0.0, height: 0.0);
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

  Widget getOneZiToSoundAnswer(AnswerPosition position) {
    var hanzi = getValue(position);

    return Column(
        children: <Widget>[
          Container(
              height: 50.0 * getSizeRatio(), //180
              width: 50.0 * getSizeRatio(),
              child: IconButton(
                icon: Icon(
                  Icons.volume_up,
                  size: 50.0 * getSizeRatio(),   // 150
                ),
                color: Colors.cyan, //Colors.green,
                onPressed: () {
                  TextToSpeech.speak("zh-CN", hanzi);
                },
              )
          ),
          SizedBox(height: 10),
          Container(
            //alignment: Alignment.topRight,
            child: getText(position, true),
          ),
        ]
    );

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


  Widget getHanziAnswerCard(AnswerPosition position) {
    var value = getValue(position);
    var isAnswered = answerPosition == AnswerPosition.positionA ||
        answerPosition == AnswerPosition.positionB ||
        answerPosition == AnswerPosition.positionC;

    Color cardColor = Colors.white;
    Color borderColor = Colors.blueAccent.withOpacity(0.18);
    Color textColor = Colors.blueAccent;

    if (isAnswered) {
      if (position == theQuizManager.getCorrectAnswerPosition()) {
        cardColor = Colors.greenAccent.withOpacity(0.25);
        borderColor = Colors.greenAccent;
        textColor = Colors.green.shade800;
      }
      else if (position == answerPosition) {
        cardColor = Colors.redAccent.withOpacity(0.18);
        borderColor = Colors.redAccent.withOpacity(0.65);
        textColor = Colors.red.shade700;
      }
    }

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(22.0),
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(0.10),
      child: InkWell(
        borderRadius: BorderRadius.circular(22.0),
        onTap: () {
          setPositionState(position);
        },
        child: Container(
          width: 74.0 * getSizeRatio(),
          height: 60.0 * getSizeRatio(),
          constraints: const BoxConstraints(
            minWidth: 64.0,
            minHeight: 54.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.0),
            border: Border.all(
              color: borderColor,
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32.0 * getSizeRatio(),
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getMeaningAnswerCard(AnswerPosition position) {
    var value = getValue(position);
    var isAnswered = answerPosition == AnswerPosition.positionA ||
        answerPosition == AnswerPosition.positionB ||
        answerPosition == AnswerPosition.positionC;

    Color cardColor = Colors.white;
    Color borderColor = Colors.blueAccent.withOpacity(0.12);
    Color textColor = Colors.blueAccent;

    if (isAnswered) {
      if (position == theQuizManager.getCorrectAnswerPosition()) {
        cardColor = Colors.greenAccent.withOpacity(0.25);
        borderColor = Colors.greenAccent;
        textColor = Colors.green.shade800;
      }
      else if (position == answerPosition) {
        cardColor = Colors.redAccent.withOpacity(0.18);
        borderColor = Colors.redAccent.withOpacity(0.65);
        textColor = Colors.red.shade700;
      }
    }

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(20.0),
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(0.12),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () {
          setPositionState(position);
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 54.0),
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: borderColor,
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: textColor,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getText(AnswerPosition position, bool wantUpperCaseLetter) {
    var value;
    if (wantUpperCaseLetter) {
      if (position == AnswerPosition.positionA) {
        value = 'A';
      }
      else if (position == AnswerPosition.positionB) {
        value = 'B';
      }
      else if (position == AnswerPosition.positionC) {
        value = 'C';
      }
    }
    else {
      value = getValue(position);
    }

    var fontSize = 30.0 * getSizeRatio(); // 35.0
    var currentType = theQuizManager.getCurrentType();

    if (currentType == QuizType.conversations) {
      fontSize = 25.0 * getSizeRatio();
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

    var textColor = Colors.white; //Colors.blue;
    if (position == AnswerPosition.center) {
      textColor = Colors.cyan; //Colors.blueAccent;
    }

    return Container(
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(backgroundColor),
        ),
        child: Text(value, style: TextStyle(fontSize: fontSize, color: textColor),),
        //color: backgroundColor, //color,
        //textColor: textColor, //Colors.white,
        onPressed: () {
          setPositionState(position);
        },
      ),
      //padding: EdgeInsets.all(20),
    );
  }

  Widget getZiContainer(AnswerPosition position, bool withNonCharFrame) {
    var size = 65.0 * getSizeRatio(); //35
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
      return getText(position, false);
    }
  }

  Widget getSkipThisSection() {
    if (includeSkipSection/*theIsFromLessonContinuedSection || quizTextbook == QuizTextbook.custom*/) {
      return TextButton(
        child: Text(
          getString(401) /*"Skip this section"*/, style: TextStyle(fontSize: 14.0, color: Colors.blueAccent),),
        //color: Colors.white,
        //textColor: Colors.blueAccent,
        onPressed: () {
          theIsBackArrowExit = false;

          if (widget.showCompletedDialogOnSkip) {
            showCompletedDialog(context);
          } else {
            Navigator.of(context).pop();
          }
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

      result += getString(285)/*"Continue"*/ + " ->";

      //_updateProgress();

      return SizedBox(
        width: 220.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ),
          ),
          child: Text(
            result,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0 * getSizeRatio(), color: Colors.black87),
          ),
          onPressed: () {
            setState(() {
              setPositionState(AnswerPosition.continueNext);
              index = theQuizManager.getNextIndexForCurrentType();
              if (theQuizManager.getCurrentType() == QuizType.none) {
                showCompletedDialog(context);
              }
            });
          },
        ),
      );
    }

    // should not reach here
    return SizedBox(width: 0.0, height: 0.0);
  }

  showCompletedDialog(BuildContext context) {
    var lessonQuizResult = theStatisticsManager.getLessonQuizResult();
    var correctPercent = lessonQuizResult.answ == 0
        ? 0.0
        : (lessonQuizResult.cor * 100) / lessonQuizResult.answ;
    var corStr = correctPercent.toStringAsFixed(1) + "%";

    String title;
    String content;

    if (correctPercent >= 70.0) {
      title = getString(118) + "!"; // Congratulations!
      content = getString(467) + " " + corStr + "!";
      if (quizTextbook != QuizTextbook.custom) {
        updateCompleteStatus();
        theHasNewlyCompletedLesson = true;
      }
    }
    else {
      title = getString(466) + "!"; // Good effort!
      content = getString(468) + " " + corStr + ". "/* + getString(469)*/;
    }

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
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  corStr,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  content,
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