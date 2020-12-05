import 'package:hanzishu/engine/lesson.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/data/sentencelist.dart';
import 'package:hanzishu/data/phraselist.dart';
import 'package:hanzishu/data/zilist.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/ui/positionmanager.dart';

class LessonManager {
  static final LessonManager _lessonManager = LessonManager._internal();
  //String theCurrentLesson = "none";
  int theLatestEnabledLesson = 1; // will be overwritten by value from storage
  static String theBeginnerLesson = "beginnerLesson";
  //static var analyzeZiYSize = thePositionManager.getZiSize(ZiOrCharSize.assembleDissembleSize);  //CGFloat(30.0)
  //static var analyzeZiYGap = 0.5 * analyzeZiYSize;    //CGFloat(15.0)

  factory LessonManager() {
    return _lessonManager;
  }
  LessonManager._internal();

  Lesson getLesson(int id) {
    return theLessonList[id];
  }

  int getLessonCount() {
    return theLessonList.length;
  }

  LessonSection getLatestSection() {
    var lessonId = theCurrentLessonId; //getLessonNumber(theCurrentLesson);
    var lesson = theLessonList[lessonId];
    return lesson.getLatestSection();
  }

  bool isALessonName(String name) {
    for (var i = 1;  i <= theTotalBeginnerLessons; i++) {
      var numberString = i.toString();
      var lessonName = theBeginnerLesson + numberString;
      if (lessonName == name) {
        return true;
      }
    }

    return false;
  }

  /*
  LessonLevel getLessonLevel(String name) {
    for (var i = 1;  i <= theTotalBeginnerLessons; i++) {
      var numberString = String(i);
      var lessonName = theBeginnerLesson + numberString;
      var intermediateName = theIntermediateLesson + numberString;
      if (lessonName == name) {
        return LessonLevel.beginner;
      }
      else if (intermediateName == name) {
        return LessonLevel.intermediate;
      }
    }

    return LessonLevel.unknown;
  }
  */

   int getLessonNumber(String name) {
    for (var i = 1; i <= theTotalBeginnerLessons; i++) {
      var numberString = i.toString();
      var lessonName = theBeginnerLesson + numberString;
      if (lessonName == name) {
        return i;
      }
    }

    return 0;
  }

  static double getNextYPosition(double currentY) {
    var maxComponents = 0;
    for (var i = 0; i <= (theCurrentZiComponents.length - 1); i++) {
      if (theCurrentZiComponents[i] > maxComponents) {
        maxComponents = theCurrentZiComponents[i];
      }
    }

    var analyzeZiYSize = thePositionManager.getZiSize(ZiOrCharSize.assembleDissembleSize);  //CGFloat(30.0)
    var analyzeZiYGap = 0.5 * analyzeZiYSize;    //CGFloat(15.0)
    var nextYPosition = currentY + (analyzeZiYSize + analyzeZiYGap) * maxComponents;

    return nextYPosition;
  }
 /*
  static double getNextXPosition(double urrentX) {
    var maxComponents = 0;
    for (var i = 0; i <= (theCurrentZiComponents.count - 1); i++) {
      if (theCurrentZiComponents[i] > maxComponents) {
        maxComponents = theCurrentZiComponents[i];
      }
    }

    var nextXPosition = currentX + (theAnalyzeZiYSize + theAnalyzeZiYGap) * CGFloat(maxComponents);

    return nextXPosition;
  }
  */

  static void clearComponentsStructure() {
    for (var i = 0; i <= (theCurrentZiComponents.length - 1); i++) {
      theCurrentZiComponents[i] = 0;
    }
  }

  static void populateLessonsInfo() {
    populateLessonsList();
    theSentenceManager.populateSubcharsAndComponents();
    populateConvCharsAndCharsList();
    populateComps();
    populateConvCharsIds();
    populateCharsIds();
    //theLessonsInitialized = true;
  }

  static void populateLessonsList() {
    for(var i=0; i < theSentenceList.length; i++) {
      theLessonList[theSentenceList[i].lessonId].sentenceList.add(theSentenceList[i].id);
    }
  }

