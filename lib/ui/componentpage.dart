import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/ui/componentpainter.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/engine/componentmanager.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/componenttypinglist.dart';
import 'package:hanzishu/ui/shared/tutorialstepindicator.dart';
import 'package:hanzishu/ui/shared/tutorialcompletedialog.dart';
import 'package:hanzishu/ui/shared/hz_text_styles.dart';

class ComponentPage extends StatefulWidget {
  final QuestionType questionType;
  //final int lessonId;
  bool isChars = true;

  ComponentPage({required this.questionType});

  @override
  _ComponentPageState createState() => _ComponentPageState();
}

class _ComponentPageState extends State<ComponentPage> {
  QuestionType? questionType;
  AnswerPosition? answeredPosition;
  //int lessonId;
  AnswerType? answerType;
  int currentIndex = -1; // assign the value from the one in ComponentManager every time so that we can keep its state per exit/re-enter case
  double _progressValue = 0.0;
  int totalQuestions = -1;
  int totalCorrectAnswers = 0;
  double screenWidth = 0.0;
  //int preIndexAtCurrentIndex0 = 10; // we don't need this mechanism any more.
  bool wasLastAnswerCorrect = false;
  bool wasLastQuestionEverIncorrect = false;
  bool isFromPreviousButton = false;
  int previousButtonCount = 0;

  double getSizeRatioWithLimit() {
    return Utility.getSizeRatioWithLimit(screenWidth);
  }

  @override
  void initState() {
    super.initState();
    _progressValue = 0.0;

    questionType = widget.questionType;
    //TODO
    //theStatisticsManager.initLessonQuizResults();

    theComponentManager.setCurrentType(questionType);
    theComponentManager.initCurrentIndex();
    //preIndexAtCurrentIndex0 = 10; // we don't need this mechanism any more.
    currentIndex = theComponentManager.getCurrentIndex(widget.questionType);

    //theStatisticsManager.initLessonQuizResults();

    totalQuestions = theComponentManager.getTotalQuestions(widget.questionType);
    wasLastAnswerCorrect = false;
    wasLastQuestionEverIncorrect = false;
    totalCorrectAnswers = 0;

    setState(() {
      answeredPosition = AnswerPosition.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    //screenWidth = Utility.getScreenWidth(context);
    screenWidth = Utility.getScreenWidthForTreeAndDict(context);
    thePositionManager.setFrameWidth(screenWidth - 10.0);

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
    /*
    if (questionType == QuestionType.ComponentGroup) {
      title = getString(101)/*'Component-key pairing groups'*/;
    }
    else if (questionType == QuestionType.ComponentInGroup) {
      title = getString(102)/*'Memorize by groups'*/;
    }
    */
    if (questionType == QuestionType.Component) {
      title = getString(103); //'Learn the 25 Keys';
    }
    else if (questionType == QuestionType.ExpandedComponent) {
      title = getString(623); //'Similar Shapes, Same Key';
    }
    else if (questionType == QuestionType.ShowAttachedComponent) {
      title = getString(328) /*'Show Attached Components'*/;
    }

    return Scaffold
      (
      appBar: AppBar
        (
        title: Text(title, style: HzTextStyles.appBarTitle),
      ),
      body: getComponentWizard(context /*, widget.lessonId*/),
    );
  }

  Widget getSkipThisSection() {
    if (theIsFromTypingContinuedSection) {
      return TextButton(
        child: Text(
            getString(401) /*"Skip this section"*/, style: TextStyle(fontSize: 14.0, color: Colors.blueAccent)),
        //color: Colors.white,
        //textColor: Colors.blueAccent,
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

  Widget getComponentWizard(BuildContext context) {
    if (questionType == QuestionType.ExpandedComponent &&
        currentIndex == 0) {
      return getStepThreeLandingPage(context);
    }

    if (questionType == QuestionType.ExpandedComponent &&
        currentIndex > 0) {
      return getStepThreeKeyPage(context);
    }

    if (questionType == QuestionType.Component &&
        currentIndex == 0 /*&&
        preIndexAtCurrentIndex0 == 1*/) {
      return getStepTwoLandingPage(context);
    }

//    if (questionType == QuestionType.Component &&
//        currentIndex == 0 /*&&
//        preIndexAtCurrentIndex0 >= 2 &&
//        preIndexAtCurrentIndex0 < 6*/) {
//      return getStepTwoGroupPage(context);
//    }

    /*
    if (questionType == QuestionType.Component &&
        currentIndex == 0 &&
        preIndexAtCurrentIndex0 == 6) {
      return getStepTwoSummaryPage(context);
    }
    */

    if (questionType == QuestionType.Component &&
        currentIndex > 0) {
      return getStepTwoQuizPage(context);
    }

    return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0 * getSizeRatioWithLimit()), //5.0
          ),
          Container( // x and progress bard
            child: LinearProgressIndicator(value: _progressValue), //getProgressBar(context),
            padding: EdgeInsets.only(left: 10 * getSizeRatioWithLimit(), right: 10 * getSizeRatioWithLimit()),
          ),
          Container(
            alignment: Alignment.topRight,
            child: getSkipThisSection(),
          ),
          getHintText(),
          Container(
            child: getQuestion(context),
            padding: EdgeInsets.all(2 * getSizeRatioWithLimit()),
          ),
          //Container(
          //  padding: EdgeInsets.all(10), //
          //),
          getAnswers(context),
          Container(
            padding: EdgeInsets.only(top: 15.0 * getSizeRatioWithLimit()), //5.0
          ),
          Row(
              children: <Widget>[
                Container(child: getPrevious(context), padding: EdgeInsets.all(5)),
                SizedBox(width: 50.00 * getSizeRatioWithLimit()),
                Container(child: getContinue(context), padding: EdgeInsets.all(5)),
              ]
          ),
        ]
    );
  }


  String getCurrentComponentHintString() {
    String hint = '';
    if (questionType == QuestionType.Component) {
      var leadCompIndex = ComponentManager.getHintIndexOfGivenComponent(currentIndex);
      if (leadCompIndex >= 0) {
        hint = getString(theLeadComponentList[leadCompIndex].hint);
      }
    }
    return hint;
  }


  String getCurrentStepThreeHintString() {
    String hint = '';
    if (questionType == QuestionType.ExpandedComponent && currentIndex > 0) {
      hint = getString(theExpandedComponentList[currentIndex].hint);
    }
    return hint;
  }

