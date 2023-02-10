import 'package:hanzishu/utility.dart';
import 'package:hanzishu/data/searchingzilist.dart';

//int DrillDescriptionStringID = 10;
class DrillMenu {
  int id;
  String description;

  DrillMenu(int id,
      String description) {
    this.id = id;
    this.description = description;
  }
}

var theDrillMenuList = [
  //Note: getString here is a static value. code will use its own getString calls in lessonspage.dart
  //Level(0, theNumberOfLessonsInLevels[0], false, getString(BaseLevelDescriptionStringID + 1)/*"Basics"*/),  // level index 0 == level 1
  //Level(1, theNumberOfLessonsInLevels[1], false, getString(BaseLevelDescriptionStringID + 2)/*"In the classroom"*/),
  DrillMenu(1, "All"),
  DrillMenu(2, "Hanzishu lessons"),
  DrillMenu(3, "HSK"),
];

var theHanzishuSubList = [
  DrillMenu(1, "Up to unit 1"),
  DrillMenu(2, "Up to unit 2"),
  DrillMenu(3, "Up to unit 3"),
  DrillMenu(4, "Up to unit 4"),
  DrillMenu(5, "Up to unit 5"),
  DrillMenu(6, "Up to unit 6"),
  DrillMenu(7, "Up to unit 7"),
  DrillMenu(8, "Up to unit 8"),
  DrillMenu(9, "Up to unit 9"),
  DrillMenu(10, "Up to unit 10"),
];

var theHSKSubList = [
  DrillMenu(1, "Up to level 1"),
  DrillMenu(2, "Up to level 2"),
  DrillMenu(3, "Up to level 3"),
  DrillMenu(4, "Up to level 4"),
  DrillMenu(5, "Up to level 5"),
  DrillMenu(6, "Up to level 6"),
  DrillMenu(7, "Up to level 7/8/9"),
];

var theSearchingZiFilterList = [
  null,
  theSearchingZiList,
  theSearchingZiList,
];

List<List<int>> theSearchingZiRealFilterList = new List<List<int>>(theSearchingZiFilterList.length);
