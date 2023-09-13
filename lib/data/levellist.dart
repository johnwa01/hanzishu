import 'package:hanzishu/engine/level.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';

int BaseLevelDescriptionStringID = 10;

var theLevelList = [
  //Note: getString here is a static value. code will use its own getString calls in lessonspage.dart
  Level(0, theNumberOfLessonsInLevels[0], false, getString(BaseLevelDescriptionStringID + 1)/*"Basics"*/),  // level index 0 == level 1
  Level(1, theNumberOfLessonsInLevels[1], false, getString(BaseLevelDescriptionStringID + 2)/*"In the classroom"*/),
  Level(2, theNumberOfLessonsInLevels[2], false, getString(BaseLevelDescriptionStringID + 3)/*"Family and friends"*/),
  Level(3, theNumberOfLessonsInLevels[3], false, getString(BaseLevelDescriptionStringID + 4)/*"Food"*/),
  Level(4, theNumberOfLessonsInLevels[4], false, getString(BaseLevelDescriptionStringID + 5)/*"Studies"*/),
  Level(5, theNumberOfLessonsInLevels[5], false, getString(BaseLevelDescriptionStringID + 6)/*"Weather"*/),
  Level(6, theNumberOfLessonsInLevels[6], false, getString(BaseLevelDescriptionStringID + 7)/*"Shopping"*/),
  Level(7, theNumberOfLessonsInLevels[7], false, getString(BaseLevelDescriptionStringID + 8)/*"Travel"*/),
  Level(8, theNumberOfLessonsInLevels[8], false, getString(BaseLevelDescriptionStringID + 9)/*"Transportation"*/),
  Level(9, theNumberOfLessonsInLevels[9], false, getString(BaseLevelDescriptionStringID + 10)/*"Sports and entertainment"*/),
];