import 'package:hanzishu/data/zilist.dart';
import 'package:hanzishu/engine/zi.dart';
import 'package:hanzishu/engine/levelmanager.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/componentmanager.dart';

enum ZiListType {
  zi,
  searching,
  component,
  stroke
}

class NumberOfZis {
  int left;
  int right;
  int upper;
  int bottom;

  NumberOfZis(int left,
    int right,
    int upper,
    int bottom) {
    this.left = left;
    this.right = right;
    this.upper = upper;
    this.bottom = bottom;
  }
}

class IdAndListTypePair {
  int id;
  ZiListType listType;

  IdAndListTypePair(int id, ZiListType listType) {
    this.id = id;
    this.listType = listType;
  }
}

class ZiManager {
  static final ZiManager _ziManager = ZiManager._internal();
  factory ZiManager() {
    return _ziManager;
  }

  ZiManager._internal();

  Zi getZi(int id) {
    return theZiList[id];
  }

  bool isBasicZi(int id) {
    var zi = getZi(id);
    return zi.isBasicZi();
  }

  int getZiListLength() {
    return theZiList.length;
  }

  Zi getZiByChar(String char) {
    for (var zi in theZiList) {
      if (zi.char.runes.length == 1 && zi.char.runes.first == char.runes.first) { // TODO: char[0] is codeUnit, not rune. Is it always same in our case?
        return zi;
      }
    }

    return null;
  }

  static int findIdFromChar(String char) {
    for (var eachZi in theZiList) {
      if (eachZi.char.runes.length == 1 && eachZi.char.runes.first == char.runes.first) {
        return eachZi.id;
      }
    }

    return 10000;  // not found
  }

  bool isIdAZi(String idName) {
    var id = Utility.StringToInt(idName);
    if (id != null) {
      return true;
    }
    else {
      return false;
    }
  }

  static bool isZiWithPopup(int tagOrId) {
    return (tagOrId > 10000) ? true : false;
  }

  bool hasFinishedQuiz(int id){
    var zi = getZi(id);
    return zi.hasFinishedQuiz;
  }

  void UpdateHasFinishedQuiz(int id) {
    var zi = getZi(id);
    zi.hasFinishedQuiz = true;
  }

  void clearHasFinishedQuizFlag() {
    for (var zi in theZiList) {
      if (zi.hasFinishedQuiz != null && zi.hasFinishedQuiz == true) {
        zi.hasFinishedQuiz = false;
      }
    }
  }

  // count number of zis in all sides
  NumberOfZis getNumberOfZis(List<int> groupMembers) {
    var numberOfZis = NumberOfZis(0, 0, 0, 0);

    for (var memberZiId in groupMembers) {
      var memberZi = getZi(memberZiId);
      var displaySideString = memberZi.displaySide;
      switch (displaySideString) {
        case "l":
          numberOfZis.left = numberOfZis.left + 1;
          break;
        case "r":
          numberOfZis.right = numberOfZis.right + 1;
          break;
        case "u":
          numberOfZis.upper  = numberOfZis.upper + 1;
          break;
        case "b":
          numberOfZis.bottom = numberOfZis.bottom + 1;
          break;
        default:
          break;
      }
    }

    return numberOfZis;
  }

  List<int> getGroupMembers(int id) {
    var zi = getZi(id);
    return zi.groupMembers;
  }

  // consider the case for each lesson
  List<int> getRealGroupMembers(int id, int internalStartLessonId, int internalEndLessonId) {
    if (internalStartLessonId == internalEndLessonId) {
      if (id == 1) {
        return LessonManager.getRootMembersForLesson(internalStartLessonId);
      }
      else if (id == theConst.starCharId) {
        return LessonManager.getRootNonCharMembersForLesson(internalStartLessonId);
      }
    }

    var zi = getZi(id);
    var groupMembers = zi.groupMembers;

    List<int> lessonGroupMembers = [];

    var showZi = false;
    for (var memberZiId in groupMembers) {
      showZi = false;
      //if (theHittestState == HittestState.hanzishuLesson || theHittestState == HittestState.ziAndSidingShuLesson || theHittestState == HittestState.quizShuLesson) {
        //showZi = showZiForLessonId(memberZiId, theCurrentLessonId);
      //}
      //else {
      //  var internalStartLesson = LevelManager.getInternalLessonId(LevelLessonPair(theLevelManager.theCurrentLevel, theRangeFromLessonNumberForCurrentLevel));
      //  var internalLesson = LevelManager.getInternalLessonId(LevelLessonPair(theLevelManager.theCurrentLevel, theRangeUptoLessonNumberForCurrentLevel));
        showZi = showZiForLessons(memberZiId, internalStartLessonId, internalEndLessonId);
      //}

      if (showZi) {
        lessonGroupMembers.add(memberZiId);
      }
    }

    //TODO: same to internalEndLessonId's memory of internalEndLesson.getRealGroupMembers(id); addToRealGroupMembersMap(id, groupMembers);
    // at the beginning of this function, call get, at here, call add.
    // But not sure what to do about review and lesson mode which would use the same lesson memory. Refresh every time?
    //List<int> getRealGroupMembersFromCache(int id, int lessonId)
    //addToRealGroupMembersMapCache(int id, List<int>groupMembers, int lessonId)
    return lessonGroupMembers;
  }

