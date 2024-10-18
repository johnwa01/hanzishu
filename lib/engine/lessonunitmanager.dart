import 'package:hanzishu/engine/lessonunit.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/data/lessonunitlist.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';

class UnitLessonPair {
  int levelId = -1;
  int lessonId = -1;

  UnitLessonPair(int levelId, int lessonId) {
    this.levelId = levelId;
    this.lessonId = lessonId;
  }
}

class LessonUnitManager {
  static final LessonUnitManager _levelManager = LessonUnitManager._internal();
  UnitLessonPair currentLevelLessonPair = UnitLessonPair(1, 1);
  int theCurrentLevel = 1;
  String theRangeLevelPlus = "theRangeLevelPlus"; // TODO: do we still need these three?
  String theRangeLevelMinus = "theRangeLevelMinus";
  String theRangeLevelBoxTag = "theRangeLevelBoxTag";

  factory LessonUnitManager() {
    return _levelManager;
  }

  LessonUnitManager._internal();

  LessonUnit getLessonUnit(int id) {
    return theUnitList[id];
  }

  int getLevelCount() {
    return theUnitList.length;
  }

  static UnitLessonPair getUnitLessonPair(int internalLessonId) {
    var levelLessonPair = UnitLessonPair(0, 0);
    var levelCount = theUnitList.length;
    var lessonId = internalLessonId;

    for (var i = 0; i <= (levelCount - 1); i++) {
      if (lessonId > theUnitList[i].numberOfLessons) {
        lessonId -= theUnitList[i].numberOfLessons;
      }
      else {
        levelLessonPair.levelId = i + 1;
        levelLessonPair.lessonId = lessonId;
        return levelLessonPair;
      }
    }

    return levelLessonPair;
  }

  static int getInternalLessonId(UnitLessonPair levelLessonPair) {
    var levelId = levelLessonPair.levelId;
    if (levelId > theUnitList.length) {
      return 0;
    }

    if (levelId == 1) {
      return levelLessonPair.lessonId;
    }

    var internalLessonId = 0;
    for (var i = 0; i <= (levelId - 2); i++) {
      internalLessonId += theUnitList[i].numberOfLessons;
    }

    return internalLessonId + levelLessonPair.lessonId;
  }

  static int firstInternalLessonId(int levelId) {
    if (levelId > theUnitList.length) {
      return 0;
    }

    if (levelId == 1) {
      return 1;
    }

    var firstLessonId = 0;
    for (var i = 0; i <= (levelId - 2); i++) {
      firstLessonId += theUnitList[i].numberOfLessons;
    }

    return firstLessonId + 1;
  }

  static int lastInternalLessonId(int levelId) {
    if (levelId > theUnitList.length) {
      return 0;
    }

    var lastLessonId = 0;
    for (var i = 0; i < levelId; i++) {
      lastLessonId += theUnitList[i].numberOfLessons;
    }

    return lastLessonId;
  }

  /* TODO
  static String getLevelLessonDisplayString(int internalLessonId) {
    var levelLessonPair = LessonUnitManager.getUnitLessonPair(internalLessonId);
    var levelLessonDisplayString = theLessonString + " " + String(levelLessonPair.levelId) + " / " + String(levelLessonPair.lessonId);

  return levelLessonDisplayString;
  }


  static String getLevelLessonDisplayString(String lessonName) {
    var lessonId = theLessonManager.getLessonNumber(lessonName);
    return getLevelLessonDisplayString(lessonId);
  }

  String UpdateRangeLevel(String levelOperation) {
    if (levelOperation == theRangeLevelPlus) {
      if (theCurrentLevel == theUnitList.length) {
        theCurrentLevel = 1;
      }
      else {
        theCurrentLevel += 1;
      }
    }
    else if (levelOperation == theRangeLevelMinus) {
      if (theCurrentLevel == 1) {
        theCurrentLevel = theUnitList.length;
      }
      else {
        theCurrentLevel -= 1;
      }
    }

    // reset the lesson range
    theRangeUptoLessonNumberForCurrentLevel = theUnitList[theCurrentLevel - 1].numberOfLessons;
  }
  */

  static int getStartInternalLessonId(int selectedReviewLevelStartingId,
      int selectedReviewLevelEndingId, int selectedReviewLessonStartingId,
      int selectedReviewLessonEndingId) {
    var lessonId = 0;
    for (var i = 1; i < selectedReviewLevelStartingId; i++) {
      lessonId += theNumberOfLessonsInLevels[i - 1];
    }

    if (selectedReviewLevelStartingId == selectedReviewLevelEndingId) {
      lessonId += selectedReviewLessonStartingId;
    }
    else {
      lessonId += 1; // default the first one
    }

    return lessonId;
  }

  static int getEndInternalLessonId(int selectedReviewLevelStartingId,
      int selectedReviewLevelEndingId, int selectedReviewLessonStartingId,
      int selectedReviewLessonEndingId) {
    var lessonId = 0;
    for (var i = 1; i < selectedReviewLevelEndingId; i++) {
      lessonId += theNumberOfLessonsInLevels[i - 1];
    }

    if (selectedReviewLevelStartingId == selectedReviewLevelEndingId) {
      lessonId += selectedReviewLessonEndingId;
    }
    else {
      lessonId += theNumberOfLessonsInLevels[selectedReviewLevelEndingId -
          1]; // default the whole level
    }

    return lessonId;
  }

  static String getNewHanzi(int unitId) {
    if (!theHavePopulatedLessonsInfo) {
      LessonManager.populateLessonsInfo();
      theHavePopulatedLessonsInfo = true;
    }

    int firstLessonId = firstInternalLessonId(unitId);
    int lastLessonId = lastInternalLessonId(unitId);

    String levelNewHanzi = "";
    for (int i = firstLessonId; i <= lastLessonId; i++) {
      levelNewHanzi += theLessonList[i].convChars;
    }

    return levelNewHanzi;
  }

  static String getLessonUnitDescriptionString(int unitNumber) {
    if (unitNumber <= LessonUnit.NumberOfUnitsInLevel1) {
      return getString(BaseUnitDescriptionStringID + unitNumber);
    }
    else {
      return getString(BaseUnitDescriptionStringIDLevel2 + unitNumber - LessonUnit.NumberOfUnitsInLevel1 - 1); //  0 start
    }
  }
}