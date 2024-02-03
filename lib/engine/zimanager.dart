import 'package:hanzishu/data/searchingzilist.dart';
//import 'package:hanzishu/data/zilist.dart';
import 'package:hanzishu/data/drillmenulist.dart';
import 'package:hanzishu/engine/zi.dart';
import 'package:hanzishu/engine/lessonmanager.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/componentmanager.dart';

enum ZiListType {
  zi,
  searching,
  component,
  stroke,
  phrase,
  custom
}

class ZiListTypeWrapper {
  ZiListType value;
  ZiListTypeWrapper(var value) {
    this.value = value;
  }
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

  SearchingZi getZi(int id) {
    return theSearchingZiList[id];
  }

  bool isBasicZi(int id) {
    var zi = getZi(id);
    return true; //zi.isBasicZi(); //TODO
  }

  int getZiListLength() {
    return theSearchingZiList.length;
  }

  SearchingZi getZiByChar(String char) {
    for (var zi in theSearchingZiList) {
      if (zi.char.runes.length == 1 && zi.char.runes.first == char.runes
          .first) { // TODO: char[0] is codeUnit, not rune. Is it always same in our case?
        return zi;
      }
    }

    return null;
  }

  static int findIdFromChar(ZiListType listType, String char) {
    if (listType == ZiListType.zi) {
      for (var eachZi in theSearchingZiList) {
        if (eachZi.char.runes.length == 1 &&
            eachZi.char.runes.first == char.runes.first) {
          return eachZi.id;
        }
      }
    }
    else if (listType == ZiListType.searching) {
      for (int i = 52; i < theSearchingZiList.length; i++) {
        var saerchingZi = theSearchingZiList[i];
        if (saerchingZi.char.runes.length == 1 &&
            saerchingZi.char.runes.first == char.runes.first) {
          return saerchingZi.id;
        }
      }
    }

    return -1; // not found
  }