  static bool isNonCharWithOneCharName(int id) {
    if ( id == 12 || id == 13 || id == 14 || id == 19) {
      return true;
    }

    return false;
  }

  // for example: "j" and "sj" both contain "j"
  bool containSameSubType(String typeOne, String typeTwo) {
    for (var char1 in typeOne.runes) {
      for (var char2 in typeTwo.runes) {
        if (char1 == char2) {
          return true;
        }
      }
    }

    return false;
  }

  bool showZiForLessons(int ziId, int startLesson, int endLesson) {
    for (var lessonId = startLesson; lessonId <= endLesson; lessonId++) {
      if (showZiForLessonId(ziId, lessonId)) {
        return true;
      }
    }

    return false;
  }

  // check whether given zi id is in the lesson or parent (parent of parent etc) of any zi in the lesson
  bool showZiForLesson(int ziId, String lessonName) {
    var lessonId = theLessonManager.getLessonNumber(lessonName);
    return showZiForLessonId(ziId, lessonId);
  }

  // NOTE: don't call this directly. call through GeneralManager's version
  bool showZiForLessonId(int ziId, int lessonId) {
    return LessonManager.isZiInTreePathOfZisInLesson(ziId, lessonId);
  }

  // check whether A is in the parent tree path of B, including the case of A==B
  bool isZiAInTreePathOfZiB(int ziIdA, int ziIdB) {
    var pathZiIdB = ziIdB;

    while (pathZiIdB != 0 /*&& (PositionManager.isRootZiId(ziIdA) || (!PositionManager.isRootZiId(ziIdA) && !PositionManager.isRootZiId(pathZiIdB)))*/) {
      if (pathZiIdB == ziIdA) {
        return true;
      }
      else {
        var lessonZi = theZiManager.getZi(pathZiIdB);
        pathZiIdB = lessonZi.parentId;
      }
    }

    return false;
  }

  // assume ziId isn't a rootMember itself
  int getRootMember(int ziId) {
    var pathZiId = ziId;

    while (pathZiId != 0 ) {
        var lessonZi = theZiManager.getZi(pathZiId);
        if (lessonZi != null) {
          if (Utility.isPseudoRootZiId(lessonZi.parentId) || Utility.isPseudoNonCharRootZiId(lessonZi.parentId)) {
            return pathZiId;
          }
          else {
            pathZiId = lessonZi.parentId;
          }
        }
        else {
          return 0;
        }
    }

    return 0;
  }

  // get the rest zi id of the given part
  int getPartialZiId(int centerZiId, int memberZiId) {
    var zi = getZi(memberZiId);
    if (zi.type == "h") {
      var composites = zi.bodyComposites;

      List<int> compositesIds = [];
      for (var i = 0; i < composites.length; i++) {
        compositesIds.add(Utility.StringToInt(composites[i]));
      }

      if (compositesIds.length == 2) { // only handle the 2 case for now
        if (compositesIds[0] == centerZiId) {
          return compositesIds[1];
        }
        else {
          return compositesIds[0];
        }
      }
    }

    return memberZiId;
  }

  int getParentZiId(int ziId) {
    var zi = getZi(ziId);
    return zi.parentId;
  }