  Widget getStepThreeKeyPage(BuildContext context) {
    double ratio = getSizeRatioWithLimit();
    String hintText = getCurrentStepThreeHintString();

    double cardWidth = 300.0 * ratio;
    if (cardWidth > 420.0) {
      cardWidth = 420.0;
    }
    if (cardWidth < 240.0) {
      cardWidth = 240.0;
    }

    double cardHeight = 170.0 * ratio;
    if (cardHeight > 220.0) {
      cardHeight = 220.0;
    }
    if (cardHeight < 140.0) {
      cardHeight = 140.0;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFFFBF2),
            Color(0xFFF4FAFF),
          ],
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints pageConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: pageConstraints.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.0 * ratio,
                    vertical: 8.0 * ratio,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: getStepThreeKeyProgress(ratio),
                          ),

                          SizedBox(width: 16.0 * ratio),

                          getSkipThisSection(),
                        ],
                      ),

                      SizedBox(height: 12.0 * ratio),

                      Text(
                        hintText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.0 * ratio,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF24344D),
                        ),
                      ),
                      SizedBox(height: 14.0 * ratio),
                      Container(
                        width: cardWidth,
                        height: cardHeight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0 * ratio),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Color(0x1F24344D),
                              blurRadius: 20.0 * ratio,
                              offset: Offset(0, 9.0 * ratio),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(14.0 * ratio),
                        child: getStepThreeQuestionImage(),
                      ),
                      SizedBox(height: 20.0 * ratio),
                      Text(
                        getString(624), //'Tap the matching key below.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19.0 * ratio,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF24344D),
                        ),
                      ),
                      SizedBox(height: 14.0 * ratio),
                      getCenteredKeyboardAnswers(context),
                      SizedBox(height: 18.0 * ratio),
                      getStepThreeBottomNavigation(context, ratio),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getStepTwoKeyProgress(double ratio) {
    const int totalKeyCount = 30;

    int currentKeyNumber = currentIndex;

    //if (currentKeyNumber < 1) {
    //  currentKeyNumber = 1;
    //}
    if (currentKeyNumber > totalKeyCount) {
      currentKeyNumber = totalKeyCount;
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: LinearProgressIndicator(
            value: currentKeyNumber / totalKeyCount,
            minHeight: 3.0,
            backgroundColor: Color(0xFFD7E0EE),
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2F80ED)),
          ),
        ),
        SizedBox(width: 10.0 * ratio),
        Text(
          '$currentKeyNumber / $totalKeyCount',
          style: TextStyle(
            fontSize: 13.0 * ratio,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7A8798),
          ),
        ),
      ],
    );
  }

  Widget getStepThreeKeyProgress(double ratio) {
    int totalKeyCount = 25;
    int currentKeyNumber = currentIndex;

    if (currentKeyNumber > totalKeyCount) {
      currentKeyNumber = totalKeyCount;
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: LinearProgressIndicator(
            value: currentKeyNumber / totalKeyCount,
            minHeight: 3.0,
            backgroundColor: Color(0xFFD7E0EE),
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2F80ED)),
          ),
        ),
        SizedBox(width: 10.0 * ratio),
        Text(
          currentKeyNumber.toString() + ' / ' + totalKeyCount.toString(),
          style: TextStyle(
            fontSize: 13.0 * ratio,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7A8798),
          ),
        ),
      ],
    );
  }

  Widget getStepThreeBottomNavigation(BuildContext context, double ratio) {
    bool showContinue = false;
    if (theComponentManager.isGroupOrIndividualAnswerType(answeredPosition)) {
      showContinue = answeredPosition != theComponentManager.getCorrectAnswerPosition();
    }

    if (showContinue) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(child: getPrevious(context), padding: EdgeInsets.all(5)),
          SizedBox(width: 54.0 * ratio),
          Container(child: getContinue(context), padding: EdgeInsets.all(5)),
        ],
      );
    }

    return Center(
      child: Container(
        child: getPrevious(context),
        padding: EdgeInsets.all(5),
      ),
    );
  }

  Widget getStepThreeQuestionImage() {
    if (questionType == QuestionType.ExpandedComponent && currentIndex > 0) {
      String imagePath = 'assets/typing/' + theExpandedComponentList[currentIndex].imageName;
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
      );
    }

    return getQuestionImage();
  }

  Widget getStepTwoQuizPage(BuildContext context) {
    double ratio = getSizeRatioWithLimit();
    String hintText = getCurrentComponentHintString();

    bool isAHeadOfRandomComponents = theComponentManager.isHeaderOfRandomComponents();

    double imageWidth = isAHeadOfRandomComponents ? 720.0 * ratio : 150.0 * ratio;
    double imageHeight = isAHeadOfRandomComponents ? 520.0 * ratio : 150.0 * ratio;

    if (imageWidth > 780.0) imageWidth = 780.0;
    if (imageHeight > 560.0) imageHeight = 560.0;

    if (isAHeadOfRandomComponents) {
      if (theComponentManager.isLastHeaderOfRandomComponents()) {
        hintText = getString(619); //"Review the 25 mappings";
      }
      else {
        hintText = getString(618); //"Learn mapping in this group";
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFFFBF2),
            Color(0xFFF4FAFF),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 18.0 * ratio,
              vertical: 6.0 * ratio,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //if (isAHeadOfRandomComponents)
                //  Align(
                //    alignment: Alignment.topRight,
                //    child: getSkipThisSection(),
                //  )
                //else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: getStepTwoKeyProgress(ratio),
                    ),
                    SizedBox(width: 16.0 * ratio),
                    getSkipThisSection(),
                  ],
                ),
                SizedBox(height: 6.0 * ratio),
                Text(
                  hintText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0 * ratio,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF24344D),
                  ),
                ),
                SizedBox(height: 12.0 * ratio),

                Container(
                  width: imageWidth,
                  height: imageHeight,
                  alignment: Alignment.center,
                  child: getQuestionImage(),
                ),

                SizedBox(height: 24.0 * ratio),
                if (!isAHeadOfRandomComponents)
                  Text(
                    getString(617), //'Choose the matching key',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0 * ratio,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF24344D),
                    ),
                  ),
                if (!isAHeadOfRandomComponents) SizedBox(height: 14.0 * ratio),
                if (!isAHeadOfRandomComponents) getCenteredKeyboardAnswers(context),

                SizedBox(height: 6.0 * ratio),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(child: getPrevious(context), padding: EdgeInsets.all(5)),
                    SizedBox(width: 54.0 * ratio),
                    Container(child: getContinue(context), padding: EdgeInsets.all(5)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getCenteredKeyboardAnswers(BuildContext context) {
    double ratio = getSizeRatioWithLimit();

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              getModernKeyboardAnswer(AnswerPosition.individual15),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual14),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual13),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual12),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual11),
              SizedBox(width: 5),
              getModernKeyboardAnswer(AnswerPosition.individual21),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual22),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual23),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual24),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual25),
            ],
          ),
          SizedBox(height: 4.0 * ratio),
          Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              getModernKeyboardAnswer(AnswerPosition.individual35),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual34),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual33),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual32),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual31),
              SizedBox(width: 5),
              getModernKeyboardAnswer(AnswerPosition.individual41),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual42),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual43),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual44),
            ],
          ),
          SizedBox(height: 4.0 * ratio),
          Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              getModernKeyboardAnswer(AnswerPosition.individual55),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual54),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual53),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual52),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual51),
              SizedBox(width: 5),
              getModernKeyboardAnswer(AnswerPosition.individual61),
              SizedBox(width: 2),
              getModernKeyboardAnswer(AnswerPosition.individual62),
            ],
          ),
        ],
      ),
    );
  }

  Widget getStepTwoLandingPage(BuildContext context) {
    double ratio = getSizeRatioWithLimit();
    double heroSize = 260.0 * ratio;
    if (heroSize > 320.0) {
      heroSize = 320.0;
    }
    if (heroSize < 210.0) {
      heroSize = 210.0;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFFFBF2),
            Color(0xFFF4FAFF),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0 * ratio,
              vertical: 10.0 * ratio, //20.0
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    SizedBox(
                      width: 110.0 * ratio,
                    ),

                    Expanded(
                      child: Center(
                        child: TutorialStepIndicator(
                          currentStep: 2,
                          ratio: ratio,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 110.0 * ratio,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: getSkipThisSection(),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 18.0 * ratio),
                Text(
                  getString(616), //'English keys to represent Chinese components',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17.0 * ratio,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6A768A),
                  ),
                ),
                SizedBox(height: 18.0 * ratio),
                Container(
                  width: heroSize,
                  height: heroSize,  // *0.88
                  child: CustomPaint(
                    painter: StepTwoKeyCubePainter(),
                  ),
                ),
                SizedBox(height: 22.0 * ratio),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28.0 * ratio),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Color(0x332F80ED),
                        blurRadius: 18.0 * ratio,
                        offset: Offset(0, 8.0 * ratio),
                      ),
                    ],
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Color(0xFF2F80ED)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0 * ratio),
                        ),
                      ),
                      padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(
                          horizontal: 34.0 * ratio,
                          vertical: 14.0 * ratio,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          getString(301), /*'Start',*/
                          style: TextStyle(
                            fontSize: 17.0 * ratio,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 6.0 * ratio),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20.0 * ratio,
                        ),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        runContinueLogic();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget getStepThreeLandingPage(BuildContext context) {
    double ratio = getSizeRatioWithLimit();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFFFBF2),
            Color(0xFFF4FAFF),
          ],
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double contentWidth = constraints.maxWidth;
            double heroSize = contentWidth * 0.28;
            if (heroSize > 180.0) {
              heroSize = 180.0;
            }
            if (heroSize < 150.0) {
              heroSize = 150.0;
            }

            double cardSize = contentWidth * 0.10;
            if (cardSize > 92.0) {
              cardSize = 92.0;
            }
            if (cardSize < 54.0) {
              cardSize = 54.0;
            }

            double titleFontSize = 34.0 * ratio;
            if (titleFontSize > 38.0) {
              titleFontSize = 38.0;
            }
            if (titleFontSize < 24.0) {
              titleFontSize = 24.0;
            }

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0 * ratio,
                    vertical: 18.0 * ratio,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          SizedBox(
                            width: 110.0 * ratio,
                          ),

                          Expanded(
                            child: Center(
                              child: TutorialStepIndicator(currentStep: 3, ratio: ratio),
                            ),
                          ),

                          SizedBox(
                            width: 110.0 * ratio,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: getSkipThisSection(),
                            ),
                          ),
                        ],
                      ),

                      //SizedBox(height: 14.0 * ratio),
                      SizedBox(height: 26.0 * ratio),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          getSmallOrangeBurst(ratio, false),
                          Flexible(
                            child: Text(
                              getString(622), //'25 keys for common components',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: HzTextStyles.pageSubtitle.fontSize, //titleFontSize * 0.8,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF4A2BC6),
                                height: 1.12,
                              ),
                            ),
                          ),
                          getSmallOrangeBurst(ratio, true),
                        ],
                      ),
                      SizedBox(height: 26.0 * ratio), //36
                      getStepThreeHeroKey(heroSize, ratio),
                      SizedBox(height: 20.0 * ratio), // 26
                      getStepThreeComponentCards(cardSize, ratio),
                      SizedBox(height: 24.0 * ratio), // 34
                      getStepThreeStartButton(ratio),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getSmallOrangeBurst(double ratio, bool flip) {
    double width = 35.0 * ratio;
    if (width > 35.0) {
      width = 35.0;
    }
    if (width < 28.0) {
      width = 28.0;
    }

    return Container(
      width: width,
      height: width,
      margin: EdgeInsets.symmetric(horizontal: 8.0 * ratio),
      child: CustomPaint(
        painter: StepThreeBurstPainter(flip: flip),
      ),
    );
  }

  Widget getStepThreeHeroKey(double heroSize, double ratio) {
    return Container(
      width: heroSize,
      height: heroSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.0 * ratio),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFFFC247),
            Color(0xFFFF8A00),
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x552F1A00),
            blurRadius: 22.0 * ratio,
            offset: Offset(0, 12.0 * ratio),
          ),
          BoxShadow(
            color: Color(0x55FFFFFF),
            blurRadius: 12.0 * ratio,
            offset: Offset(-6.0 * ratio, -6.0 * ratio),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'A',
          style: TextStyle(
            fontSize: heroSize * 0.56,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(
                color: Color(0x66000000),
                blurRadius: 6.0 * ratio,
                offset: Offset(0, 3.0 * ratio),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getStepThreeComponentCards(double cardSize, double ratio) {
    List<String> components = <String>['人', '火', '大', '央', '个', '金', '久'];

    return Container(
      constraints: BoxConstraints(maxWidth: cardSize * 4.8),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16.0 * ratio,
        runSpacing: 16.0 * ratio,
        children: components.map((String component) {
          return Container(
            width: cardSize,
            height: cardSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0 * ratio),
              border: Border.all(
                color: Color(0xFFE1D9FF),
                width: 1.4,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Color(0x1F4A2BC6),
                  blurRadius: 12.0 * ratio,
                  offset: Offset(0, 7.0 * ratio),
                ),
              ],
            ),
            child: Text(
              component,
              style: TextStyle(
                fontSize: cardSize * 0.56,
                fontWeight: FontWeight.w700,
                color: Color(0xFF303340),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget getStepThreeStartButton(double ratio) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.0 * ratio),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x442F1CCF),
            blurRadius: 18.0 * ratio,
            offset: Offset(0, 8.0 * ratio),
          ),
        ],
      ),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Color(0xFF6438E8)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0 * ratio),
            ),
          ),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: 42.0 * ratio,
              vertical: 15.0 * ratio,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              getString(301), //'Start',
              style: TextStyle(
                fontSize: 18.0 * ratio,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10.0 * ratio),
            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 24.0 * ratio,
            ),
          ],
        ),
        onPressed: () {
          setState(() {
            runContinueLogic();
          });
        },
      ),
    );
  }

