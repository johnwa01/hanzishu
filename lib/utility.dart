import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/zi.dart';
import 'package:flutter/material.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/localization/string_en_US.dart';
import 'package:hanzishu/localization/string_zh_CN.dart';

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
  Conversation,
  ConversationSnowball,
  Typing,
  Quiz,
  None
}

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

String getString(int id) {
  // according to theDefaultLocale
  String localString;
  switch (theDefaultLocale) {
    case "en_US":
      {
        localString = theString_en_US[id].str;
      }
      break;
    case "zh_CN":
      {
        localString = theString_zh_CN[id].str;
      }
      break;
    default:
      {
        localString = theString_en_US[id].str;
      }
      break;
  }

  return localString;
}

class Utility {
  static var baseNumber = 10000;
  static var componentBaseNumber = 9000;
  static var searchingBaseNumber = 4600;
  static var searchingZiListRealZiStart = 52;
  static var searchingZiListNonZiPseudoZiStart = 27;

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

  static String getFirstPinyin(String backslashSeparatedPinyins) {
    var delimiter = "/";
    var token = backslashSeparatedPinyins.split(delimiter);
    return token[0];
  }

  static String adjustPinyinSpace(pinyin) {
    String updatedPinyin = '';
    var delimiter = ' ';
    var token = pinyin.split(delimiter);
    int length;
    for (int i = 0; i < token.length; i++) {
      length = token[i].length;

      switch (length) {
        case 1:
          updatedPinyin += '  ';
          updatedPinyin += token[i];
          updatedPinyin += '  ';
          break;
        case 2:
          updatedPinyin += ' ';
          updatedPinyin += token[i];
          updatedPinyin += '  ';
          break;
        case 3: // place holder case of '999' string
          updatedPinyin += ' ';
          if (token[i] == "999") {
            updatedPinyin += "     ";
          }
          else {
            updatedPinyin += token[i];
          }
          updatedPinyin += ' ';
          break;
        case 4:
          //updatedPinyin += ' ';
          updatedPinyin += token[i];
          updatedPinyin += ' ';
          break;
        case 5:
          updatedPinyin += token[i];
          updatedPinyin += ' ';
          break;
        case 6:
          updatedPinyin += token[i];
          updatedPinyin += ' ';
          break;
        default:
          break;
      }
    }

    return updatedPinyin;
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

  // use getScreenWidthForTreeAndDict() if a page needs to consider the height factor.
  static double getScreenWidth(BuildContext context) {
    var screenSize = MediaQuery
        .of(context)
        .size;
    //var height = screenSize.height;
    double screenWidth = screenSize.width;
//    thePositionManager.setFrameWidth(screenWidth - 10.0); //TODO: with exclusion of tree/dict, no need for this anymore?

    return screenWidth;
  }

  // These two cases need to display the whole thing. And Conversation page as well.
  static double getScreenWidthForTreeAndDict(BuildContext context) {
    var screenSize = MediaQuery
        .of(context)
        .size;

    var ratio = screenSize.height / screenSize.width;
    double screenWidth;
    if (ratio >= 1.6) {
      // actual size
      screenWidth = screenSize.width;
    }
    else {
      // make width shorter than actual to have enough space to displace the whole tree frame
      screenWidth = screenSize.width * ratio / 1.6;
    }

    thePositionManager.setFrameWidth(screenWidth - 10.0); //TODO

    return screenWidth;
  }

  // Note: assume screenWidth has considered the height to screen ratio already, that is, might be narrowed areadly
  //       from the actual screen size if height to width ratio is lower than the minimum.
  static double getSizeRatio(double screenWidth) {
    return screenWidth / 392.0;

    //var defaultFontSize = screenWidth / 16.0;
    //return defaultFontSize / 25.0; // ratio over original hard coded value I took as the standard in Android.
    // that is, roughtly screen size 392 is the standard.
  }

  /*
  static double getSizeRatioWithLimit(double screenWidth) {
    var ratio = screenWidth / 392.0;
    if (ratio > 1.7) {   // control the value for really wide case in consideration of height
      ratio /= 1.3;
    }

    return ratio;
    //var defaultFontSize = screenWidth / 16.0;
    //return defaultFontSize / 25.0; // ratio over original hard coded value I took as the standard in Android.
    // that is, roughtly screen size 392 is the standard.
  }
  */

  static double getSizeRatioWithLimit(double screenWidth) {
    var ratio = screenWidth / 392.0;
    if (ratio > 1.5) {   // control the value for really wide case in consideration of height
      ratio = 1.5;
    }

    return ratio;
  }

  static int sameStartSubstring(String first, String second) {
    int minLength = (first.length < second.length) ? first.length : second.length;

    for (int i = 0; i < minLength; i++) {
      if (first[i] != second[i]) {
        return i;
      }
    }

    return minLength;
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
    else if (listType == ZiListType.custom) {
      return breakoutIndex * baseNumber + id;
    }
    else if (listType == ZiListType.component) {
      return breakoutIndex * baseNumber + componentBaseNumber + id;
    }

    return -1;
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

  /*
  static bool isPseudoRootZiId(int rootZiId) {
    return (rootZiId >= 741 && rootZiId <= 749) ||
        (rootZiId == 751) /*|| (rootZiId == 756)*/;
  }

  static bool isPseudoRootZiIdPlusStar(int rootZiId) {
    return isPseudoRootZiId(rootZiId) || (rootZiId == TheConst.starCharId);
  }

  static bool isPseudoNonCharRootZiId(int rootZiId) {
    return (rootZiId >= 731 && rootZiId <= 740) || (rootZiId == 750) ||
        (rootZiId >= 752 && rootZiId <= 755);
  }

  static bool isPseudoNonCharRootZiIdPlusStar(int rootZiId) {
    return isPseudoNonCharRootZiId(rootZiId) ||
        (rootZiId == TheConst.starCharId);
  }
  */

  static bool isSearchingPseudoZiId(int rootZiId) {
    return (rootZiId >= 3 && rootZiId < searchingZiListRealZiStart); //TODO: finalize it
  }

  static bool isSearchingNonZiPseudoZiId(int rootZiId) {
    return (rootZiId >=  searchingZiListNonZiPseudoZiStart && rootZiId < searchingZiListRealZiStart); //TODO: finalize it
  }

  static bool isStarChar(int rootZiId) {
    return (rootZiId == TheConst.starCharId);
  }

  static bool isAtChar(int rootZiId) {
    return (rootZiId == TheConst.atCharId);
  }

  static bool specialChar(String char) {
    return char == '！' || char == '？' || char == '。' || char == '，' || char == '`' || char == '、' ||
        char == '!' || char == '?' || char == '.' || char == ',' || char == '【' || char == '】' ||
        char == ':' || char == '：' || char == ';' || char == '；' || char == ' ';
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

  // a longer string of stringToBeSet, with first part being replaced by subString
  static String replacePartOfString(String stringToBeSet, String subString) {
    return subString + stringToBeSet.substring(subString.length);
  }

  static String checkAndUpdateOneCharSideForLessonTwo(int id, String displaySideString) {
    // do special for '六' for lesson 2 so that it'll order sequencially in screen
    if (theCurrentLessonId == 2 && id == 155) {
      return "b"; // is 'u' regularly
    }
    else {
      return displaySideString;
    }
  }

  // count max of three for now. need recursive one otherwise.
  static int substringCountMaxThree(String str, String sub) {
    int count = 0;
    var  indexStart = str.indexOf(sub);
    if (indexStart > 0) {
      count += 1;

      if (indexStart < str.length - 1) {
        var indexStart2 = str.indexOf(sub, indexStart + 1);
        if (indexStart2 > 0) {
          count += 1;

          if (indexStart2 < str.length - 1) {
            var indexStart3 = str.indexOf(sub, indexStart2 + 1);
            if (indexStart3 > 0) {
              count += 1;
            }
          }
        }
      }
    }

    return count;
  }

  static bool isArrow(String input) {
    if(input == '<' || input == '>') {
      return true;
    }

    return false;
  }

  static bool isForwardArrow(String input) {
    if(input == '>') {
      return true;
    }

    return false;
  }

  static bool isBackArrow(String input) {
    if(input == '<') {
      return true;
    }

    return false;
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
  double yPosi = 0.0;

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

class SpeechIconInfo {
  ZiListType type = ZiListType.zi; // assign a default type
  int id = -1;
  double xPosi = 0.1;
  double yPosi = 0.0;

  SpeechIconInfo(ZiListType type, int id, double xPosi, double yPosi) {
    this.type = type;
    this.id = id;
    this.xPosi = xPosi;
    this.yPosi = yPosi;
  }
}
