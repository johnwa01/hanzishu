import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/zi.dart';
import 'package:hanzishu/engine/generalmanager.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

enum HittestState {
  hanzishuLesson,
  quizShu,
  quizShuLesson,
  ziAndSidingShu,
  ziAndSidingShuLesson,
  meaningQuiz,
  pinyinQuiz,
  lessons,
  lesson,
  lessonConversation,
  lessonPinyin,
  lessonTopics,
  lessonZiDissembly,
  lessonZiAssembly,
  lessonZiOrigin,
  lessonTreeResults,
  lessonQuizResults,
  hanzishuModes,
  hanzishuQuizMode,
  hanzishuZiAndSidingMode,
  hanzishuFullZiMode,
  me,
  meQuizResults,
  meTapCount,
  meStudyTime,
  meTerminology,
  lessonNewQuiz
}

enum CornerRadius {
  none,
  tiny,
  small,
  medium,
  large
}

enum LessonPart {
  conversation,
  ziDissembly
}

enum LessonLevel {
  beginner,
  intermediate,
  unknown
}

enum LessonSection {
  FullCharacterTree,
  Characters,
  Decomposing,
  Assembling,
  Conversation,
  Quiz,
  None
}

//TODO: not used anymore?
/*
enum ColorType {
  inactive,
  latest,
  completed
}
*/

// Note: each lesson uses its lessonId directly
/*
enum ButtonTag {
  LessonBase = 0,
  MaxLessonCapacity = 499,
  QuizQuestion = 500,
  QuizAnswer1 = 501,
  QuizAnswer2 = 502,
  QuizAnswer3 = 503,
  QuizBackToLesson = 504,
  QuizContinue = 505,
  QuizProgressFrame = 506,
  QuizProgressBar = 507,
  QuizProgressBarExit = 508,
  Characters = 520,
  Review = 521,
  Analyze = 522,
  Conversations = 523,
  Quiz = 524,
  ReviewTree = 525,
  AllLessons = 526,
  StudyTime = 527,
  TapCount = 528,
  QuizResults = 529,
  AnnotateCenter = 530,
  AnnotateZiBase = 10000  // base number for annotate zi
}
*/


class CharType {
  static const BasicChar = "j";
  static const BasicNonchar = "f";
  static const CompositChar = "h";
  static const Phrase = "p";
}

class ButtonTag {
  static const LessonBase = 0;
  static const MaxLessonCapacity = 499;
  static const QuizQuestion = 500;
  static const QuizAnswer1 = 501;
  static const QuizAnswer2 = 502;
  static const QuizAnswer3 = 503;
  static const QuizBackToLesson = 504;
  static const QuizContinue = 505;
  static const QuizProgressFrame = 506;
  static const QuizProgressBar = 507;
  static const QuizProgressBarExit = 508;
  static const Characters = 520;
  static const Review = 521;
  static const Analyze = 522;
  static const  Conversations = 523;
  static const Quiz = 524;
  static const ReviewTree = 525;
  static const  AllLessons = 526;
  static const StudyTime = 527;
  static const TapCount = 528;
  static const QuizResults = 529;
  static const  AnnotateCenter = 530;
  static const  AnnotateZiBase = 10000;  // base number for annotate zi
}

enum ButtonBackgroundType {
  QuizAnswerItemColor,
  QuizNonAnswerItemColor,
  QuizProgressColor,
  LessonImage,
  LessonTreeImage,
  LessonReviewImage,
  LessonAnalyzeImage,
  LessonConversationImage,
  LessonQuizImage,
  None
}

class ScreenManager {
  //static let iPhone7Width = 375

  static var screenWidth = 375; //UIScreen.main.bounds.width
  static var screenHeight = 600; //UIScreen.main.bounds.height
  //static var iconAreaHeight = XYLength(CGFloat(55.0))
  //static var statusBarHeight = XYLength(CGFloat(30.0))

  //var frameWidth: CGFloat
  //var topEdgeSize: CGFloat
  //var titleX: CGFloat
  //var titleY: CGFloat

  //init() {
  //frameWidth = ScreenManager.screenWidth - XYLength(CGFloat(10.0))  //20.0
  //topEdgeSize = theTreeTopEdgePosi //CGFloat(72.0) // CGFloat(55.0)
  //titleX = ScreenManager.screenWidth * 0.25 //0.15 //0.20 //0.33
  //titleY = XYLength(40.0) //23.0

  //if (ScreenManager.screenWidth < CGFloat(ScreenManager.iPhone7Width)) {
  //frameWidth = ScreenManager.screenWidth * (ScreenManager.screenWidth / CGFloat(ScreenManager.iPhone7Width)) - XYLength(CGFloat(8.0))
  //}

  //if (ScreenManager.screenWidth > CGFloat(ScreenManager.iPhone7Width)*1.4) {
  //var rate = ScreenManager.screenWidth / CGFloat(ScreenManager.iPhone7Width)
  //if (rate > 1.4) {
  //rate = 1.4
  //}

  //frameWidth = ScreenManager.screenWidth / rate - XYLength(CGFloat(8.0))
  //}
  //}

