import 'dart:math';
import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';

enum DrillCategory {
  all,
  hanzishu,
  hsk,
  custom,
  yuwen,
  yuwenLesson
}



class CenterZiRelated {
  static List<double> position = [160.0, 275.0, 200.0, 275.0, 20.0];
  static List<String> structure = ["Single part", "left & right", "top & down", "wrapped"];
  int searchingZiId;

  String structureReal;
  int structureAccuratePosition; // 0,1
  int structureWrongIndex;
  int structureSelectPosition;

  int compCountReal;
  int compCountAccuratePosition;
  int compCountWrongValue;
  int compCountSelectPosition;

  bool drawBreakdown;

  var breakoutPositions;

  CenterZiRelated(
      int searchingZiId,
      String structureReal,
      int structureAccuratePosition,
      int structureWrongIndex,
      int structureSelectPosition,
      int compCountReal,
      int compCountAccuratePosition,
      int compCountWrongValue,
      int compCountSelectPosition,
      bool drawBreakdown,
      var breakoutPositions) {
    this.searchingZiId = searchingZiId;
    this.structureReal = structureReal;
    this.structureAccuratePosition = structureAccuratePosition;
    this.structureWrongIndex = structureWrongIndex;
    this.structureSelectPosition = structureSelectPosition;
    this.compCountReal = compCountReal;
    this.compCountAccuratePosition = compCountAccuratePosition;
    this.compCountWrongValue = compCountWrongValue;
    this.compCountSelectPosition = compCountSelectPosition;
    this.drawBreakdown = drawBreakdown;
    this.breakoutPositions = breakoutPositions;
  }

  static int getIndexByStructureValue(String structure) {
    if (structure == "s") {
      return 0;
    }
    else if (structure == "l") {
      return 1;
    }
    else if (structure == "t") {
      return 2;
    }
    else if (structure == "w") {
      return 3;
    }
    else {
      return -1;
    }
  }

  static int getWrongStructureIndex(int realStrucutureIndex) {
    Random rand = Random();
    bool go = true;
    var wrongStructure;
    while (go) {
      wrongStructure = rand.nextInt(4);
      if (wrongStructure != realStrucutureIndex) {
        go = false;
      }
    }

    return wrongStructure;
  }

  static int getCompCountWrongValue(int realCompCount) {
    Random rand = Random();
    var zeroOrOne = rand.nextInt(2);
    if (zeroOrOne == 0 && realCompCount >= 2) {
      return realCompCount - 1;
    }
    else {
      return realCompCount + 1;
    }
  }

  static void initBottumCenterZiRelated(int centerZiId, CenterZiRelated centerZiRelated) {
    centerZiRelated.structureReal = theSearchingZiList[centerZiId].structure;
    // decide accurate position for structure
    Random rand = Random();
    //rand.nextInt(2); // avoid always 0 value for the first call in next line
    centerZiRelated.structureAccuratePosition = rand.nextInt(2);
    var realStrucutureIndex = CenterZiRelated.getIndexByStructureValue(centerZiRelated.structureReal);
    centerZiRelated.structureWrongIndex =   CenterZiRelated.getWrongStructureIndex(realStrucutureIndex);

    var components = List<String>();
    DictionaryManager.getAllComponents(centerZiId, components);
    centerZiRelated.compCountReal = components.length;

    centerZiRelated.compCountAccuratePosition = rand.nextInt(2);
    centerZiRelated.compCountWrongValue = CenterZiRelated.getCompCountWrongValue(centerZiRelated.compCountReal);
  }
}
