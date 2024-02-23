import 'package:hanzishu/engine/lessonunit.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';

int BaseUnitDescriptionStringID = 10;
int BaseUnitDescriptionStringIDLevel2 = 472;

var theUnitList = [
  //Note: getString here is a static value. code will use its own getString calls in lessonspage.dart
  LessonUnit(0, theNumberOfLessonsInLevels[0], false, getString(BaseUnitDescriptionStringID + 1)/*"Basics"*/),  // level index 0 == level 1
  LessonUnit(1, theNumberOfLessonsInLevels[1], false, getString(BaseUnitDescriptionStringID + 2)/*"In the classroom"*/),
  LessonUnit(2, theNumberOfLessonsInLevels[2], false, getString(BaseUnitDescriptionStringID + 3)/*"Family and friends"*/),
  LessonUnit(3, theNumberOfLessonsInLevels[3], false, getString(BaseUnitDescriptionStringID + 4)/*"Food"*/),
  LessonUnit(4, theNumberOfLessonsInLevels[4], false, getString(BaseUnitDescriptionStringID + 5)/*"Studies"*/),
  LessonUnit(5, theNumberOfLessonsInLevels[5], false, getString(BaseUnitDescriptionStringID + 6)/*"Weather"*/),
  LessonUnit(6, theNumberOfLessonsInLevels[6], false, getString(BaseUnitDescriptionStringID + 7)/*"Shopping"*/),
  LessonUnit(7, theNumberOfLessonsInLevels[7], false, getString(BaseUnitDescriptionStringID + 8)/*"Travel"*/),
  LessonUnit(8, theNumberOfLessonsInLevels[8], false, getString(BaseUnitDescriptionStringID + 9)/*"Transportation"*/),
  LessonUnit(9, theNumberOfLessonsInLevels[9], false, getString(BaseUnitDescriptionStringID + 10)/*"Sports and entertainment"*/),
  LessonUnit(10, theNumberOfLessonsInLevels[10], false, getString(BaseUnitDescriptionStringIDLevel2 + 1)/*"Basics"*/),
  LessonUnit(11, theNumberOfLessonsInLevels[11], false, getString(BaseUnitDescriptionStringIDLevel2 + 2)/*"In the classroom"*/),
  LessonUnit(12, theNumberOfLessonsInLevels[12], false, getString(BaseUnitDescriptionStringIDLevel2 + 3)/*"Family and friends"*/),
  LessonUnit(13, theNumberOfLessonsInLevels[13], false, getString(BaseUnitDescriptionStringIDLevel2 + 4)/*"Food"*/),
  LessonUnit(14, theNumberOfLessonsInLevels[14], false, getString(BaseUnitDescriptionStringIDLevel2 + 5)/*"Studies"*/),
  LessonUnit(15, theNumberOfLessonsInLevels[15], false, getString(BaseUnitDescriptionStringIDLevel2 + 6)/*"Weather"*/),
  LessonUnit(16, theNumberOfLessonsInLevels[16], false, getString(BaseUnitDescriptionStringIDLevel2 + 7)/*"Shopping"*/),
  LessonUnit(17, theNumberOfLessonsInLevels[17], false, getString(BaseUnitDescriptionStringIDLevel2 + 8)/*"Travel"*/),
  LessonUnit(18, theNumberOfLessonsInLevels[18], false, getString(BaseUnitDescriptionStringIDLevel2 + 9)/*"Transportation"*/),
  LessonUnit(19, theNumberOfLessonsInLevels[19], false, getString(BaseUnitDescriptionStringIDLevel2 + 10)/*"Sports and entertainment"*/),
];