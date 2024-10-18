import 'package:hanzishu/engine/thirdpartylesson.dart';
import 'package:hanzishu/data/thirdpartylessonlist.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';

enum ThirdPartyType {
  yuwen,
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
    }

    return wholeString;
  }
}

class ThirdPartyLevel {
  ThirdPartyType thirdPartyType = ThirdPartyType.none;
  int levelId = -1;
  String levelNameCode = '';  // 'a1', 'b3' etc
  //int startingLessonId;

  ThirdPartyLevel(ThirdPartyType thirdPartyType,
      int levelId,
      String levelNameCode) {
    this.thirdPartyType = thirdPartyType;
    this.levelId = levelId;
    this.levelNameCode = levelNameCode;
    //this.startingLessonId = startingLessonId;
  }

  static String? getLevelName(int levelId) {
    for (int i = 0; i < theThirdPartyLevelList.length; i++) {
      if (theThirdPartyLevelList[i].levelId == levelId) {
        return ThirdParty.getStringFromCode(theThirdPartyLevelList[i].levelNameCode);
      }
    }

    return null;
  }
}

class ThirdPartyLesson {
  ThirdPartyType thirdPartyType = ThirdPartyType.none;
  int levelId = -1;
  int lessonId = -1;
  String lessonNameCode = ''; // 'a1', 'c4' etc

  ThirdPartyLesson(ThirdPartyType thirdPartyType,
      int levelId,
      int lessonId,
      String lessonNameCode) {
    this.thirdPartyType = thirdPartyType;
    this.levelId = levelId;
    this.lessonId = lessonId;
    this.lessonNameCode = lessonNameCode;
  }

  static String? getLessonName(int lessonId) {
    for (int i = 0; i < theThirdPartyLessonList.length; i++) {
      if (theThirdPartyLessonList[i].lessonId == lessonId) {
        return ThirdParty.getStringFromCode(theThirdPartyLessonList[i].lessonNameCode);
      }
    }

    return null;
  }

  static String getLessonString(ThirdPartyType thirdPartyType, int lessonId) {
    String lessonString = '';
    var fieldLessonId;
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

    return lessonString;
  }
}