  List<int> getZiComponents(int id) {
    List<int> components = [];
    var zi = theZiManager.getZi(id);

    // Check whether it's single or combined word
    if (zi.isSingleBody && zi.bodyComposites.length == 0)
    {
      return null;
    }
    else //composit zi
    {
      var ziCombined = zi.bodyComposites;
      var i = 0;

      if (ziCombined[0] == "Z") {
        // Normally 2, but could be more.
        while (i < ziCombined.length) {
          if (ziCombined[i] == "Z")
          {
            var ziName = ziCombined[i+1];
            components.add(Utility.StringToInt(ziName));
           //let memberZiId = StringToInt(str: ziName)!
          }

          i += 7;
          }
        }
      else {  // the new comma separated components for components or strokes
        while (i < ziCombined.length) {
          components.add(Utility.StringToInt(ziCombined[i]));
          i += 1;
        }
      }
    }

    return components;
  }

  void getAllZiComponents(int id, List<int> allComponents) {
    List<int> ziComponents = getZiComponents(id);
    for (var i = 0; i < ziComponents.length; i++) {
      var compId = ziComponents[i];
      var zi = getZi(compId);
      if (zi.isBasicZi()) {
        allComponents.add(compId);
      }
      else {
        getAllZiComponents(compId, allComponents);
      }
    }
  }

  static int getCharById(int ziId)  {
    for (var eachZi in theZiList) {
      if (eachZi.id == ziId) {
        if (eachZi.char.runes.length > 0) {
          var char = eachZi.char.runes.first;
          return char;
        }
        break;
      }
    }

    return null;
  }

  String getZiType(int id) {
    var zi = getZi(id);

    if (zi.type == "f") {
      var referenceId = zi.parentId;
      var referenceZi = getZi(referenceId);

      return referenceZi.type;
    }
    else {
      return zi.type;
    }
  }

  bool isPianpang(int id) {
    if (getZiType(id).contains('b')) {
      return true;
    }
    else {
      return false;
    }
  }

  bool isStroke(int id) {
    return getZiType(id).contains('s');
  }

  bool isJichuZi(int id) {
    return getZiType(id).contains('j');
  }

  bool isHechenZi(int id) {
    return getZiType(id).contains('h');
  }

  bool isJichuOrNoncharZi(int id) {
    var type = getZiType(id);
    return (type.contains('j') || type.contains('b'));
  }

  Zi getPianpangZi(int id) {
    var zi = getZi(id);
    if (zi.type == 'b') {
      return zi;
    }

    if (zi.type == 'f') {
      var referenceId = zi.parentId;
      var referenceZi = getZi(referenceId);
      if (referenceZi.type == 'b') {
        return referenceZi;
      }
    }

    return null;
  }

  /* TODO: region is no longer used any more
  // ten region of Hanzishu
  int getEntryGraphCharRegion(int id) {
    // the id for char "-" is 170
    var region = 0;

    if (id == 170) {
      region = 1;
    }
    else if (id == 2 || (id >= 4 && id <= 10)) {
      region = id;
    }
    else if (id == 11) {
      region = 3;
    }
    else if (id == 1) {   // the default empty root zi
      region = 0;
    }

    return region;
  }
  */

  bool isEntryGraphChar(int id){
    if (id == 170 || id == 2 || (id >= 4 && id <= 11)) {
      return true;
    }

    return false;
  }