  static void populateConvCharsAndCharsList() {
    for (var j = 1; j <= (theLessonList.length - 1); j++) {
      for (var k in theLessonList[j].sentenceList) {
        for (var eachChar in theSentenceList[k].conv.runes) {
          var char = String.fromCharCode(eachChar);
          if (!specialChar(char) && !charExists(j, char))
          {
            theLessonList[j].convChars += char; // String.fromCharCode(eachChar); //eachChar.toString();
          }
        }

        for (var eachChar in theSentenceList[k].chars.str.runes) {
          var char = String.fromCharCode(eachChar);
          if (!specialChar(char) && !charExists(j, char))
          {
            theLessonList[j].chars += char; //String.fromCharCode(eachChar);   //eachChar.toString();
          }
        }
      }
    }
  }

  static populateComps() {
    for (var j = 1; j <= theLessonList.length - 1; j++) {
      for (var k in theLessonList[j].sentenceList) {
        for (var eachComp in theSentenceList[k].comps) {
          if (!compExists(j, eachComp))
          {
            // check the parent of this non-character
            // they are not real parents, but the parent in Hanzishu hirarchy
            var compZi = theZiManager.getZi(eachComp);
            //if (compZi.parentId != theRootNonCharId) {
              if (!compExists(j, compZi.parentId)) {
                theLessonList[j].comps.add(compZi.parentId);
              }
            //}

            // add the non-char itself
            theLessonList[j].comps.add(eachComp);
          }
        }
      }
    }
  }

  static bool charExists(int lessonId, String char) {
    for (var i = 1; i <= lessonId; i++) {
      if (charExistsInLesson(i, char)) {
        return true;
      }
    }

    return false;
  }

  static bool ziIdExistsInLesson(int lessonId, int ziId) {
    return charExistsInLessonById(lessonId, ziId) || compExistsInLesson(lessonId, ziId);
  }

  static bool charExistsInLesson(int lessonId, String char) {
    return theLessonList[lessonId].convChars.contains(char) || theLessonList[lessonId].chars.contains(char);
  }

  // was charExistsInLesson before. changed to ziIdExistsInLesson
  static bool charExistsInLessonById(int lessonId, int ziId) {
    return theLessonList[lessonId].convCharsIds.contains(ziId) || theLessonList[lessonId].charsIds.contains(ziId);
  }

  static bool isZiInTreePathOfZisInLesson(int ziId, int lessonId) {
    var lesson = theLessonList[lessonId];
    for (var idB in lesson.charsIds) {
      if (theZiManager.isZiAInTreePathOfZiB(ziId, idB)) {
        return true;
      }
    }

    for (var idB in lesson.convCharsIds) {
      if (theZiManager.isZiAInTreePathOfZiB(ziId, idB)) {
        return true;
      }
    }

    for (var idB in lesson.comps) {
      if (theZiManager.isZiAInTreePathOfZiB(ziId, idB)) {
        return true;
      }
    }

    return false;
  }

  static bool isZiInTreePathOfZisInLessons(int ziId, int startLessonId, int endLessonId) {
    for (var lessonId = startLessonId; lessonId <= endLessonId; lessonId++) {
      if (isZiInTreePathOfZisInLesson(ziId, lessonId)) {
        return true;
      }
    }

    return false;
  }

  static bool compExists(int lessonId, int comp) {
    for (var i = 1; i <= lessonId; i++) {
      if (compExistsInLesson(i, comp)) {
        return true;
      }
    }

    return false;
  }

  static bool compExistsInLesson(int lessonId, int comp) {
    return theLessonList[lessonId].comps.contains(comp);
  }

  static bool specialChar(String char) {
    return char == '！' || char == '?' || char == '。' || char == '，';
  }

  static void populateConvCharsIds() {
    for (var lesson in theLessonList) {
      for (var ch in lesson.convChars.runes) {
        var char = String.fromCharCode(ch);
        var id = ZiManager.findIdFromChar(char);
        if (id != 10000) {
          lesson.convCharsIds.add(id);
        }
      }
    }
  }

  static void populateCharsIds() {
    for (var lesson in theLessonList) {
      for (var ch in lesson.chars.runes) {
        var char = String.fromCharCode(ch);
        var id = ZiManager.findIdFromChar(char);
          if (id != 10000) {
          lesson.charsIds.add(id);
        }
      }
    }
  }

  static void SetSectionCompleted(int lessonId, LessonSection lessonSection) {
    var lesson = theLessonList[lessonId];
    lesson.SetSectionCompleted(lessonSection);
  }

  static bool hasLessonCompleted(int lessonId) {
    var lesson = theLessonList[lessonId];
    return lesson.hasLessonCompleted();
  }