/*
  Widget getCompletedStepIndicator(double ratio) {
    return Container(
      width: 30.0 * ratio,
      height: 30.0 * ratio,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF2F80ED),
        border: Border.all(
          color: Color(0xFF2F80ED),
          width: 1.5,
        ),
      ),
      child: Icon(
        Icons.check_rounded,
        color: Colors.white,
        size: 19.0 * ratio,
      ),
    );
  }
*/

  Widget getAnswers(BuildContext context) {
    /*
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
    */
    if(this.questionType == QuestionType.Component  /*|| this.questionType == QuestionType.ComponentInGroup || this.questionType == QuestionType.ComponentGroup*/ || this.questionType == QuestionType.ExpandedComponent || this.questionType == QuestionType.ShowAttachedComponent) {
/*
      if (/*this.questionType == QuestionType.ComponentInGroup &&*/ theComponentManager.isHeaderOfComponentInGroup()) {
        if (currentIndex == 0) {
          // only for the first time
          return getHeaderOfComponentInGroup();
        }
        else {
          return getHeaderOfComponent();
        }
      }
 */
      if (this.questionType == QuestionType.Component && theComponentManager.isHeaderOfRandomComponents()) {
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
          padding: EdgeInsets.all(20 * getSizeRatioWithLimit()),
        );
      }
    }
    else {
      return SizedBox(width: 0.0, height: 0.0);
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
                SizedBox(height: 30 * getSizeRatioWithLimit()),
              ]
          ),
          Row(
              children: <Widget>[
                //SizedBox(width: 20),
                Flexible (
                  child: Text(
                      getString(121)/*('Ready to memorize the Component-key pairings?'*/,
                      style: TextStyle(fontSize: 15 * getSizeRatioWithLimit(), fontWeight: FontWeight.bold)
                  ),
                )
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 40 * getSizeRatioWithLimit()),
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
                SizedBox(height: 30 * getSizeRatioWithLimit()),
              ]
          ),
          Row(
              children: <Widget>[
                //SizedBox(width: 20),
                Flexible (
                  child: Text(
                    //'The 25 lead components are divided into six groups and mapped to the left side and right side of the keyboard.',
                      getString(122)/*'The pairings are divided into six groups (based on the first Stroke of each Component). Five single-stroke components are located in the middle, therefore remember each group from middle to sides.'*/,
                      style: TextStyle(fontSize: 15 * getSizeRatioWithLimit()) // 18
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
                      getString(123)/*'Learn the above groups.'*/,
                      style: TextStyle(fontSize: 15  * getSizeRatioWithLimit(), fontWeight: FontWeight.bold) // 18
                  ),
                )
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 40 * getSizeRatioWithLimit()),
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
          SizedBox(width: 40.0 * getSizeRatioWithLimit()),
          Row(
              children: <Widget>[
                //SizedBox(width: 20),
                Flexible (
                  child: Text(
                    //'The 25 lead components are divided into six groups and mapped to the left side and right side of the keyboard.',
                      getString(124)/*'Learn the above Component-key pairing groups.'*/,
                      style: TextStyle(fontSize: 15 * getSizeRatioWithLimit(), fontWeight: FontWeight.bold) // 18
                  ),
                )
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 40 * getSizeRatioWithLimit()),
              ]
          ),
        ]
    );
  }

  /*
  Widget getHeaderOfComponentInGroup() {
    String componentKeyPairingHeaderString = getString(126)/*'Memorize the above Component-key pairings.'*/;
    if (questionType == QuestionType.Component && currentIndex == 0 && preIndexAtCurrentIndex0 == 1) {
      componentKeyPairingHeaderString = getString(388);
    }
    else if (questionType == QuestionType.Component && currentIndex == 0 && preIndexAtCurrentIndex0 < 6) {
      componentKeyPairingHeaderString = getString(416);
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          Row(
              children: <Widget>[
                SizedBox(height: 30 * getSizeRatioWithLimit()),
              ]
          ),
          Row(
              children: <Widget>[
                //SizedBox(width: 20),
                Flexible (
                  child: Text(
                      getString(125)/*'The previous exercise introduced you to the Component-key pairings by group. In this exercise, you’ll memorize the Components within each group.'*/,
                      style: TextStyle(fontSize: 15 * getSizeRatioWithLimit())  // 20
                  ),
                ),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 20 * getSizeRatioWithLimit()),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(width: 20 * getSizeRatioWithLimit()),
                Flexible (
                  child: Text(
                      componentKeyPairingHeaderString,
                      style: TextStyle(fontSize: 20 * getSizeRatioWithLimit(), fontWeight: FontWeight.bold)  // 20
                  ),
                )
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 40 * getSizeRatioWithLimit()),
              ]
          ),
        ]
    );
  }