  static int getNonRootStandardCharCompId(int id) {
    var zi = theZiManager.getZi(id);
    var countOfStandardNonRootCharComp = 0;
    var nonRootStandardId = 0;

    // Check whether it's single or combined word
    if (zi.isSingleBody || zi.type.contains("j"))
    {
      return 0;
    }
    else //composit zi
    {
      var ziCombined = zi.bodyComposites;

      var i = 0;

      if (ziCombined.count == 0) {
        return 0;
      }

      if (ziCombined[0] == "Z") {// Normally 2, but could be more.
        while (i < ziCombined.count) {
          if (ziCombined[i] == "Z" && ziCombined[i+6] == "0")
          {
            var ziName = ziCombined[i+1];
            var memberZiId = Utility.StringToInt(ziName);
            var memberZi = theZiManager.getZi(id: memberZiId);
            if (memberZi.type.contains('h') || memberZi.type.contains('j')) {
              countOfStandardNonRootCharComp += 1;
              nonRootStandardId = memberZiId;
            }
          }

          i += 7;
          if (countOfStandardNonRootCharComp > 1) {
            break;
          }
        }
      }
      else {// new com ma separated zi ids for components and strokes
        if (ziCombined.count > 2 ||     // cann't have non-root char in this case. has to display the whole char with all the components
          ziCombined.count == 1) {     // invalide case
          return 0;
        }

        var ziId = 0;
        var zi0 = Utility.StringToInt(ziCombined[0]);
        if (zi.parentId != zi0) {
          ziId = zi0;
        }

        if (ziId == 0) {
          var zi1 = Utility.StringToInt(ziCombined[1]);
          if (zi.parentId != zi1) {
            ziId = zi1;
          }
        }
        else {
          var zi1 = Utility.StringToInt(ziCombined[1]);
          if (zi.parentId != zi1) {
            // both are not root, not valid
            return 0;
          }
        }

        // TODO: handle case of two comps have the same root id
        if (ziId != 0) {
          var zi = theZiManager.getZi(id: ziId);
          if (zi.type.contains("h") || zi.type.contains("j") || zi.type.contains("b")) {
            return ziId;
          }
        }

        return 0;
      }
    }

    if (countOfStandardNonRootCharComp == 1) {
      return nonRootStandardId;
    }
    else {
      return 0;
    }
  }

  static int getZiComponentCount(int id) {
    var components = theZiManager.getZiComponents(id);
    if (components != null) {
      return components.length;
    }
    else {
      return -1;
    }
  }

  //TODO: clean up the two functions
  static int getNonRootNonCharCompId(id) {
    var zi = theZiManager.getZi(id);
    var countOfStandardNonRootCharComp = 0;
    var nonRootStandardId = 0;

    // Check whether it's single or combined word
    if (zi.isSingleBody)
    {
      return 0;
    }
    else //composit zi
    {
      var ziCombined = zi.bodyComposites;

      var i = 0;
      if (ziCombined.count == 0) {
        return 0;
      }

      if (ziCombined[0] == "Z") {
        // Normally 2, but could be more.
        while (i < ziCombined.count) {
          if (ziCombined[i] == "Z" && ziCombined[i+6] == "0")
          {
            var ziName = ziCombined[i+1];
            var memberZiId = Utility.StringToInt(ziName);
            var memberZi = theZiManager.getZi(memberZiId);
            if (memberZi.type.contains("h") || memberZi.type.contains("j")) {
              countOfStandardNonRootCharComp += 1;
              nonRootStandardId = memberZiId;
            }
          }

          i = i + 7;
          if (countOfStandardNonRootCharComp > 1) {
            break;
          }
        }
      }
      else {// new comma separated zi ids for components and strokes
        if (ziCombined.count > 2 ||     // cann't have non-root char in this case. has to display the whole char with all the components
          ziCombined.count == 1) {     // invalide case
          return 0;
        }

        var ziId = 0;
        var zi0 = Utility.StringToInt(ziCombined[0]);
        if (zi.parentId != zi0) {
          ziId = zi0;
        }

        if (ziId == 0) {
          var zi1 = Utility.StringToInt(ziCombined[1]);
          if (zi.parentId != zi1) {
            ziId = zi1;
          }
        }

        // TODO: handle case of two comps have the same root id

        if (ziId != 0) {
          //let zi = theZiManager.getZi(id: ziId)!
          //if (zi.type.contains("h") || zi.type.contains("j")) {
          return ziId;
          //}
        }

        return 0;
      }
    }

    if (countOfStandardNonRootCharComp == 1) {
      return nonRootStandardId;
    }
    else {
      return 0;
    }
  }

  static String getPinyinAndMeaning(int ziId) {
    return theZiList[ziId].getPinyinAndMeaning();
  }

  static String getOnePinyinAndMeaning(int id, ZiListType listType) {
    if (listType == ZiListType.zi) {
      return ZiManager.getPinyinAndMeaning(id);
    }
    else if (listType == ZiListType.searching) {
      return DictionaryManager.getPinyinAndMeaning(id);
    }
    else {
      return ComponentManager.getPinyinAndMeanging(id);
    }
  }

  static String getOneChar(int id, ZiListType listType) {
    if (listType == ZiListType.zi) {
      return theZiManager.getZi(id).char;
    }
    else if (listType == ZiListType.searching) {
      return DictionaryManager.getChar(id);
    }
    else {
      return ComponentManager.getComponent(id).charOrNameOfNonchar;
    }
  }
}