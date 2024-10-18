import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/lessonunitlist.dart';
import 'package:hanzishu/data/lessonlist.dart';

class LessonUnit {
  int id = -1;
  int numberOfLessons = -1;
  bool isCompleted = false;
  String description = '';

  LessonUnit(int id,
      int numberOfLessons,
      bool isCompleted,
      String description) {
    this.id = id;
    this.numberOfLessons = numberOfLessons;
    this.isCompleted = isCompleted;
    this.description = description;
  }

  static int NumberOfUnitsInLevel1 = 10;

  static int getUnitId(int lessonId) { // unitId 0-based
    var unitCount = theUnitList.length;
    int previousTotalCount = 0;
    int currentTotalCount = 0;
    for (int i = 0; i < unitCount; i++) {
      currentTotalCount = previousTotalCount + theNumberOfLessonsInLevels[i];
      if (lessonId >= previousTotalCount && lessonId <= currentTotalCount) {
        return i;
      }
      else {
        previousTotalCount = currentTotalCount;
      }
    }

    return -1;
  }

  static int getFirstLessonInUnit(int unitId) {
    int lessonCount = 0;
    for (int i = 0; i < unitId; i++) {
      lessonCount += theNumberOfLessonsInLevels[i];
    }

    return lessonCount + 1;
  }

  static String getNewCharsInUnit(int lessonId) {
    var unitId = getUnitId(lessonId);
    var firstLesson = getFirstLessonInUnit(unitId);
    var lessonCountInUnit = theNumberOfLessonsInLevels[unitId];
    String newCharsInUnit = "";
    for (int i = firstLesson; i < firstLesson + lessonCountInUnit; i++) {
      newCharsInUnit += theLessonList[i].convChars;
    }

    return newCharsInUnit;
  }
}