  static SearchingZi findSearchingZiFromChar(String char) {
    var index = findIdFromChar(ZiListType.searching, char);
    if (index == -1) {
      return null;
    }
    else {
      return theSearchingZiList[index];
    }
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

  bool hasFinishedQuiz(int id) {
    var zi = getZi(id);
    return true; // zi.hasFinishedQuiz; //TODO
  }

  void UpdateHasFinishedQuiz(int id) {
    var zi = getZi(id);
    // zi.hasFinishedQuiz = true; //TODO
  }

  void clearHasFinishedQuizFlag() {
    /*
    for (var zi in theSearchingZiList) {
      if (zi.hasFinishedQuiz != null && zi.hasFinishedQuiz == true) {
        zi.hasFinishedQuiz = false;
      }
    }
    */
  }

  // count number of zis in all sides
  NumberOfZis getNumberOfZis(ZiListType listType, List<int> groupMembers) {
    var numberOfZis = NumberOfZis(0, 0, 0, 0);

    for (var memberZiId in groupMembers) {
      var displaySideString;

      if (listType == ZiListType.zi) {
        var memberZi = getZi(memberZiId);
        displaySideString = Utility.checkAndUpdateOneCharSideForLessonTwo(
            memberZiId, memberZi.displaySide);
      }
      else if (listType == ZiListType.searching) {
        displaySideString = theSearchingZiList[memberZiId].displaySide;
      }

      switch (displaySideString) {
        case "l":
          numberOfZis.left = numberOfZis.left + 1;
          break;
        case "r":
          numberOfZis.right = numberOfZis.right + 1;
          break;
        case "u":
          numberOfZis.upper = numberOfZis.upper + 1;
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

  /*
  List<int> getRealGroupMembersForDrill(int id, DrillCategory drillCategory, int level, int lesson) {
    if (drillCategory == DrillCategory.all) {
      return theSearchingZiList[id].groupMembers;
    }
    else if (drillCategory == DrillCategory.hsk) {
      var groupMembers = theSearchingZiList[id].groupMembers;
      List<int> realGroupMembers = [];

      for (var memberZiId in groupMembers) {
          if (memberZiId or children is in level) {
            //((internalEndLessonId > 0 && filterValue == internalEndLessonId) || (internalEndLessonId == 0 && filterValue <= 7))) {  // 7 is the highest hsk level
            realGroupMembers.add(memberZiId);
          }
      }
      return realGroupMembers;
    }
  }
  */

  // consider the case for each lesson
  List<int> getRealGroupMembers(int id, ZiListType listType, DrillCategory drillCategory, int internalStartLessonId, int internalEndLessonId) {
    //TODO: filter by endId
    List<int> realGroupMembers = [];
    if (listType == ZiListType.searching) {
      if (drillCategory == DrillCategory.all) {
        return theSearchingZiList[id].groupMembers;
      }
      else if (drillCategory == DrillCategory.hsk || drillCategory == DrillCategory.custom) { // hsk & custom
        //List<int> realGroupMembers = [];
        var filter;
        var filterMember;
        var filterValue;
        List<int> tempGroupMembers = [];
        var groupMembers = theSearchingZiList[id].groupMembers;

        if (drillCategory == DrillCategory.custom &&
            id == 1) { // skip the pseudo layer from root level
          var tmpMembers;
          for (var memberId in groupMembers) {
            tmpMembers = theSearchingZiList[memberId].groupMembers;
            tempGroupMembers.addAll(tmpMembers);
          }
          groupMembers = tempGroupMembers;
        }

        for (var memberZiId in groupMembers) {
          filter = theDictionaryManager.getCurrentRealFilterList();
          filterValue = filter[memberZiId];
          if (drillCategory == DrillCategory.all ||
              (internalStartLessonId <= filterValue &&
                  filterValue <= internalEndLessonId)) {
            realGroupMembers.add(memberZiId);
          }
        }
        //return realGroupMembers;
      }
      else if (drillCategory == DrillCategory.hanzishu) {
        // ZiListType.zi
        if (internalStartLessonId == internalEndLessonId) {
          if (id == 1) {
            return LessonManager.getRootMembersForLesson(internalStartLessonId);
          }
          else if (id == TheConst.starCharId) {
            //return LessonManager.getRootNonCharMembersForLesson(
            //    internalStartLessonId);
          }
        }

        var zi = getZi(id);
        var groupMembers = zi.groupMembers;

        //List<int> lessonGroupMembers = [];

        var showZi = false;
        for (var memberZiId in groupMembers) {
          showZi = false;
          showZi = showZiForLessons(
              memberZiId, internalStartLessonId, internalEndLessonId);

          if (showZi) {
            realGroupMembers.add(memberZiId);
          }
        }
      }
    }

    //TODO: same to internalEndLessonId's memory of internalEndLesson.getRealGroupMembers(id); addToRealGroupMembersMap(id, groupMembers);
    // at the beginning of this function, call get, at here, call add.
    // But not sure what to do about review and lesson mode which would use the same lesson memory. Refresh every time?
    //List<int> getRealGroupMembersFromCache(int id, int lessonId)
    //addToRealGroupMembersMapCache(int id, List<int>groupMembers, int lessonId)
    return realGroupMembers;
  }

  static bool parentIdEqual1(DrillCategory category, int ziId) {
    if (category == DrillCategory.custom) {
      return theSearchingZiList[ziId].parentId == 1;
    }

    return false;
  }

  /*
  List<SearchingZi> getOriginalDrillFilterList(DrillCategory drillCategory) {
    if (drillCategory == DrillCategory.custom) {
      return null;
    }

    var filterList;
    switch(drillCategory) {
      case DrillCategory.all:
        filterList = theSearchingZiFilterList[0];
        break;
      case DrillCategory.hanzishu:
        filterList = theSearchingZiFilterList[1];
        break;
      case DrillCategory.hsk:
        filterList = theSearchingZiFilterList[2];
        break;
      //case DrillCategory.hskTestSound:
      //  filterList = theSearchingZiFilterList[3];
      //  break;
      //case DrillCategory.hskTestMeaning:
      //  filterList = theSearchingZiFilterList[4];
      //  break;
      //case DrillCategory.custom:
      default:
        filterList = theSearchingZiFilterList[0];
        break;
    }

    return filterList;
  }

  List<int> getRealFilterList(DrillCategory drillCategory) {
    var filterList;
    switch(drillCategory) {
      case DrillCategory.all:
        filterList = theSearchingZiRealFilterList[0];
        break;
      case DrillCategory.hanzishu:
        filterList = theSearchingZiRealFilterList[1];
        break;
      case DrillCategory.hsk:
        filterList = theSearchingZiRealFilterList[2];
        break;
      case DrillCategory.custom:
        filterList = theSearchingZiRealFilterList[3];
        break;
      default:
        filterList = theSearchingZiRealFilterList[0];
        break;
    }

    return filterList;
  }

  static int getFilterIndexByCategory(DrillCategory drillCategory) {
    var filterIndex;
    switch(drillCategory) {
      case DrillCategory.all:
        filterIndex = 0;
        break;
      case DrillCategory.hanzishu:
        filterIndex = 1;
        break;
      case DrillCategory.hsk:
        filterIndex = 2;
        break;
      case DrillCategory.custom:
        filterIndex = 3;
        break;
      default:
        filterIndex = 0;
        break;
    }

    return filterIndex;
  }
*/

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

  SearchingZi getSearchingZi(int id) {
    return theSearchingZiList[id];
  }

  int getRootCharOrStar(int ziId, ZiListType listType) {
    var pathZiId = ziId;

    while (pathZiId != 0 ) {

      var lessonZi;
      if (listType == ZiListType.zi) {
        lessonZi = theZiManager.getZi(pathZiId);
      }
      else { // searchingzi
        lessonZi = theZiManager.getSearchingZi(pathZiId);
      }

      if (lessonZi != null) {
        // the second layer structure which parent is the pseudo root zi
        // only the root zi (over 200) can have parent of pseudo root zi (10 of them)
        //if (listType == ZiListType.zi) {
        //  if (Utility.isPseudoRootZiId(lessonZi.parentId)) {
        //    return pathZiId;
        //  }
        //}
        //else { // searchingzi
          if (Utility.isSearchingPseudoZiId(lessonZi.parentId)) {
            return pathZiId;
          }
        //}
        if (Utility.isStarChar(lessonZi.parentId)) {
          return TheConst.starCharId;
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
  // assume ziId isn't a rootMember itself
  int getRootMember(int ziId) {
    var pathZiId = ziId;

    while (pathZiId != 0 ) {
        var lessonZi = theZiManager.getZi(pathZiId);
        if (lessonZi != null) {
          //if (Utility.isPseudoRootZiId(lessonZi.parentId) || Utility.isPseudoNonCharRootZiId(lessonZi.parentId)) {
          //  return pathZiId;
          //}
          //else {
            pathZiId = lessonZi.parentId;
          //}
        }
        else {
          return 0;
        }
    }

    return 0;
  }

  // get the rest zi id of the given part
  int getPartialZiId(ZiListTypeWrapper listTypeWrapper, centerZiId, int memberZiId) {
    var isHetizi;
    var composits;

    if (listTypeWrapper.value == ZiListType.zi) {
      /* TODO
      var zi = getZi(memberZiId);
      isHetizi = (zi.type == "h");
      composits = zi.bodyComposites;
       */
    }
    else if (listTypeWrapper.value == ZiListType.searching) {
      isHetizi = (theSearchingZiList[memberZiId].composit.length > 1);
      composits = theSearchingZiList[memberZiId].composit;
    }

    if (isHetizi && composits.length == 2) { // only handle the 2 comp case for now
      // start for searchingZi only
      var char0 = composits[0].codeUnitAt(0);
      var substr0IsChars = false;
      if (char0 < 48 || char0 > 57) { // '0 == 48, '9' == 57
        substr0IsChars = true;
      }

      var char1 = composits[1].codeUnitAt(0);
      var substr1IsChars = false;
      if (char1 < 48 || char1 > 57) {
        substr1IsChars = true;
      }

      if (substr0IsChars && substr1IsChars) {
        return memberZiId;
      }
      else if (substr0IsChars) {
        //listTypeWrapper.value = ZiListType.component;
        var composit1Id = Utility.StringToInt(composits[1]);
        if (composit1Id != centerZiId) {
          return memberZiId;
        }
        else {
          listTypeWrapper.value = ZiListType.component;
          return ComponentManager.getComponentIdByCode(composits[0]);
        }
      }
      else if (substr1IsChars) {
        //listTypeWrapper.value = ZiListType.component;
        var composit0Id = Utility.StringToInt(composits[0]);
        if (composit0Id != centerZiId) {
          return memberZiId;
        }
        else {
          listTypeWrapper.value = ZiListType.component;
          return ComponentManager.getComponentIdByCode(composits[1]);
        }
      }
      // end for searching zi only

      List<int> compositIds = [];
      for (var i = 0; i < composits.length; i++) {
        //int compi = Utility.StringToInt(composits[i]);
        compositIds.add(Utility.StringToInt(composits[i]));
      }

      if (compositIds[0] == centerZiId) {
        return compositIds[1];
      }
      else {
        return compositIds[0];
      }
    }

    return memberZiId;
  }

  int getParentZiId(ZiListType listType, int ziId) {
    var ziOrSearchingZi;
    if (listType == ZiListType.zi) {
      ziOrSearchingZi = getZi(ziId);
    }
    else if (listType == ZiListType.searching) {
      ziOrSearchingZi = theSearchingZiList[ziId];
    }

    return ziOrSearchingZi.parentId;
  }

  // check whether ziToCheckParent is in the parent path of ziId
  bool isADistantParentOf(ZiListType listType, int startingCenterZiId, int ziToCheckParent) {
    if (startingCenterZiId == ziToCheckParent) {
      return false;
    }

    var ziOrSearchingZi;
    if (listType == ZiListType.zi) {
      ziOrSearchingZi = getZi(startingCenterZiId);
    }
    else if (listType == ZiListType.searching) {
      ziOrSearchingZi = theSearchingZiList[startingCenterZiId];
    }

    while (true) {
      if (ziOrSearchingZi.id == 1) {
        return false;
      }

      if (ziOrSearchingZi.id == ziToCheckParent) {
        return true;
      }
      else {
        var parent = ziOrSearchingZi.parentId;

        if (listType == ZiListType.zi) {
          ziOrSearchingZi = getZi(parent);
        }
        else if (listType == ZiListType.searching) {
          ziOrSearchingZi = theSearchingZiList[parent];
        }
      }
    }

    return false;
  }

  List<int> getZiComponents(int id) {
    List<int> components = [];

      var zi = theZiManager.getZi(id);
      // Check whether it's single or combined word

      if (zi.isBasicZi() /*zi.isSingleBody*/ || zi.bodyComposites.length == 0) {
        return null;
      }
      else //composit zi
          {
        var ziCombined = zi.bodyComposites;
        var i = 0;

        if (ziCombined != null && ziCombined[0] == "Z") {
          // Normally 2, but could be more.
          while (i < ziCombined.length) {
            if (ziCombined[i] == "Z") {
              var ziName = ziCombined[i + 1];
              components.add(Utility.StringToInt(ziName));
              //let memberZiId = StringToInt(str: ziName)!
            }

            i += 7;
          }
        }
        else { // the new comma separated components for components or strokes
          while (i < ziCombined.length) {
            components.add(Utility.StringToInt(ziCombined[i]));
            i += 1;
          }
        }
      }

    return components;
  }

  void getAllZiComponents(int id, List<int> allComponents) {
    /*
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
     */
  }

  static int getCharById(int ziId)  {
    for (var eachZi in theSearchingZiList) {
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
    return "";
    /*
    var zi = getZi(id);

    if (zi.type == "f") {
      var referenceId = zi.parentId;
      var referenceZi = getZi(referenceId);

      return referenceZi.type;
    }
    else {
      return zi.type;
    }
     */
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
    /*
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
    */
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

  /*
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
  */

  static int getZiComponentCount(int id) {
    var components = theZiManager.getZiComponents(id);
    if (components != null) {
      return components.length;
    }
    else {
      return -1;
    }
  }

  /*
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
  */

  static String getPinyinAndMeaning(int ziId) {
    return "NOTUSED"; //theSearchingZiList[ziId].getPinyinAndMeaning();
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

  static bool isSearchingListIDIndexOnly(int searchingListID) {
    if (searchingListID >= 1 && searchingListID <= 51) {
      return true;
    }

    return false;
  }

  static bool isParentOfASearchingListIDIndexOnly(int searchingListID) {
    var parentID = theSearchingZiList[searchingListID].parentId;
    if (parentID >= 1 && parentID <= 51) {
      return true;
    }

    return false;
  }

  static bool isParentOfASearchingListIDPseudo(int searchingListID) {
      var parentID = theSearchingZiList[searchingListID].parentId;
      if (parentID >= 27 && parentID <= 51) {
        return true;
      }

      return false;
  }

  static List<IdAndListTypePair> getComposits(int id, ZiListType listType/*, String wordsStudy*/) {
    List<IdAndListTypePair> pairList = [];

    if (listType == ZiListType.searching) {
      return theDictionaryManager.getComposits(id);
    }
    //else if (listType == ZiListType.custom) {
    //  var searchingZiId = ZiManager.findIdFromChar(ZiListType.searching, wordsStudy[id]);
    //  return theDictionaryManager.getComposits(searchingZiId);
    //}
    else if (listType == ZiListType.zi) {
      var zi = theZiManager.getZi(id);
      if (zi.type == "h")
      {
        var composits = theZiManager.getZiComponents(id);
        var count = composits.length;
        if (count > 0) {
          for (var i = 0; i < count; i++) {
            pairList.add(IdAndListTypePair(composits[i], ZiListType.zi));
          }
          return pairList;
        }
      }
    }

    return null;
  }
}