  static void setLessonCompleted(int lessonId) {
    var lesson = theLessonList[lessonId];
    lesson.setLessonCompleted();
  }

  /*
  static void UpdateRangeUptoLessonNumber(String theRangeOperation) {
    if (theRangeOperation == theRangeUptoLessonPlus) {
      theRangeUptoLessonNumberForCurrentLevel += 1;
      if (theRangeUptoLessonNumberForCurrentLevel > theLevelList[theCurrentLevel - 1].numberOfLessons) {
        theRangeUptoLessonNumberForCurrentLevel = theRangeFromLessonNumberForCurrentLevel;
      }
    }
    else if (theRangeOperation == theRangeUptoLessonMinus) {
      theRangeUptoLessonNumberForCurrentLevel -= 1;
      if (theRangeUptoLessonNumberForCurrentLevel == 0) {
        theRangeUptoLessonNumberForCurrentLevel = theLevelList[theCurrentLevel - 1].numberOfLessons;
      }
    }
  }

  static void UpdateRangeFromLessonNumber(String theRangeOperation) {
    if (theRangeOperation == theRangeFromLessonPlus) {
      theRangeFromLessonNumberForCurrentLevel += 1;
      if (theRangeFromLessonNumberForCurrentLevel > theLevelList[theCurrentLevel - 1].numberOfLessons) {
        theRangeFromLessonNumberForCurrentLevel = 1;
      }
    }
    else if (theRangeOperation == theRangeFromLessonMinus) {
      theRangeFromLessonNumberForCurrentLevel -= 1;
      if (theRangeFromLessonNumberForCurrentLevel == 0) {
        theRangeFromLessonNumberForCurrentLevel = theLevelList[theCurrentLevel - 1].numberOfLessons;
      }
    }

    if (theRangeUptoLessonNumberForCurrentLevel < theRangeFromLessonNumberForCurrentLevel) {
      theRangeUptoLessonNumberForCurrentLevel = theRangeFromLessonNumberForCurrentLevel;
    }
  }
  */
  List<int> getRealGroupMembers(int id) {
    // NOTE: in review mode, the theCurrentLesson might mean the last lesson in the range
    var currentLesson = theLessonList[theCurrentLessonId];
    // check cache first
    var groupMembers = currentLesson.getRealGroupMembers(id);

    if (groupMembers == null) {
      groupMembers = theZiManager.getRealGroupMembers(id);
    }

    currentLesson.addToRealGroupMembersMap(id, groupMembers);

    return groupMembers;
  }

  PositionAndSize getCenterPositionAndSize() {
    // NOTE: in review mode, the theCurrentLesson might mean the last lesson in the range
    var currentLesson = theLessonList[theCurrentLessonId];
    // check cache first
    var positionAndSize = currentLesson.getCenterPosisionAndSize();

    if (positionAndSize == null) {
      positionAndSize = thePositionManager.getPositionAndSizeHelper("m", 1, PositionManager.theBigMaximumNumber);
      currentLesson.setCenterPositionAndSize(positionAndSize);
    }

    return positionAndSize;
  }

  Map<int, PositionAndSize> getBreakoutPositions(int lessonId) {
    // NOTE: in review mode, the theCurrentLesson might mean the last lesson in the range
    var lesson = theLessonList[lessonId];

    return lesson.breakoutPositions;
  }

  /*
  // To be called only after another call to getPositionAndSize(ziId, totalSideNumberOfZis)
  PositionAndSize getPositionAndSizeFromCache(int ziId) {
    // NOTE: in review mode, the theCurrentLesson might mean the last lesson in the range
    var currentLesson = theLessonList[theCurrentLessonId];
    // get from cache
    return currentLesson.getPositionAndSize(ziId);
  }
  */

  PositionAndSize getPositionAndSize(int ziId, NumberOfZis totalSideNumberOfZis) {
    // NOTE: in review mode, the theCurrentLesson might mean the last lesson in the range
    var currentLesson = theLessonList[theCurrentLessonId];
    // check cache first
    var positionAndSize = currentLesson.getPositionAndSize(ziId);

    if (positionAndSize == null) {
      positionAndSize = thePositionManager.getPositionAndSize(ziId, totalSideNumberOfZis);
      currentLesson.addToSidePositions(ziId, positionAndSize);
    }

    return positionAndSize;
  }
}