import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/engine/levelmanager.dart';
import 'package:hanzishu/engine/lessonmanager.dart';

class GeneralManager {
  // TODO: change parameter to lessonId only
  static bool hasZiCompleted(int ziId, HittestState hittestState, int lessonId/*String lessonName*/) {
    if (hittestState == HittestState.hanzishuLesson || hittestState == HittestState.ziAndSidingShuLesson || hittestState == HittestState.quizShuLesson) {
      //var lessonId = theLessonManager.getLessonNumber(lessonName);
      return hasZiCompletedForLesson(ziId, hittestState, lessonId);
    }

    return hasZiCompletedForLessons(ziId, hittestState);
  }

  static bool hasZiCompletedForLesson(int ziId, HittestState hittestState, int lessonId) {
    var lesson = theLessonList[lessonId];
    return lesson.hasZiCompleted(ziId, hittestState);
  }

  // TODO: parameters for start and end lesson id
  static bool hasZiCompletedForLessons(int ziId, HittestState hittestState) {
    var internalLessonId = LevelManager.getInternalLessonId(LevelLessonPair(theLevelManager.theCurrentLevel, theRangeUptoLessonNumberForCurrentLevel));
    // For review mode, this info is stored in the last lesson for the lesson range
    return hasZiCompletedForLesson(ziId, hittestState, internalLessonId);
  }

  static void checkAndSetHasAllChildrenCompleted(int ziId, HittestState hittestState, int lessonId/*String currentLesson*/) {
    if (hittestState == HittestState.hanzishuLesson || hittestState == HittestState.ziAndSidingShuLesson || hittestState == HittestState.quizShuLesson) {
      //var lessonId = theLessonManager.getLessonNumber(name: currentLesson);
      checkAndSetHasAllChildrenCompletedInLesson(ziId, hittestState, lessonId);
    }
    else {
      var fromInternalLessonId = LevelManager.getInternalLessonId(LevelLessonPair(theCurrentLevel, theRangeFromLessonNumberForCurrentLevel));
      //LevelManager.firstInternalLessonId(levelId: theCurrentLevel)
      var internalLessonId = LevelManager.getInternalLessonId(LevelLessonPair(theCurrentLevel, theRangeUptoLessonNumberForCurrentLevel));
      checkAndSetHasAllChildrenCompletedInLessons(ziId, hittestState, fromInternalLessonId, internalLessonId);
    }
  }

  static void checkAndSetHasAllChildrenCompletedInLesson(int ziId, HittestState hittestState, int lessonId) {
    var lesson = theLessonList[lessonId];
    if (lesson.checkAndSetHasAllChildrenCompleted(ziId, hittestState)) {
      lesson.setZiCompleted(ziId, hittestState);
    }
  }

  static void checkAndSetHasAllChildrenCompletedInLessons(int ziId, HittestState hittestState, int startLessonId, int endLessonId) {
    var lesson = theLessonList[startLessonId];
    for (var lessonId = startLessonId; lessonId <= endLessonId; lessonId++) {
      lesson = theLessonList[lessonId];
      if (!lesson.checkAndSetHasAllChildrenCompleted(ziId, hittestState)) {
        return;
      }
    }

    // set the flag on the last lesson for the lesson range
    lesson.setZiCompleted(ziId, hittestState);
  }

  static void SetSectionCompleted(HittestState hittestState, String currentLesson) {
    if (hittestState == HittestState.hanzishuLesson || hittestState == HittestState.ziAndSidingShuLesson || hittestState == HittestState.quizShuLesson) {
      var lessonId = theLessonManager.getLessonNumber(currentLesson);

      //TODO: is it right init method
      var lessonSection = LessonSection.FullCharacterTree;
      //if (hittestState == HittestState.ziAndSidingShuLesson) {
      //    lessonSection = LessonSection.BinaryTree
      //}
      if (hittestState == HittestState.hanzishuLesson) {
        lessonSection = LessonSection.FullCharacterTree;
      }
      else if (hittestState == HittestState.quizShuLesson) {
        lessonSection = LessonSection.Quiz;
      }

      LessonManager.SetSectionCompleted(lessonId, lessonSection);
    }
  }

  static void initFromStorage() {
    // read from storage about status/setting
      // TODO: following
      // theStorageHandler.ReadFromFile();
    //theLatestEnabledLesson = theStorageHandler.getLatestEnabledLesson();
    //theLatestEnabledLessonPrevious = theLatestEnabledLesson;
  }

  // update both lesson status and statistics
  static void saveAllToStorage() {
    //TODO: following
    //theStatisticsManager.dumpStatisticsToStorageMemory();
    //theStorageHandler.setLatestEnabledLesson(latestEnabledLesson: theLatestEnabledLesson);
    //theStorageHandler.SaveToFile();
  }
}
