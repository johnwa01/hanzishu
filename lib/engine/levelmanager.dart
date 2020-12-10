import 'package:hanzishu/engine/level.dart';
import 'package:hanzishu/data/levellist.dart';
import 'package:hanzishu/variables.dart';

class LevelLessonPair {
  int levelId;
  int lessonId;

  LevelLessonPair(int levelId, int lessonId) {
    this.levelId = levelId;
    this.lessonId = lessonId;
  }
}

class LevelManager {
  static final LevelManager _levelManager = LevelManager._internal();
  LevelLessonPair currentLevelLessonPair = LevelLessonPair(1, 1);
  int theCurrentLevel = 1;
  String theRangeLevelPlus = "theRangeLevelPlus"; // TODO: do we still need these three?
  String theRangeLevelMinus = "theRangeLevelMinus";
  String theRangeLevelBoxTag = "theRangeLevelBoxTag";

  factory LevelManager() {
    return _levelManager;
  }
  LevelManager._internal();

  Level getLevel(int id) {
    return theLevelList[id];
  }

  int getLevelCount() {
    return theLevelList.length;
  }

  static LevelLessonPair getLevelLessonPair(int internalLessonId) {
    var levelLessonPair = LevelLessonPair(0, 0);
    var levelCount = theLevelList.length;
    var lessonId = internalLessonId;

    for (var i = 0; i <= (levelCount - 1); i++) {
      if (lessonId > theLevelList[i].numberOfLessons) {
        lessonId -= theLevelList[i].numberOfLessons;
      }
      else {
        levelLessonPair.levelId = i + 1;
        levelLessonPair.lessonId = lessonId;
        return levelLessonPair;
      }
    }

    return levelLessonPair;
  }

  static int getInternalLessonId(LevelLessonPair levelLessonPair) {
    var levelId = levelLessonPair.levelId;
    if (levelId > theLevelList.length) {
      return 0;
    }

    if (levelId == 1) {
      return levelLessonPair.lessonId;
    }

    var internalLessonId = 0;
    for (var i = 0; i <= (levelId-2); i++) {
      internalLessonId += theLevelList[i].numberOfLessons;
    }

    return internalLessonId + levelLessonPair.lessonId;
  }

  static int firstInternalLessonId(int levelId) {
    if (levelId > theLevelList.length) {
      return 0;
    }

    if (levelId == 1) {
      return 1;
    }

    var firstLessonId = 0;
    for (var i = 0; i <= (levelId - 2); i++) {
      firstLessonId += theLevelList[i].numberOfLessons;
    }

    return firstLessonId + 1;
  }

  static int lastInternalLessonId(int levelId) {
    if (levelId > theLevelList.length) {
      return 0;
    }

    var lastLessonId = 0;
    for (var i = 0; i <= (levelId - 1); i++) {
      lastLessonId += theLevelList[i].numberOfLessons;
    }

    return lastLessonId;
  }

  /* TODO
  static String getLevelLessonDisplayString(int internalLessonId) {
    var levelLessonPair = LevelManager.getLevelLessonPair(internalLessonId);
    var levelLessonDisplayString = theLessonString + " " + String(levelLessonPair.levelId) + " / " + String(levelLessonPair.lessonId);

  return levelLessonDisplayString;
  }


  static String getLevelLessonDisplayString(String lessonName) {
    var lessonId = theLessonManager.getLessonNumber(lessonName);
    return getLevelLessonDisplayString(lessonId);
  }

  String UpdateRangeLevel(String levelOperation) {
    if (levelOperation == theRangeLevelPlus) {
      if (theCurrentLevel == theLevelList.length) {
        theCurrentLevel = 1;
      }
      else {
        theCurrentLevel += 1;
      }
    }
    else if (levelOperation == theRangeLevelMinus) {
      if (theCurrentLevel == 1) {
        theCurrentLevel = theLevelList.length;
      }
      else {
        theCurrentLevel -= 1;
      }
    }

    // reset the lesson range
    theRangeUptoLessonNumberForCurrentLevel = theLevelList[theCurrentLevel - 1].numberOfLessons;
  }
  */

  static int getStartInternalLessonId(int selectedReviewLevelStartingId, int selectedReviewLevelEndingId, int selectedReviewLessonStartingId, int selectedReviewLessonEndingId) {
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

  static int getEndInternalLessonId(int selectedReviewLevelStartingId, int selectedReviewLevelEndingId, int selectedReviewLessonStartingId, int selectedReviewLessonEndingId) {
    var lessonId = 0;
    for (var i = 1; i < selectedReviewLevelEndingId; i++) {
      lessonId += theNumberOfLessonsInLevels[i - 1];
    }

    if (selectedReviewLevelStartingId == selectedReviewLevelEndingId) {
      lessonId += selectedReviewLessonEndingId;
    }
    else {
      lessonId += theNumberOfLessonsInLevels[selectedReviewLevelEndingId - 1]; // default the whole level
    }

    return lessonId;
  }
}