import 'package:hanzishu/engine/thirdpartylesson.dart';
import 'package:hanzishu/data/thirdpartylessonlist.dart';
import 'package:hanzishu/utility.dart';

enum ThirdPartyType {
  yuwen,
  none
}

class ThirdParty {
  ThirdPartyType thirdPartyType;
  int nameStringId;

  ThirdParty(ThirdPartyType thirdPartyType,
      int nameStringId,) {
    this.thirdPartyType = thirdPartyType;
    this.nameStringId = nameStringId;
  }

  static String getThirdPartyName(ThirdPartyType thirdPartyType) {
    for (int i = 0; i < theThirdPartyList.length; i++) {
      if (theThirdPartyList[i].thirdPartyType == thirdPartyType) {
        return getString(theThirdPartyList[i].nameStringId);
      }
    }

    return null;
  }
}

class ThirdPartyLevel {
  ThirdPartyType thirdPartyType;
  int levelId;
  String levelNameCode;  // 'a1', 'b3' etc
  //int startingLessonId;

  ThirdPartyLevel(ThirdPartyType thirdPartyType,
      int levelId,
      String levelNameCode) {
    this.thirdPartyType = thirdPartyType;
    this.levelId = levelId;
    this.levelNameCode = levelNameCode;
    //this.startingLessonId = startingLessonId;
  }
}

class ThirdPartyLesson {
  ThirdPartyType thirdPartyType;
  int levelId;
  int lessonId;
  String lessonNameCode; // 'a1', 'c4' etc

  ThirdPartyLesson(ThirdPartyType thirdPartyType,
      int levelId,
      int lessonId,
      String lessonNameCode) {
    this.thirdPartyType = thirdPartyType;
    this.levelId = levelId;
    this.lessonId = lessonId;
    this.lessonNameCode = lessonNameCode;
  }
}