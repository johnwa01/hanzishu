import 'package:hanzishu/engine/level.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';

int BaseUnitDescriptionStringID = 10;

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
];