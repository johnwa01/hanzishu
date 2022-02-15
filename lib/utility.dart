import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/zi.dart';
import 'package:hanzishu/engine/generalmanager.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/engine/zimanager.dart';

/*
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
*/

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
  Typing,
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

  //static double Android3Width = 392.72727272727275;
  //static double Android3Height = 737.4545454545455;
}

// adjusted length according to iPhone 8 Plus length which is used in
// my initial design, they are screen width=414.0 and screen height=736.0
// Only use screen width as reference and don't use screen height.
//double XYLength(double length){
//  return ScreenManager.screenWidth / 414.0 * length;
//}

// need to use the less ratio one of the x and y ratios
double xYLength(double xy) {
  return xy; //* theDrawingSizeRatio;
}

class Utility {
  static var baseNumber = 10000;
  static var componentBaseNumber = 9000;
  static var searchingBaseNumber = 4600;

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
  static double StringToFloat(String str) {
    return double.parse(str);
    //return CGFloat(NumberFormatter().number(from: str));
  }

  static int StringToInt(String str) {
    if (str != null && str.length > 0) {
      return int.parse(str);
    }

    return -1;
  }

  //TODO: missing an actual check below in case we need this function.
  // and should move to basepainter.dart
  static void checkAndSetSkipLevelZiCompletion(int fromId, int toId) {
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
      //TODO: do the actual check. GeneralManager.checkAndSetHasAllChildrenCompleted(navigationZiId, theHittestState, theCurrentLessonId);
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
    double screenWidth = screenSize.width;
    thePositionManager.setFrameWidth(screenWidth - 10.0); //TODO

    return screenWidth;
  }

  /*
  static double getDrawingSizeRatio(BuildContext context) {
    var screenSize = MediaQuery
        .of(context)
        .size;
    var widthRatio = screenSize.width / ScreenManager.Android3Width;
    var heightRatio = screenSize.height / ScreenManager.Android3Height;

    return min(widthRatio, heightRatio);
  }

  // untested
  static double getScreenWidthForTreeFrameAndDict(BuildContext context) {
    var screenSize = MediaQuery
        .of(context)
        .size;

    var defaultRatio = ScreenManager.Android3Height / ScreenManager.Android3Width; // 1.877778
    var currentRatio = screenSize.height / screenSize.width;

    if (currentRatio < 1.6) {  // Android3's ratio has a bit of buffer space
      return screenSize.width * currentRatio / defaultRatio; // narrow the width a bit so that enough height will show
    }

    return screenSize.width;
  }
  */

  static int getUniqueNumberFromId(int breakoutIndex, int id, ZiListType listType) {
    if (listType == ZiListType.zi) {
      return breakoutIndex * baseNumber + id;
    }
    if (listType == ZiListType.searching) {
      return breakoutIndex * baseNumber + searchingBaseNumber + id;
    }
    else if (listType == ZiListType.component) {
      return breakoutIndex * baseNumber + componentBaseNumber + id;
    }
  }

  static int getIdFromUniqueNumber(int uniqueNumber) {
    var afterBaseNumber = uniqueNumber % baseNumber;
    if (afterBaseNumber >= componentBaseNumber) {
      return afterBaseNumber % componentBaseNumber;
    }
    else {
      return afterBaseNumber % searchingBaseNumber;
    }
  }

  static ZiListType getListType(int uniqueNumber, int id) {
    var base = uniqueNumber - id;
    var baseMod = base % baseNumber;

    if (baseMod < searchingBaseNumber) {
      return ZiListType.zi;
    }
    else if (baseMod >= searchingBaseNumber && baseMod < componentBaseNumber) {
      return ZiListType.searching;
    }
    else {
      return ZiListType.component;
    }
  }

  static bool isPseudoRootZiId(int rootZiId) {
    return (rootZiId >= 741 && rootZiId <= 749) ||
        (rootZiId == 751) /*|| (rootZiId == 756)*/;
  }

  static bool isPseudoRootZiIdPlusStar(int rootZiId) {
    return isPseudoRootZiId(rootZiId) || (rootZiId == theConst.starCharId);
  }

  static bool isPseudoNonCharRootZiId(int rootZiId) {
    return (rootZiId >= 731 && rootZiId <= 740) || (rootZiId == 750) ||
        (rootZiId >= 752 && rootZiId <= 755);
  }

  static bool isPseudoNonCharRootZiIdPlusStar(int rootZiId) {
    return isPseudoNonCharRootZiId(rootZiId) ||
        (rootZiId == theConst.starCharId);
  }

  static bool isStarChar(int rootZiId) {
    return (rootZiId == theConst.starCharId);
  }

  static bool isAtChar(int rootZiId) {
    return (rootZiId == theConst.atCharId);
  }

  static bool specialChar(String char) {
    return char == '！' || char == '？' || char == '。' || char == '，' ||
        char == '!' || char == '?' || char == '.' || char == ',';
  }

  static bool isALowerCaseLetter(String value) {
    if(value.length > 0) {
      var charCodeUnits = value[0].codeUnits;

      if (charCodeUnits.length == 1 && charCodeUnits[0] >= 97 && charCodeUnits[0] <= 122 ) {  // value is between a and z
        return true;
      }
    }

    return false;
  }

  static bool isAUpperCaseLetter(String value) {
    if(value.length > 0) {
      var charCodeUnits = value[0].codeUnits;

      if (charCodeUnits.length == 1 && charCodeUnits[0] >= 65 && charCodeUnits[0] <= 90 ) {  // value is between a and z
        return true;
      }
    }

    return false;
  }

  static int findSeparationCount(String convWithSeparation, int startingPosi) {
    int count = 1;

    for (int i = startingPosi + 1; i < convWithSeparation.length; i++) {
      var oneChar = convWithSeparation[i];
      if ((oneChar != "|") && (oneChar != "｜") && !specialChar(oneChar)) {
        count++;
      }
      else {
        break;
      }
    }

    return count;
  }

  static double adjustOverlayXPosition(double xPosi, double screenWidth) {
    var diff = screenWidth - xPosi;
    double adjustedValue = xPosi;

    if (diff < 20.0) {
      adjustedValue -= 160.0;
    }
    else if (diff < 40.0) {
      adjustedValue -= 140.0;
    }
    else if (diff < 60.0) {
      adjustedValue -= 120.0;
    }
    else if (diff < 80.0) {
      adjustedValue -= 100.0;
    }
    else if (diff < 100.0) {
      adjustedValue -= 80.0;
    }
    else if (diff < 120.0) {
      adjustedValue -= 60.0;
    }
    else if (diff < 140.0) {
      adjustedValue -= 40.0;
    }
    else if (diff < 160.0) {
      adjustedValue -= 20.0;
    }

    return adjustedValue;
  }

  static String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
  }
  // var newStr = replaceCharAt("hello", 1, "E") //usage
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

/*
class PrimitiveWrapper {
  double value;
  PrimitiveWrapper(double value) {
    this.value = value;
  }
}
*/

// for int and double
class PrimitiveWrapper {
  var value;
  PrimitiveWrapper(var value) {
    this.value = value;
  }
}

//TODO: merge to the above one
class YPositionWrapper {
  double yPosi;

  YPositionWrapper(double yPosi) {
    this.yPosi = yPosi;
  }
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

