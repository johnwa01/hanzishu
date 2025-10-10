import 'package:hanzishu/engine/thirdpartylesson.dart';
import 'package:hanzishu/data/thirdpartylessonlist.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/inputzimanager.dart';
import 'package:characters/characters.dart';

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
          if (index == 3) {
            wholeString = getString(520) + " 2";
          }
          else {
            wholeString = getString(520) + " 1" + subIndexLetter;
          }
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
  static int maxSentenceLength = 10;

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
        if (thirdPartyType == ThirdPartyType.yuwen || (thirdPartyType == ThirdPartyType.sunlaoshi && (version == "1" || version == "2"))) { // these two are older mechanism
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
    var oneContent = theThirdPartyLessonList[currentContentIndex].content;
    return getSentenceAndCharIndex(oneContent, typingCharsIndex, charIndex);
  }


  int getRealWordsLength() {
    if (realWordsLength != -1)  {
      // already initialized
      return realWordsLength;
    }

    realWordsLength = getRealWordsLengthUtil(content);
    return realWordsLength;
  }

  static int getRealWordsLengthUtil(String str) {
    int wordsLength = -1;

    //Leave this way for now in case we need this structure
    for (int i = 0; i < str.characters.length; i++) {
      //if (!Utility.specialChar(str.characters.elementAt(i))) {
        wordsLength++;
      //}
    }

    wordsLength++; // 0 indexed, therefore need to add one for length
    return wordsLength;
  }

  static String getSentenceAndCharIndex(String oneContent, int typingCharsIndex, PrimitiveWrapper charIndex) {
    int charIndexCount = -1;
    int lastNonCharIndex = -1;
    String currentSentence = '';
    int countAfterLastSpecial = -1;

    var chars = oneContent.characters;

    for (int i = 0; i < chars.length; i++) {
      charIndexCount++;
      countAfterLastSpecial++;

      if (charIndexCount == typingCharsIndex) {
        // this is the one wanted
        charIndex.value = i - lastNonCharIndex - 1;
        currentSentence = getCurrentSentenceHelper(oneContent, lastNonCharIndex);
        break;
      }

      if (Utility.specialChar(chars.elementAt(i)) || countAfterLastSpecial >= InputZiManager.maxTypingLength) {
        // record the current non-char index for later sentence creation
        lastNonCharIndex = i;
        countAfterLastSpecial = 0;
      }
    }

    return currentSentence;
  }

  static String getCurrentSentenceHelper(String oneContent, int lastNonCharIndex) {
    String sentence = '';
    int countTypingLength = 0;

    for (int i = lastNonCharIndex + 1; i < oneContent.characters.length; i++) {
      sentence += oneContent.characters.elementAt(i);
      countTypingLength++;
      if (Utility.specialChar(oneContent.characters.elementAt(i)) || countTypingLength >= InputZiManager.maxTypingLength) {
        if (sentence.characters.length != 0) {
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

  static String getOneChar(String oneContent, int currentIndex) {
    PrimitiveWrapper charIndex = PrimitiveWrapper(-1);
    String sentence = getSentenceAndCharIndex(oneContent, currentIndex, charIndex);
    return sentence.characters.elementAt(charIndex.value); //substring(charIndex.value, charIndex.value + 1);
  }

  static String divideLongSentences(String oneContent) {
    String newContent = '';
    int oneSentenceCounter = 0;

    for (int i = 0; i < oneContent.length; i++) {
      if (Utility.specialChar(oneContent[i])) {
        oneSentenceCounter = 0;
      }
      else {
        oneSentenceCounter++;
        if (oneSentenceCounter > maxSentenceLength) {
          newContent += ' ';
          oneSentenceCounter = 0;
        }
      }
      newContent += oneContent[i];
    }

    return newContent;
  }
}