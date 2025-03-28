import 'package:hanzishu/engine/thirdpartylesson.dart';
import 'package:hanzishu/data/thirdpartylessonlist.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';

enum ThirdPartyType {
  yuwen,
  sunlaoshi,
  yuwenAll,
  none
}

class ThirdParty {
  ThirdPartyType thirdPartyType = ThirdPartyType.none;
  int nameStringId = -1;

  ThirdParty(ThirdPartyType thirdPartyType,
      int nameStringId,) {
    this.thirdPartyType = thirdPartyType;
    this.nameStringId = nameStringId;
  }

  static String? getThirdPartyName(ThirdPartyType thirdPartyType) {
    for (int i = 0; i < theThirdPartyList.length; i++) {
      if (theThirdPartyList[i].thirdPartyType == thirdPartyType) {
        return getString(theThirdPartyList[i].nameStringId);
      }
    }

    return null;
  }

  static String getStringFromCode(String code) {
    String stringType = code.substring(0, 1);
    String indexString = code.substring(1);
    int index = Utility.StringToInt(indexString);

    String wholeString = '';

    switch (stringType) {
      case "k":
        {
          wholeString = getString(499) + " " + indexString;
        }
        break;
      case "s":
        {
          wholeString = getString(498) + " " + indexString;
        }
        break;
      case "t":
        {
          String subIndexLetter = '';
          if (index == 1) {
            subIndexLetter = 'A';
          }
          if (index == 2) {
            subIndexLetter = 'B';
          }
          wholeString = getString(520) + " 1"  + subIndexLetter;
        }
        break;
      case "l":
        {
          String gradeString = getString(496);
          String whichHalfString = getString(497);

          int grade = ((index + 1) / 2).toInt();
          if (theDefaultLocale == "en_US") { //zh_CN
            wholeString = gradeString + " " + grade.toString() + " ";
          }
          else {
            wholeString = grade.toString() + " " + gradeString + " ";
          }
          int whichHalf = index % 2;
          if (whichHalf == 1) {
            if (theDefaultLocale == "en_US") { //zh_CN
              wholeString += "First" + " " + whichHalfString;
            }
            else {
              wholeString += "上" + whichHalfString;
            }
          }
          else {
            if (theDefaultLocale == "en_US") { //zh_CN
              wholeString += "Second" + " " + whichHalfString;
            }
            else {
              wholeString += "下" + whichHalfString;
            }
          }
        }
        break;
      case "m":
        {
          int unit = ((index + 1) / 2).toInt();
          int lesson = index % 2;
          if (lesson == 0) {
            lesson = 2;
            wholeString =
                '            ' + getString(295) +
                    ' ' + lesson.toString();
          }
          else {
            wholeString = getString(9) + ' ' + unit.toString() + ' ' + getString(295) +
                    ' ' + lesson.toString();
          }
        }
        break;
    }

    return wholeString;
  }
}

class ThirdPartyLevel {
  ThirdPartyType thirdPartyType = ThirdPartyType.none;
  String version = '';
  int levelId = -1;
  String levelNameCode = '';  // 'a1', 'b3' etc
  //int startingLessonId;

  ThirdPartyLevel(ThirdPartyType thirdPartyType,
      String version,
      int levelId,
      String levelNameCode) {
    this.thirdPartyType = thirdPartyType;
    this.version = version;
    this.levelId = levelId;
    this.levelNameCode = levelNameCode;
    //this.startingLessonId = startingLessonId;
  }

  static String? getLevelName(ThirdPartyType thirdPartyType, String version, int levelId) {
    for (int i = 0; i < theThirdPartyLevelList.length; i++) {
      if (theThirdPartyLevelList[i].thirdPartyType == thirdPartyType && theThirdPartyLevelList[i].version == version && theThirdPartyLevelList[i].levelId == levelId) {
        String versionStr = ThirdParty.getStringFromCode(theThirdPartyLevelList[i].levelNameCode);
        if (version.length > 0) {
          versionStr += ' (' + version + ')';
        }
        return versionStr;
      }
    }

    return null;
  }
}

class ThirdPartyLesson {
  ThirdPartyType thirdPartyType = ThirdPartyType.none;
  String version = '';
  int levelId = -1;
  int lessonId = -1;
  String lessonNameCode = ''; // 'a1', 'c4' etc
  String newChars = '';
  String content = '';
  static int currentContentIndex = -1;

  //int currentWordIndex = -1;
  int realWordsLength = -1;

  ThirdPartyLesson(ThirdPartyType thirdPartyType,
      String version,
      int levelId,
      int lessonId,
      String lessonNameCode,
      String newChars,
      String content) {
    this.thirdPartyType = thirdPartyType;
    this.version = version;
    this.levelId = levelId;
    this.lessonId = lessonId;
    this.lessonNameCode = lessonNameCode;
    this.newChars = newChars;
    this.content = content;
  }