  //func getTopEdgeSize() ->CGFloat {
  //return topEdgeSize
  //}

  //func getTitleX() ->CGFloat {
  //return titleX
  //}

  //func getTitleY() ->CGFloat {
  //return titleY
  //}

  //func getFrameWidth() ->CGFloat {
  //return frameWidth
  //}

  //func getIconAreaEdgeY() ->CGFloat {
  //return ScreenManager.screenHeight - ScreenManager.iconAreaHeight
  //}

  //func getInstructionStartX1() ->CGFloat {
  //return (ScreenManager.screenWidth - theScreenManager.frameWidth ) / 2.0 + theScreenManager.frameWidth / 8.5
  //}

  //func getInstructionStartX2() ->CGFloat {
  //return (ScreenManager.screenWidth - theScreenManager.frameWidth ) / 2.0 + theScreenManager.frameWidth / 5.5
  //}

  //func getInstructionStartY1() ->CGFloat {
  //return topEdgeSize + (theFrameHeightY / 12.0)
  //}

  //func getInstructionStartY2() ->CGFloat {
  //return topEdgeSize + (theFrameHeightY * 5.0 / 6.5)
  //}
}

// adjusted length according to iPhone 8 Plus length which is used in
// my initial design, they are screen width=414.0 and screen height=736.0
// Only use screen width as reference and don't use screen height.
double XYLength(double length){
  return ScreenManager.screenWidth / 414.0 * length;
}

class Utility {
  static void speakChars(String chars, String lang) {
  // skip the special root char
    //TODO
    /*
    if (chars != "~") {
      var utterance = AVSpeechUtterance(chars);
      utterance.voice = AVSpeechSynthesisVoice(lang); //en-US zh-CN
      var synthesizer = AVSpeechSynthesizer();
      synthesizer.speak(utterance);
    }
    */
  }

  static String getFirstMeaning(String semiCommaSeparatedMeanings) {
    var delimiter = ";";
    //var token = semiCommaSeparatedMeanings.components(delimiter);
    var token = semiCommaSeparatedMeanings.split(delimiter);
    return token[0];
  }

  //TODO: rename to StringToDouble when everything has been tested
  static double StringToFloat(String str)
  {
    return double.parse(str);
    //return CGFloat(NumberFormatter().number(from: str));
  }

  static int StringToInt(String str) {
    return int.parse(str);
    //return int(str);
  }

  static void checkAndSetSkipLevelZiCompletion(int fromId, int toId)
  {
    if (fromId == toId) {
      return;
    }

    var fromZi = theZiManager.getZi(fromId);
    var toZi = theZiManager.getZi(toId);

    if (toZi.parentId == fromId || fromZi.parentId == toId) {
      if (fromZi.parentId == toId) {
        thePreviousCenterZiId = fromZi.id;
      }

      return;
    }

    //toId must be skip level parent of fromId in navigation tree. check through the chain
    var navigationZiId = fromId;
    Zi navigationZi;
    do {
        GeneralManager.checkAndSetHasAllChildrenCompleted(navigationZiId, theHittestState, theCurrentLessonId);
        navigationZi = theZiManager.getZi(navigationZiId);
        navigationZiId = navigationZi.parentId;
        if (navigationZiId == toId) {
          thePreviousCenterZiId = navigationZi.id;
        }
    } while (navigationZiId != toId);
  }

  static double getScreenWidth(BuildContext context) {
    var screenSize = MediaQuery
        .of(context)
        .size;
    //var height = screenSize.height;
    double screenWidth = screenSize.width; //401; //TODO
    thePositionManager.setFrameWidth(screenWidth - 10.0); //TODO

    return screenWidth;
  }
}

//TODO: check - this is not used anymore I think.
/*
extension UIColor {
  UIColor lighter(by percentage: CGFloat = 30.0) {
    return this.adjust(by: abs(percentage));
  }

  UIColor darker(by percentage: CGFloat = 30.0) {
    return this.adjust(by: -1 * abs(percentage));
  }

  UIColor adjust(by percentage: CGFloat = 30.0) {
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0;
    if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
      return UIColor(red: min(red + percentage/100, 1.0),
        green: min(green + percentage/100, 1.0),
        blue: min(blue + percentage/100, 1.0),
        alpha: alpha);
      }
    else {
      return null;
    }
  }
}
*/

class MyString {
  String str = '';
  MyString(this.str);
}

class PrimitiveWrapper {
  var value;
  PrimitiveWrapper(this.value);
}

/*
/// The material design primary color swatches, excluding grey.
static const List<MaterialColor> primaries = <MaterialColor>[
  red,
  pink,
  purple,
  deepPurple,
  indigo,
  blue,
  lightBlue,
  cyan,
  teal,
  green,
  lightGreen,
  lime,
  yellow,
  amber,
  orange,
  deepOrange,
  brown,
  // The grey swatch is intentionally omitted because when picking a color
  // randomly from this list to colorize an application, picking grey suddenly
  // makes the app look disabled.
  blueGrey,
];
*/

double xYLength(double xy) {
  return xy;
}