*/


  Widget getHeaderOfComponent() {
    var str;

    //if (currentIndex == 0) {
    //  if (questionType == QuestionType.Component && preIndexAtCurrentIndex0 == 1) {
    //    str = getString(514); /* 25 categories of Chinese alphabets*/
    //  }
    //  else if (questionType == QuestionType.Component && preIndexAtCurrentIndex0 < 6) {
    //    str = ''; //getString(416); /* learn content & mapping then continue*/
    //  }
    //  else {
    str = getString(126) /*'Memorize the above Component-key pairings - 1.'*/;
    //  }
    //}
    //else if (currentIndex == 7) {
    //  str = getString(358)/*'Review - 2.'*/;
    //}
    //else {
    //  str = getString(359)/*'Review again - 3.'*/;
    //}

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          Row(
              children: <Widget>[
                SizedBox(height: 8 * getSizeRatioWithLimit()),
              ]
          ),
          Row(
              children: <Widget>[
                //SizedBox(width: 20),
                Flexible (
                  child: Text(
                      str,
                      style: TextStyle(fontSize: 13 * getSizeRatioWithLimit()/*, fontWeight: FontWeight.bold*/)  // 20
                  ),
                )
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 10 * getSizeRatioWithLimit()),
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
    /*
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
    */
    else if (questionType == QuestionType.ExpandedComponent || questionType == QuestionType.ShowAttachedComponent) {
      //if(theComponentManager.isHeaderOfExpandedComponents()) {
      //  return getHeaderOfExpandedComponents();
      //}
      /*
      if (currentIndex != 0 && theComponentManager.isGroupOrIndividualAnswerType(answeredPosition) ) {
        return Row(
          children: <Widget>[
           // Container(
           //   child: getResultReminderImage(context), // only used by Expanded
              //padding: EdgeInsets.all(10),
           // ),
            getQuestionImage(),
          ]
        );
      }
      else {
       */
      return getQuestionImage();
      //}
    }
    /*
    else if (questionType == QuestionType.ReviewExpandedComponent) {
      if (theComponentManager.isGroupOrIndividualAnswerType(answeredPosition) ) {
        return Row(
            children: <Widget>[
              SizedBox(width: 40 * getSizeRatioWithLimit()),
              getReviewExpandedComponentChar(),
              SizedBox(width: 60 * getSizeRatioWithLimit()),
              Container(
                child: getResultReminderImage(context), // only used by Expanded Component and Review Expanded Component
                //padding: EdgeInsets.all(10),
              ),
            ]
        );
      }
      else {
        return Row(
            children: <Widget>[
              SizedBox(width: 40 * getSizeRatioWithLimit()),
              getReviewExpandedComponentChar(),
              SizedBox(height: 160 * getSizeRatioWithLimit())
            ]
        );
      }
    }
    */
    else {
      return SizedBox(width: 0.0, height: 0.0);
    }
  }

/*
  Widget getReviewExpandedComponentChar() {
    var comp = theReviewExpandedComponentList[currentIndex];
    return Text(
          comp.hint, // hint or char
          style: TextStyle(fontSize: 60.0 * getSizeRatioWithLimit(), fontWeight: FontWeight.bold)
    );
  }
*/

  Widget getResultReminderImage(BuildContext context) {
    String imagePath = '';
    double imageWidth = 180.0 * getSizeRatioWithLimit();
    double imageHeight = 160.0 * getSizeRatioWithLimit();

    if ((currentIndex > 0 && questionType == QuestionType.ExpandedComponent) /*|| (questionType == QuestionType.ReviewExpandedComponent)*/) {
      if (questionType == QuestionType.ExpandedComponent) {
        var compCollection = theExpandedComponentList[currentIndex];
        var comp = theComponentManager.getComponentByGroupAndIndex(
            compCollection.groupNumber, compCollection.indexInGroup);
        imagePath = 'assets/typing/' + comp.image;
      }
      else if (currentIndex > 0 && questionType == QuestionType.ShowAttachedComponent) {
        var compCollection = theShowAttachedComponentList[currentIndex];
        var comp = theComponentManager.getComponentByGroupAndIndex(
            compCollection.groupNumber, compCollection.indexInGroup);
        imagePath = 'assets/typing/' + comp.image;
      }


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
    String imagePath = '';
    double imageWidth = 390.0 * getSizeRatioWithLimit();
    double imageHeight = 150.0  * getSizeRatioWithLimit();

    /*
    if (questionType == QuestionType.ComponentGroup) {
      var index = theComponentGroupListInRealExercise[currentIndex];
      imagePath = 'assets/typing/' + theComponentGroupList[index].imageName;
      imageHeight = 200.0 * getSizeRatioWithLimit();
    }
    */
    if (questionType == QuestionType.ExpandedComponent) {
      imagePath = 'assets/typing/' + theExpandedComponentList[currentIndex].imageName;
      imageWidth = 160.0 * getSizeRatioWithLimit();
      imageHeight = 120.0 * getSizeRatioWithLimit();
    }
    if (questionType == QuestionType.ShowAttachedComponent) {
      imagePath = 'assets/typing/' + theShowAttachedComponentList[currentIndex].imageName;
      imageWidth = 160.0 * getSizeRatioWithLimit();
      imageHeight = 120.0 * getSizeRatioWithLimit();
    }
    /*
    else if (questionType == QuestionType.ReviewExpandedComponent) {
      return getReviewExpandedComponentChar();
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
    */
    else if (questionType == QuestionType.Component) { // for the header only
      //if (preIndexAtCurrentIndex0 == 0 || preIndexAtCurrentIndex0 == 1) {
      //  return SizedBox(width: 0.0, height: 0.0);
      //}

      var imageName;
      //if (questionType == QuestionType.Component && currentIndex == 0 && preIndexAtCurrentIndex0 < 6) {
      //  if (theDefaultLocale == "zh_CN") {
      //    imageName = 'T' + (preIndexAtCurrentIndex0 + 1).toString() + '.png';
      //  }
      //  else { // English
      //    imageName = 'T' + (preIndexAtCurrentIndex0 + 1).toString() + '_E.png';
      //  }
      //  imageWidth = 980.0;
      //  imageHeight = 760.0;
      //}
      if (theComponentManager.isHeaderOfRandomComponents()) {
        imageName = theComponentManager.getHeaderImageNameOfRandomComponents();

        if (theDefaultLocale == "zh_CN" || imageName == "GG6") {
          imageName += '.png';
        }
        else {
          imageName += '_E.png';
        }

        imageWidth = 720.0 * getSizeRatioWithLimit();
        imageHeight = 560.0 * getSizeRatioWithLimit();
      }
      else {
        var componentInGroup = theRandomComponentList[currentIndex];
        var component = theComponentManager.getComponentByGroupAndIndex(componentInGroup.groupNumber, componentInGroup.indexInGroup);
        imageName = component.image;
        imageWidth =150.0 * getSizeRatioWithLimit(); // 160
        imageHeight = 150.0 * getSizeRatioWithLimit(); //160
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
                SizedBox(height: 10 * getSizeRatioWithLimit()),  // 20.0
              ]
          ),
          Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 20 * getSizeRatioWithLimit()),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.groupPosition1)),
              //Expanded(child: getText(AnswerPosition.groupPosition1)),
              SizedBox(width: 10 * getSizeRatioWithLimit()),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.groupPosition2)),
            ],
          ),
          Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 20 * getSizeRatioWithLimit()),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.groupPosition3)),
              SizedBox(width: 10 * getSizeRatioWithLimit()),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.groupPosition4)),
            ],
          ),
          Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 20 * getSizeRatioWithLimit()),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.groupPosition5)),
              SizedBox(width: 10 * getSizeRatioWithLimit()),
              Flexible(child: getOneKeyboardAnswer(AnswerPosition.groupPosition6)),
            ],
          ),
        ]
    );
  }

  Widget getHintText() {
    var hint;
    if (questionType == QuestionType.Component) {
      var leadCompIndex = ComponentManager.getHintIndexOfGivenComponent(
          currentIndex);

      if (leadCompIndex >= 0) {
        hint = getString(theLeadComponentList[leadCompIndex].hint);
      }
    }
    else if (questionType == QuestionType.ExpandedComponent) {
      if (currentIndex > 0) {
        hint = getString(theExpandedComponentList[currentIndex].hint);
      }
    }
    else if (questionType == QuestionType.ShowAttachedComponent) {
      if (currentIndex > 0) {
        hint = getString(theShowAttachedComponentList[currentIndex].hint);
      }
    }

    if (hint != null) {
      return Text(
          '[' + hint + ']',
          style: TextStyle(color: Colors.lightBlue, fontSize: 16.0 * getSizeRatioWithLimit(),
              fontWeight: FontWeight.bold)
      );
    }
    else {
      return SizedBox(width: 0, height: 0);
    }
  }

  Widget getAnswerQuestion() {
    double size = 15.0 * getSizeRatioWithLimit(); // 18

    if (answeredPosition != AnswerPosition.none && answeredPosition != AnswerPosition.continueNext) {
      var questionSize = 0.0; // size
      if (questionType == QuestionType.ExpandedComponent || questionType == QuestionType.ShowAttachedComponent) {
        questionSize = size * 1.5; // 3.0
      }
      if (wasLastAnswerCorrect) {
        if (!wasLastQuestionEverIncorrect && !isFromPreviousButton) {
          totalCorrectAnswers++;
        }
        else { // re-init
          wasLastQuestionEverIncorrect = false;
        }
      }
      else {
        wasLastQuestionEverIncorrect = true; // as long as incorrect once, it'll be counted as incorrect for this question.
      }
      return Container(width:0.0, height: questionSize);
    }
    else { // continueNext
      String question = "";
      if (wasLastAnswerCorrect) {
        question = getString(284)/*"Correct. "*/;
        if (!wasLastQuestionEverIncorrect && !isFromPreviousButton) {
          totalCorrectAnswers++;
        }
        else { // re-init
          wasLastQuestionEverIncorrect = false;
        }
      }

      //var hint;
      if (questionType == QuestionType.Component) {
        var leadCompIndex = ComponentManager.getHintIndexOfGivenComponent(currentIndex);
        question += getString(128); /*"Please map the Component to its key."*/
        //if (leadCompIndex >= 0) {
        //  hint = getString(theLeadComponentList[leadCompIndex].hint);
        //  question += " (" +
        //          getString(90) /*"Hint"*/ + ": " +
        //          hint + ")";
        //}
      }
      else if (questionType == QuestionType.ExpandedComponent) {
        //hint = getString(theExpandedComponentList[currentIndex].hint);
        question +=
            getString(129)/*"Guess the Lead Component and corresponding key for these Expanded Components."*/ /*+ " (" + getString(90)"Hint" + ": " +
                hint + ")"*/;
      }
      else if (questionType == QuestionType.ShowAttachedComponent) {
        //hint = getString(theShowAttachedComponentList[currentIndex].hint);
        question +=
            getString(129)/*"Guess the Lead and corresponding key for these Expanded Components."*/ /*+ " (" + getString(90)"Hint" + ": " +
                hint + ")"*/; //TODO: update the string for this case
      }
      /*
      if (questionType == QuestionType.ReviewExpandedComponent) {
        //var hint = theExpandedComponentList[currentIndex].hint;
        question =
            getString(309)/*"For the above Expanded Component, guess its Lead Component and type corresponding key."*/;
      }
      else if (questionType == QuestionType.ComponentGroup) {
        question = getString(130)/*"Match above Component group to its key group."*/;
      }
      */

      return Flexible(
        child: Text(
            question,
            style: TextStyle(fontSize: size, fontWeight: FontWeight.bold)
        ),
      );
    }
  }

  Widget getIndividualAnswers(BuildContext context) {
    if (questionType == QuestionType.ExpandedComponent || questionType == QuestionType.ShowAttachedComponent) {

      if (theComponentManager.isHeaderOfExpandedComponents() || theComponentManager.isHeaderOfShowAttachedComponents() ) {
        String headText = "";
        if (theComponentManager.isHeaderOfExpandedComponents()) {
          headText =  getString(131); /*"This chart shows the Expanded Components for Lead Component 日（key O). To type an Expanded Component, just type its Lead Component 日（key O)."*/
        }
        else if (theComponentManager.isHeaderOfShowAttachedComponents()) {
          headText = getString(389); //"学习不常用部件";
        }

        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  children: <Widget>[
                    Flexible(child: Text(
                        headText,
                        style: TextStyle(fontSize: 15.0 * getSizeRatioWithLimit()), // 18
                        textAlign: TextAlign.start),),
                  ]
              ),
              Row(
                  children: <Widget>[
                    SizedBox(height: 15 * getSizeRatioWithLimit()),
                  ]
              ),
              /*
              Row(
                  children: <Widget>[
                    Flexible(child: Text(
                          getString(132)/*"Note: The Expanded Components have similar shapes to their Lead Component."*/,
                        style: TextStyle(fontSize: 15.0 * getSizeRatioWithLimit(), fontStyle: FontStyle.italic),
                    textAlign: TextAlign.start),),// 18
                  ]
              ),
               */
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
                SizedBox(height: 15 * getSizeRatioWithLimit()),
              ]
          ),
          Row(
              textDirection: TextDirection.ltr,
              //mainAxisSize: MainAxisSize.max,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                getOneKeyboardAnswer(AnswerPosition.individual15),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual14),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual13),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual12),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual11),
                SizedBox(width: 5),
                getOneKeyboardAnswer(AnswerPosition.individual21),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual22),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual23),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual24),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual25),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 4.0 * getSizeRatioWithLimit()),
              ]
          ),
          Row(
              textDirection: TextDirection.ltr,
              //mainAxisSize: MainAxisSize.max,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                getOneKeyboardAnswer(AnswerPosition.individual35),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual34),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual33),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual32),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual31),
                SizedBox(width: 5),
                getOneKeyboardAnswer(AnswerPosition.individual41),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual42),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual43),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual44),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.none),
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
                getOneKeyboardAnswer(AnswerPosition.individual55),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual54),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual53),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual52),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual51),
                SizedBox(width: 5),
                getOneKeyboardAnswer(AnswerPosition.individual61),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.individual62),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.none),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.none),
                SizedBox(width: 2),
                getOneKeyboardAnswer(AnswerPosition.none),
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
    //bool isPositionAtRightGroup = theComponentManager.isPositionAtRightGroup(position);
    /*
    if (currentType == QuestionType.ComponentInGroup) {
      if (!(position != AnswerPosition.center && position != AnswerPosition.none && !isPositionAtRightGroup)) {
        backgroundColor = Colors.blueAccent; //Colors.grey;
      }
    }
    */

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

    var width = 40.0 * getSizeRatioWithLimit();
    var height = 41.0  * getSizeRatioWithLimit();
    if (isAGroupAnswerType) {
      width = 150.0  * getSizeRatioWithLimit();
      height = 40.0  * getSizeRatioWithLimit();
    }

    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(backgroundColor),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0)),  // 0.0 is rectangle
        ),
        minimumSize: WidgetStateProperty.all(Size(20.0, 20.0)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: WidgetStateProperty.all(EdgeInsets.all(2.0)), // 2.0 for showing color for correct or wrong ones
      ),
      onPressed: () {
        bool cameFromPrevious = isFromPreviousButton;
        setPositionState(position);
        wasLastAnswerCorrect = false;

        if (answeredPosition == theComponentManager.getCorrectAnswerPosition()) {
          wasLastAnswerCorrect = true;
          countModernCorrectAnswerIfNeeded(cameFromPrevious);

          // if correct, directly move to next question
          setState(() {
            runContinueLogic();
          });
        }
        else {
          wasLastQuestionEverIncorrect = true;
        }

        isFromPreviousButton = false;
      },
      child: Image.asset(
        "assets/letters/L" + answerDisplayValue + ".png",
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }

  // Mostly replaced by getOneKeyboardAnswer
  // One center usage left
  Widget getText(AnswerPosition position) {
    var answerDisplayValue = theComponentManager.getAnswerDisplayValue(position);
    var fontSize = 20.0 * getSizeRatioWithLimit(); // 30.0

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
      fontSize = 100.0 * getSizeRatioWithLimit();
    }

    // actually no effect if no pressed action since the background will be white in that case.
    //bool isPositionAtRightGroup = theComponentManager.isPositionAtRightGroup(position);
    if (position != AnswerPosition.center && position != AnswerPosition.none /*&& !isPositionAtRightGroup*/) {
      backgroundColor = Colors.grey;
    }

    var textColor = Colors.blue;

    if (position == AnswerPosition.center) {
      textColor = Colors.cyan; //Colors.blueAccent;
    }

    return Container(
        child: TextButton(
          child: Text(
            answerDisplayValue, style: TextStyle(fontSize: fontSize, color: textColor),),
          //color: backgroundColor, //color,
          //textColor: textColor, //Colors.white,
          onPressed: () {
            setPositionState(position);
          },
        )
    );
  }

  // is only used in question in InputZi, therefore only used in center position.
  Widget getZiContainer(/*AnswerPosition position,*/ bool withNonCharFrame) {
    var size = 55.0 * getSizeRatioWithLimit(); //35
    //if (position == AnswerPosition.center) {
    size = 120.0 * getSizeRatioWithLimit();
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
    isFromPreviousButton = false;
    //bool isHeaderOfComponentInGroup = theComponentManager.isHeaderOfComponentInGroup();
    //bool isFirstHeaderOfGroups = theComponentManager.isFirstHeaderOfGroups();
    //bool isSecondHeaderOfGroups = theComponentManager.isSecondHeaderOfGroups();
    //bool isThirdHeaderOfGroups = theComponentManager.isThirdHeaderOfGroups();
    bool isHeaderOfRandomComponents = theComponentManager.isHeaderOfRandomComponents();
    bool isHeaderOfExpandedComponents = theComponentManager.isHeaderOfExpandedComponents();
    bool isHeaderOfShowAttachedComponents = theComponentManager.isHeaderOfShowAttachedComponents();

    if (theComponentManager.isGroupOrIndividualAnswerType(answeredPosition) || isHeaderOfRandomComponents || isHeaderOfExpandedComponents || isHeaderOfShowAttachedComponents) {
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

      bool isCorrectAnswer = true;

      if (!isHeaderOfRandomComponents && !isHeaderOfExpandedComponents && !isHeaderOfShowAttachedComponents) { // skip the first one
        //var answerType = theComponentManager.getAnswerType(answeredPosition);

        if (answeredPosition != theComponentManager.getCorrectAnswerPosition()) {
          isCorrectAnswer = false;
        }

        if (!isCorrectAnswer) {
          //TODO: theStatisticsManager.incrementLessonQuizResult(false);
          result = getString(283)/*"Incorrect. "*/;
        }
        else {
          //TODO: theStatisticsManager.incrementLessonQuizResult(true);
          result = getString(284)/*"Correct. "*/;
        }
      }

      var buttonText = getString(285); // Continue
      //if (questionType != QuestionType.Component) {
      //  buttonText = getString(357); // Let's start
      //}
      result += buttonText;

      //_updateProgress();

      if (!isCorrectAnswer || isHeaderOfRandomComponents || isHeaderOfExpandedComponents || isHeaderOfShowAttachedComponents) {
        return Container(
          child: TextButton(
            child: Text(result + ' →',
              style: TextStyle(fontSize: 18.0 * getSizeRatioWithLimit(), color: Colors.blue),),
            //color: Colors.blueAccent, // Colors.brown,
            //textColor: Colors.white,
            onPressed: () {
              setState(() {
                runContinueLogic();
              });
            },
          ),
        );
      }
      else { // correct answer - will not happen actually
        //  setState(() {
        //    runContinueLogic();
        //  });
        return SizedBox(width: 0, height: 0);
      }
    }
    else {
      return SizedBox(width: 0, height: 0);
    }
  }

  Widget getPrevious(BuildContext context) {
    bool isHeaderOfRandomComponents = theComponentManager.isHeaderOfRandomComponents();
    bool isHeaderOfExpandedComponents = theComponentManager.isHeaderOfExpandedComponents();
    bool isHeaderOfShowAttachedComponents = theComponentManager.isHeaderOfShowAttachedComponents();

    var result = getString(405); // "Previous one"

    //skip the first real question
    if (currentIndex >= 1 /*|| (currentIndex == 0 && preIndexAtCurrentIndex0 >= 2)*/) {
      return Container(
        child: TextButton(
          child: Text(result,
            style: TextStyle(fontSize: 18.0 * getSizeRatioWithLimit(), color: Colors.blue),),
          //color: Colors.grey, // Colors.brown,
          //textColor: Colors.white,
          onPressed: () {
            setPositionState(AnswerPosition.continueNext);
            if (currentIndex > 0) { // in real component stage, not preIndex
              isFromPreviousButton = true; // ideally previous should be a AnswerPosition state
              previousButtonCount++;
            }
            theComponentManager.resetCorrectAnswerPosition();
            //answeredPosition = AnswerPosition.none;
            setState(() {
              if (currentIndex >= 1) {
                currentIndex = theComponentManager.getPreviousIndex();
              }
              //else if (currentIndex == 0 && preIndexAtCurrentIndex0 >= 2) {
              //  preIndexAtCurrentIndex0--;
              //}
            });
          },
        ),
      );
    }
    else { // correct answer - will not happen actually
      return SizedBox(width: 0, height: 0);
    }
  }

  runContinueLogic() {
    setPositionState(AnswerPosition.continueNext);
    // prepare for next one
    // Could be done in Build(), but Build won't allow showCompletedDialog() there.

    //if (questionType == QuestionType.Component && currentIndex == 0 && preIndexAtCurrentIndex0 < 6) {
    //  preIndexAtCurrentIndex0++;
    //}
    //else {
    currentIndex = theComponentManager.getNextIndex();
    //}

    theComponentManager.resetCorrectAnswerPosition();
    //}
    //if (theComponentManager.getCurrentType() == QuestionType.none) {
    if (currentIndex == -1) {
      theComponentManager.initCurrentIndex();
      showCompletedDialog(context);
    }
  }

  showCompletedDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(getString(286)/*"OK"*/, style: TextStyle(color: Colors.blue)),
      onPressed: () {
        theIsBackArrowExit = false;
        Navigator.of(context).pop(); // out of this dialog first
        Navigator.of(context).pop(); // then to the lesson page
        //Navigator.of(context, rootNavigator: true).pop();
        //Navigator.of(context).pop(); // TODO: not sure why have to add this?
      },
    );

    String title = '';
    String content = '';

    //if (correctPercent >= 70.0) {
    //  title = "Congratulation!";
    //  content = "You have passed this quiz with a score of " + corStr + "!";
    //}
    //else {

    /*
      if (questionType == QuestionType.ComponentGroup) {
        title = getString(115)/*"Good job!"*/;
        content = getString(287)/*"You’ve mastered all six Component groups! In the next exercise, you will memorize the Components in each group."*/;
        theNewlyCompletedTypingExercise = 1;
      }
      if (questionType == QuestionType.ComponentInGroup) {
        title = getString(115)/*"Good job!"*/;
        content = getString(133)/*"You remember the Components by group! In the next exercise, you will review the Components."*/;
        theNewlyCompletedTypingExercise = 2;
      }
     */
    String correctRatioString = totalCorrectAnswers.toString() + '/' + totalQuestions.toString() + "! ";


    if (questionType == QuestionType.Component) {
      title = getString(134)/*"Way to go!"*/;
      if (totalCorrectAnswers < 0) {
        totalCorrectAnswers = 0;
      }
      const int stepTwoTotalQuestions = 25;
      correctRatioString = totalCorrectAnswers.toString() + '/' + stepTwoTotalQuestions.toString() + "! ";
      content = totalCorrectAnswers.toString() + getString(628)/*' out of '*/ + stepTwoTotalQuestions.toString() + getString(629)/*' correct!'*/;
      //theNewlyCompletedTypingExercise = 0;
    }
    if (questionType == QuestionType.ExpandedComponent) {
      title = getString(136)/*"Wow!"*/;
      if (totalCorrectAnswers < 0) {
        totalCorrectAnswers = 0;
      }
      const int stepThreeTotalQuestions = 25;
      correctRatioString = totalCorrectAnswers.toString() + '/' + stepThreeTotalQuestions.toString() + "! ";
      content = totalCorrectAnswers.toString() + getString(628)/*' out of '*/ + stepThreeTotalQuestions.toString() + getString(629)/*' correct!'*/;
      //theNewlyCompletedTypingExercise = 2;
    }
    if (questionType == QuestionType.ShowAttachedComponent) {
      title = getString(391)/*"Wow!"*/;
      content = correctRatioString + getString(355)/*"You know your Attached Components! Let’s review it in next exercise."*/;
      //theNewlyCompletedTypingExercise = 7;
    }
    /*
    if (questionType == QuestionType.ReviewExpandedComponent) {
      title = getString(136)/*"Wow!"*/;
      content = getString(310)/*"You really know your Expanded Components! Let’s practice with some typing exercises."*/;
      theNewlyCompletedTypingExercise = 6;
    }
    */
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

    if (questionType == QuestionType.Component) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => TutorialCompleteDialog(
          title: getString(116), //'You Did It!',
          badgeText: getString(620), //'Step 2 Complete',
          message: content,
          buttonText: getString(621), //'More common components ->',
          mascotAsset: 'assets/core/mascot_green.png',
          onDone: () {
            Navigator.of(context).pop(); // dialog

            theIsBackArrowExit = false;
            Navigator.of(context).pop(); // InputZiPage
          },
        ),
      );
    }
    else if (questionType == QuestionType.ExpandedComponent) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => TutorialCompleteDialog(
          title: getString(625), //'Great Job!',
          badgeText: getString(626), //'Step 3 Complete',
          message: content,
          buttonText: getString(627), //'Start Hanzi Decomposition ->',
          mascotAsset: 'assets/core/mascot_green.png',
          onDone: () {
            Navigator.of(context).pop(); // dialog

            theIsBackArrowExit = false;
            Navigator.of(context).pop(); // InputZiPage
          },
        ),
      );
    }
    else {
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  void countModernCorrectAnswerIfNeeded(bool cameFromPrevious) {
    if (!wasLastQuestionEverIncorrect && !cameFromPrevious) {
      totalCorrectAnswers++;
    }
    else {
      wasLastQuestionEverIncorrect = false;
    }
  }

  Widget getModernKeyboardAnswer(AnswerPosition position) {
    if (position == AnswerPosition.none) {
      return SizedBox(width: 0, height: 0);
    }

    double ratio = getSizeRatioWithLimit();
    String answerDisplayValue = theComponentManager.getAnswerDisplayValue(position);

    Color borderColor = Color(0xFFD7E0EE);
    Color backgroundColor = Colors.white;
    Color textColor = Color(0xFF24344D);

    if (theComponentManager.isGroupOrIndividualAnswerType(answeredPosition)) {
      if (position == theComponentManager.getCorrectAnswerPosition()) {
        backgroundColor = Color(0xFFE8F7EE);
        borderColor = Color(0xFF34A853);
        textColor = Color(0xFF1E7A3B);
      } else if (position == answeredPosition) {
        backgroundColor = Color(0xFFFFECEC);
        borderColor = Color(0xFFE55353);
        textColor = Color(0xFFB3261E);
      }
    }

    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(backgroundColor),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0 * ratio),
            side: BorderSide(
              color: borderColor,
              width: 1.4,
            ),
          ),
        ),
        minimumSize: WidgetStateProperty.all(
          Size(56.0 * ratio, 56.0 * ratio),
        ),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {
        bool cameFromPrevious = isFromPreviousButton;
        AnswerPosition correctPosition = theComponentManager.getCorrectAnswerPosition();
        bool isCorrectAnswer = position == correctPosition;

        setPositionState(position);
        wasLastAnswerCorrect = isCorrectAnswer;

        if (isCorrectAnswer) {
          countModernCorrectAnswerIfNeeded(cameFromPrevious);
          setState(() {
            runContinueLogic();
          });
        }
        else {
          wasLastQuestionEverIncorrect = true;
        }

        isFromPreviousButton = false;
      },
      child: Text(
        theComponentManager.getKeyboardLetter(position) ?? '', //answerDisplayValue,
        style: TextStyle(
          fontSize: 26.0 * ratio,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }

/*
  Widget getPreLeadComponentCategory0(BuildContext context) {
    return Column(
        children: <Widget>[
          Row(
              children: <Widget>[
                Flexible(child: Text(
                    "'Mouth' component categories:",
                    style: TextStyle(fontSize: 15.0 * getSizeRatioWithLimit()), // 18
                    textAlign: TextAlign.start),),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 4.0 * getSizeRatioWithLimit()),
              ]
          ),
          Row(
              textDirection: TextDirection.ltr,
              //mainAxisSize: MainAxisSize.max,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(width: 30, height: 30,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text("Test Text 12"),
                  ),
                ),
                SizedBox(width: 2),
                Container(width: 30, height: 30,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text("Test Text 1234567"),
                  ),
                ),
                SizedBox(width: 2),
                Container(width: 30, height: 30,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text("Test Text 445 44"),
                  ),
                ),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 4.0 * getSizeRatioWithLimit()),
              ]
          ),
          Row(
              textDirection: TextDirection.ltr,
              //mainAxisSize: MainAxisSize.max,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(width: 30, height: 30,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text("Test Text 12"),
                  ),
                ),
                SizedBox(width: 2),
                Container(width: 30, height: 30,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text("Test Text 1234567"),
                  ),
                ),
                SizedBox(width: 2),
                Container(width: 30, height: 30,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text("Test Text 445 44"),
                  ),
                ),
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
                Container(width: 30, height: 30,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text("Test Text 12"),
                  ),
                ),
                SizedBox(width: 2),
                Container(width: 30, height: 30,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text("Test Text 1234567"),
                  ),
                ),
                SizedBox(width: 2),
                Container(width: 30, height: 30,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text("Test Text 445 44"),
                  ),
                ),
              ]
          ),
          Row(
              children: <Widget>[
                SizedBox(height: 4),
              ]
          ),
        ]
    );
  }
  */


}


