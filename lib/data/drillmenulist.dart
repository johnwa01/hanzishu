import 'package:hanzishu/utility.dart';
import 'package:hanzishu/data/searchingzilist.dart';

//int DrillDescriptionStringID = 10;
class DrillMenu {
  int id;
  int stringId; //String description;

  DrillMenu(int id,
      stringId) {
    this.id = id;
    this.stringId = stringId;
  }
}

var theDrillMenuList = [
  //Note: getString here is a static value. code will use its own getString calls in lessonspage.dart
  //Level(0, theNumberOfLessonsInLevels[0], false, getString(BaseLevelDescriptionStringID + 1)/*"Basics"*/),  // level index 0 == level 1
  //Level(1, theNumberOfLessonsInLevels[1], false, getString(BaseLevelDescriptionStringID + 2)/*"In the classroom"*/),
  DrillMenu(1, 395),
  DrillMenu(2, 450),
  DrillMenu(3, 396),
  DrillMenu(4, 447),
  DrillMenu(5, 448),
];

var theHanzishuSubList = [
  DrillMenu(1, 0), //"Up to unit 1"),
  DrillMenu(2, 0), //"Up to unit 2"),
  DrillMenu(3, 0), //"Up to unit 3"),
  DrillMenu(4, 0), //"Up to unit 4"),
  DrillMenu(5, 0), //"Up to unit 5"),
  DrillMenu(6, 0), //"Up to unit 6"),
  DrillMenu(7, 0), //"Up to unit 7"),
  DrillMenu(8, 0), //"Up to unit 8"),
  DrillMenu(9, 0), //"Up to unit 9"),
  DrillMenu(10, 0), //"Up to unit 10"),
];

var theHSKSubList = [
  DrillMenu(1, 0), //"Up to level 1"),
  DrillMenu(2, 0), //"Up to level 2"),
  DrillMenu(3, 0), //"Up to level 3"),
  DrillMenu(4, 0), //"Up to level 4"),
  DrillMenu(5, 0), //"Up to level 5"),
  DrillMenu(6, 0), //"Up to level 6"),
  DrillMenu(7, 400), //"Up to level 7/8/9"),
];

var theHSKTestSubList = [
  DrillMenu(1, 0), //"level 1"),
  DrillMenu(2, 0), //"level 2"),
  DrillMenu(3, 0), //"level 3"),
  DrillMenu(4, 0), //"level 4"),
  DrillMenu(5, 0), //"level 5"),
  DrillMenu(6, 0), //"level 6"),
  DrillMenu(7, 400), //"level 7/8/9"),
];

var theSearchingZiFilterList = [
  null, //all
  theSearchingZiList, //hanzishu
  theSearchingZiList, //hsk
  theSearchingZiList, //hskTestSound
  theSearchingZiList, //hskTestMeaning
  null //custom
];

List<List<int>> theSearchingZiRealFilterList = new List<List<int>>(theSearchingZiFilterList.length);