  static String? getLessonName(ThirdPartyType thirdPartyType, String version, int lessonId) {
    for (int i = 0; i < theThirdPartyLessonList.length; i++) {
      if (theThirdPartyLessonList[i].thirdPartyType == thirdPartyType  && theThirdPartyLessonList[i].version == version && theThirdPartyLessonList[i].lessonId == lessonId) {
        if (thirdPartyType == ThirdPartyType.yuwen || thirdPartyType == ThirdPartyType.sunlaoshi) { // these two are older mechanism
          return ThirdParty.getStringFromCode(theThirdPartyLessonList[i].lessonNameCode);
        }
        else {
          return /*version + ' ' +*/ theThirdPartyLessonList[i].lessonNameCode;
        }
      }
    }

    return null;
  }

  static String getLessonString(ThirdPartyType thirdPartyType, int lessonId) {
    String lessonString = '';
    var fieldLessonId;
    if (thirdPartyType == ThirdPartyType.yuwen) {
      for (int i = 0; i < theSearchingZiList.length; i++) {
        switch (thirdPartyType) {
          case ThirdPartyType.yuwen:
            {
              fieldLessonId = theSearchingZiList[i].lessonYuwen;
            }
            break;
        }

        if (fieldLessonId == lessonId) {
          lessonString += theSearchingZiList[i].char;
        }
      }
    }
    else if (thirdPartyType == ThirdPartyType.sunlaoshi) {
      lessonString = getContent(ThirdPartyType.sunlaoshi, lessonId);
    }

    return lessonString;
  }

  static void setThirdPartyTypeAndLessonId(ThirdPartyType thirdPartyType, int lessonId) {
    for (int i = 0; i < theThirdPartyLessonList.length; i++) {
      if (thirdPartyType == theThirdPartyLessonList[i].thirdPartyType && theThirdPartyLessonList[i].lessonId == theThirdPartyLessonList[lessonId - 1].lessonId) {
        currentContentIndex = i;
        break;
      }
    }
  }

  static String getContent(ThirdPartyType thirdPartyType, int lessonId) {
    String content = '';
    for (int i = 0; i < theThirdPartyLessonList.length; i++) {
      if (thirdPartyType == theThirdPartyLessonList[i].thirdPartyType && lessonId == theThirdPartyLessonList[i].lessonId) {
        content = theThirdPartyLessonList[i].content;
        break;
      }
    }

    return content;
  }

  static int getCurrentRealWordsLength() {
    var content = theThirdPartyLessonList[currentContentIndex];
    return content.getRealWordsLength();
  }

  static String getCurrentSentenceAndCharIndex(int typingCharsIndex, PrimitiveWrapper charIndex) {
    var content = theThirdPartyLessonList[currentContentIndex];
    return content.getSentenceAndCharIndex(typingCharsIndex, charIndex);
  }


  int getRealWordsLength() {
    if (realWordsLength != -1)  {
      // already initialized
      return realWordsLength;
    }

    for (int i = 0; i < content.length; i++) {
      if (!Utility.specialChar(content[i])) {
        realWordsLength++;
      }
    }

    realWordsLength++; // 0 indexed, therefore need to add one for length
    return realWordsLength;
  }

  String getSentenceAndCharIndex(int typingCharsIndex, PrimitiveWrapper charIndex) {
    int charIndexCount = -1;
    int lastNonCharIndex = -1;
    String currentSentence = '';

    for (int i = 0; i < content.length; i++) {
      if (!Utility.specialChar(content[i])) {
        charIndexCount++;
        //currentSentence += currentContent[i];
      }
      else {
        // record the current non-char index for later sentence creation
        lastNonCharIndex = i;
      }

      if (charIndexCount == typingCharsIndex) {
        // this is the one wanted
        charIndex.value = i - lastNonCharIndex - 1;
        currentSentence = getCurrentSentenceHelper(lastNonCharIndex);
        break;
      }
    }

    return currentSentence;
  }

  String getCurrentSentenceHelper(int lastNonCharIndex) {
    String sentence = '';

    for (int i = lastNonCharIndex + 1; i < content.length; i++) {
      sentence += content[i];
      if (Utility.specialChar(content[i])) {
        if (sentence.length != 0) {
          break;
        }
      }
    }

    return sentence;
  }

  static String getChar(int currentIndex) {
    PrimitiveWrapper charIndex = PrimitiveWrapper(-1);
    String sentence = getCurrentSentenceAndCharIndex(currentIndex, charIndex);
    return sentence.substring(charIndex.value, charIndex.value + 1);
  }
}