class StepThreeBurstPainter extends CustomPainter {
  final bool flip;

  StepThreeBurstPainter({required this.flip});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0xFFFFA000)
      ..strokeWidth = size.width * 0.10
      ..strokeCap = StrokeCap.round;

    double direction = flip ? -1.0 : 1.0;
    double centerX = flip ? size.width * 0.35 : size.width * 0.65;
    double endX = flip ? size.width * 0.78 : size.width * 0.22;

    canvas.drawLine(
      Offset(centerX, size.height * 0.50),
      Offset(endX, size.height * 0.50),
      paint,
    );
    canvas.drawLine(
      Offset(centerX, size.height * 0.36),
      Offset(centerX + direction * size.width * 0.34, size.height * 0.18),
      paint,
    );
    canvas.drawLine(
      Offset(centerX, size.height * 0.64),
      Offset(centerX + direction * size.width * 0.34, size.height * 0.82),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant StepThreeBurstPainter oldDelegate) {
    return oldDelegate.flip != flip;
  }
}

class StepTwoKeyCubePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width * 0.50;
    final double d = size.width * 0.22;

    final double x = size.width * 0.18;
    final double y = size.height * 0.28;

    final Offset frontTL = Offset(x, y);
    final Offset frontTR = Offset(x + s, y);
    final Offset frontBR = Offset(x + s, y + s);
    final Offset frontBL = Offset(x, y + s);

    final Offset backTL = Offset(x + d, y - d * 0.62);
    final Offset backTR = Offset(x + s + d, y - d * 0.62);
    final Offset backBR = Offset(x + s + d, y + s - d * 0.62);

    final Paint shadowPaint = Paint()
      ..color = const Color(0x3324344D)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16.0);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.52, y + s + d * 0.38),
        width: size.width * 0.62,
        height: size.height * 0.14,
      ),
      shadowPaint,
    );

    _drawFace(
      canvas,
      <Offset>[frontTR, backTR, backBR, frontBR],
      <Color>[const Color(0xFF55C7F7), const Color(0xFF2F80ED)],
    );

    _drawFace(
      canvas,
      <Offset>[frontTL, frontTR, backTR, backTL],
      <Color>[const Color(0xFFFFF2A8), const Color(0xFFFFCF5C)],
    );

    _drawFace(
      canvas,
      <Offset>[frontTL, frontTR, frontBR, frontBL],
      <Color>[const Color(0xFFFFBE55), const Color(0xFFFF8F3D)],
    );

    final Paint edgePaint = Paint()
      ..color = Colors.white.withOpacity(0.70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    canvas.drawPath(_pathFromPoints(<Offset>[frontTL, frontTR, frontBR, frontBL]), edgePaint);
    canvas.drawPath(_pathFromPoints(<Offset>[frontTR, backTR, backBR, frontBR]), edgePaint);
    canvas.drawPath(_pathFromPoints(<Offset>[frontTL, frontTR, backTR, backTL]), edgePaint);

    _drawCenteredText(canvas, '木', Rect.fromPoints(frontTL, frontBR), s * 0.52);
    _drawCenteredText(
      canvas,
      'M',
      Rect.fromLTRB(frontTR.dx, frontTR.dy, backBR.dx, backBR.dy),
      s * 0.44,
    );
  }

  void _drawCenteredText(Canvas canvas, String text, Rect rect, double fontSize) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          shadows: const <Shadow>[
            Shadow(
              color: Color(0x5524344D),
              offset: Offset(0, 3),
              blurRadius: 4,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    painter.paint(
      canvas,
      Offset(
        rect.center.dx - painter.width / 2,
        rect.center.dy - painter.height / 2,
      ),
    );
  }

  void _drawFace(Canvas canvas, List<Offset> points, List<Color> colors) {
    final Rect bounds = _boundsFromPoints(points);
    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ).createShader(bounds);

    canvas.drawPath(_pathFromPoints(points), paint);
  }

  Path _pathFromPoints(List<Offset> points) {
    final Path path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    return path;
  }

  Rect _boundsFromPoints(List<Offset> points) {
    double left = points.first.dx;
    double right = points.first.dx;
    double top = points.first.dy;
    double bottom = points.first.dy;

    for (final Offset p in points) {
      if (p.dx < left) left = p.dx;
      if (p.dx > right) right = p.dx;
      if (p.dy < top) top = p.dy;
      if (p.dy > bottom) bottom = p.dy;
    }

    return Rect.fromLTRB(left, top, right, bottom);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

