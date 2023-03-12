import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/data/inputzilist.dart';
import 'package:hanzishu/data/componenttypinglist.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'dart:math';

import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';


class InputZiManager {
  TypingType currentTypingType = TypingType.none;
  int currentIndex = 0; // Note: to be insync with inputzipage
  static List<InputZi> typingCandidates = [];
  static List<String> previousFirstPositionList = [];
  static int maxTypingCandidates = 7; //20;
  String wordsStudy;
//  TypingType typingType;

  TypingType getCurrentType() {
    return currentTypingType;
  }

  setCurrentType(TypingType currentType, String wordsStudy) {
    if (currentTypingType != currentType) {
      currentTypingType = currentType;
      currentIndex = 0;
      this.wordsStudy = wordsStudy;
    }
  }

  getCurrentIndex(TypingType typingType) {
    return currentIndex;
  }

  setCurrentIndex(int currentIndex) {
    this.currentIndex = currentIndex;
  }

  initCurrentIndex() {
    currentIndex = 0;
  }

  static int findFirst(String input) {
    for (var i = 0; i < theInputZiList.length; i++) {
      var oneInputZi = theInputZiList[i];
      if (oneInputZi.doubleByteCode.startsWith(input)) {
        return i;
      }
    }

    return -1;
  }

  // function should pass parameter themselves
//  setCurrentType(TypingType typingType) {
//    this.typingType = typingType;
//  }

  static int findLast(int firstIndex, String input) {
    var len = theInputZiList.length;

    for (var i = firstIndex; i < len; i++) {
      var oneInputZi = theInputZiList[i];

      if (!oneInputZi.doubleByteCode.startsWith(input)) {
        return i - 1;
      }
      else if (i == len - 1) { // same and the last one in the list (for 'y')
        return len - 1;
      }
    }

    return -1;
  }

  // if a candidate is in the last letter, it can not be pushed out by a longer code.
  static canUpdate(int currentInputCodeLength, int newCandidateCodeLength,
      int activeCandidateCodeLength) {
    bool canUpdate = true;

    if (activeCandidateCodeLength == currentInputCodeLength &&
        newCandidateCodeLength > activeCandidateCodeLength) {
      canUpdate = false;
    }

    return canUpdate;
  }

  static updateCandidates(InputZi inputZi, List<InputZi> candidates,
      int currentInputCodeLength) {
    var activeCandidatesLength = min(maxTypingCandidates, candidates.length);

    if (activeCandidatesLength == 0) {
      candidates.insert(0, inputZi);
      return;
    }

    // never check the member after the maxTypingCandidates
    for (var i = 0; i < activeCandidatesLength; i++) {
      if (canUpdate(currentInputCodeLength, inputZi.doubleByteCode.length,
          candidates[i].doubleByteCode.length)) {
        if (inputZi.usageFrequency > candidates[i].usageFrequency) {
          candidates.insert(i, inputZi);
          return;
        }
      }
    }

    if (activeCandidatesLength < maxTypingCandidates) {
      candidates.insert(activeCandidatesLength, inputZi);
    }

    return;
  }

  static String convertListToString(List<InputZi> typingCandidates) {
    String candidates = "";

    for (var i = 0; i < typingCandidates.length; i++) {
      candidates += typingCandidates[i].zi;
    }

    return candidates;
  }

  static List<String> convertZiListToStringList(
      List<InputZi> typingCandidates) {
    List<String> candidates = new List<String>(typingCandidates.length);

    for (var i = 0; i < typingCandidates.length; i++) {
      candidates[i] = typingCandidates[i].zi;
    }

    return candidates;
  }

  static List<String> getZiCandidatesHelper(int start, int end,
      int currentInputCodeLength) {
    typingCandidates.clear();
    for (var i = start; i <= end; i++) {
      var oneInputZi = theInputZiList[i];
      //if (typingCandidates.length == 0 || oneInputZi.usageFrequency > typingCandidates[typingCandidates.length-1].usageFrequency) {
      //loop through the candidates from smallest to the biggest
      updateCandidates(oneInputZi, typingCandidates, currentInputCodeLength);
      //}
    }

    return convertZiListToStringList(typingCandidates);
    //return convertInputZiListToStringList(typingCandidates);
  }

  // the only public method for this feature
  // current input as input, and a string as the output
  static List<String> getZiCandidates(String input) {
    var first = findFirst(input);
    var currentInputCodeLength = input.length;
    if (first != -1) {
      var last = findLast(first, input);
      if (last != -1) {
        return getZiCandidatesHelper(first, last, currentInputCodeLength);
      }
    }

    return null;
  }

  static InputZi getFirstZiCandidate() {
    if (typingCandidates.length > 0) {
      return typingCandidates[0];
    }

    return null;
  }

  static String getCandidateZiString(int index) {
    if (theCurrentZiCandidates.length > index) {
      return theCurrentZiCandidates[index];
    }

    return null;
  }

  static candidateExistsInFirstPositionList(String oneZi,
      List<String> previousFirstPositionList) {
    for (var i = 0; i < previousFirstPositionList.length; i++) {
      if (oneZi == previousFirstPositionList[i]) {
        return true;
      }
    }

    return false;
  }

  static addNewFirstToPreviousFirstList(String oneZi,
      List<String> previousFirstPositionList) {
    for (var i = 0; i < previousFirstPositionList.length; i++) {
      if (oneZi == previousFirstPositionList[i]) {
        return;
      }
    }

    previousFirstPositionList.add(oneZi);
  }

  static pushANeverFirstToFirst(List<String> currentCandidatesToUpdate,
      List<String> previousFirstPositionList) {
    for (var i = 0; i < maxTypingCandidates &&
        i < currentCandidatesToUpdate.length; i++) {
      if (!candidateExistsInFirstPositionList(
          currentCandidatesToUpdate[i], previousFirstPositionList)) {
        if (i == 0) {
          return;
        }

        // push the value of position i into 0 (first) position
        var inputZi = currentCandidatesToUpdate[i];
        // from i to 1, shift the value of (j-1) to j.
        for (var j = i; j > 0; j--) {
          currentCandidatesToUpdate[j] = currentCandidatesToUpdate[j - 1];
        }

        currentCandidatesToUpdate[0] = inputZi;

        return;
      }
    }
  }

  // replace the first candidate if it's already displayed as the first earlier
  static updateFirstCandidate(List<String> currentCandidatesToUpdate,
      List<String> previousFirstPositionList) {
    if (currentCandidatesToUpdate == null ||
        currentCandidatesToUpdate.length <= 1) {
      return;
    }

    if (candidateExistsInFirstPositionList(
        currentCandidatesToUpdate[0], previousFirstPositionList)) {
      pushANeverFirstToFirst(
          currentCandidatesToUpdate, previousFirstPositionList);
    }

    // push the new first into the firstPostion list
    addNewFirstToPreviousFirstList(
        currentCandidatesToUpdate[0], previousFirstPositionList);
  }

  // not used any more
  /*
  static String getIntroduction(TypingType typingType, int currentIndex, int lessonId) {
    String instruction;
    //if (typingType == TypingType.GiveItATry) {
    //  instruction = theZiForIntroductionList[currentIndex].hintText;
    //}
    if (typingType == TypingType.LeadComponents) {
      instruction = getString(theZiForLeadCompExerciseList[currentIndex].hintText);
    }
    //else if (typingType == TypingType.ExpandedInitial) {
    //  instruction = theZiForExpandedInitialExerciseList[currentIndex].hintText;
    //}
    else if (typingType == TypingType.ExpandedReview) {
      instruction = getString(theZiForExpandedReviewExerciseList[currentIndex].hintText);
    }
    else if (typingType == TypingType.ExpandedGeneral) {
      instruction = getString(theZiForExpandedGeneralExerciseList[currentIndex].hintText);
    }
    else if (typingType == TypingType.AttachedComponents) {
      instruction = getString(theZiForAttachedCompExerciseList[currentIndex].hintText);
    }
    else if (typingType == TypingType.TwinComponents) {
      instruction = getString(theZiForTwinCompExerciseList[currentIndex].hintText);
    }
    else if (typingType == TypingType.SubComponents) {
      instruction = getString(theZiForSubCompExerciseList[currentIndex].hintText);
    }
    else if (typingType == TypingType.SingleComponent) {
      instruction = getString(theZiForSingleCompExerciseList[currentIndex].hintText);
    }
    else if (typingType == TypingType.TwoComponents) {
      instruction = getString(theZiForTwoCompExerciseList[currentIndex].hintText);
    }
    else if (typingType == TypingType.GeneralExercise) {
      instruction = getString(theZiForGeneralExerciseList[currentIndex].hintText);
    }
    else if (typingType == TypingType.FromLessons) {
      instruction = getString(280)/*"Reminder: You should finish the typing course from the main menu before this exercise."*/;
    }

    return instruction;
  }
*/

  // index 0->100, lessonId == exerciseId -> 1 to 38 (1 based).
  ZiWithComponentsAndStrokes getCustomizedTypingZi(int index, int lessonId) {
    // every other 38 items.
    int searchingZiId = getSearchingZiId(index, lessonId); // skip the index 0 in theSearchingZiList
    if (searchingZiId < theSearchingZiList.length) {
      var oneSearchingItem = theSearchingZiList[searchingZiId];
      var components = List<String>();
      DictionaryManager.getAllComponents(searchingZiId, components);
      return ZiWithComponentsAndStrokes(oneSearchingItem.char, components, "", 0);
    }

    return null;
  }

  ZiWithComponentsAndStrokes getZiWithComponentsAndStrokes(TypingType typingType, int index, int lessonId) {
    //if (typingType == TypingType.GiveItATry) {
    //  return theZiForIntroductionList[index];
    //}
    if (typingType == TypingType.LeadComponents) {
      return theZiForLeadCompExerciseList[index];
    }
    //else if (typingType == TypingType.ExpandedInitial) {
    //  return theZiForExpandedInitialExerciseList[index];
    //}
    else if (typingType == TypingType.ExpandedReview) {
      return theZiForExpandedReviewExerciseList[index];
    }
    else if (typingType == TypingType.ExpandedGeneral) {
      return theZiForExpandedGeneralExerciseList[index];
    }
    else if (typingType == TypingType.AttachedComponents) {
      return theZiForAttachedCompExerciseList[index];
    }
    else if (typingType == TypingType.TwinComponents) {
      return theZiForTwinCompExerciseList[index];
    }
    else if (typingType == TypingType.SubComponents) {
      return theZiForSubCompExerciseList[index];
    }
    else if (typingType == TypingType.SingleComponent) {
      return theZiForSingleCompExerciseList[index];
    }
    else if (typingType == TypingType.TwoComponents) {
      return theZiForTwoCompExerciseList[index];
    }
    else if (typingType == TypingType.GeneralExercise) {
      return theZiForGeneralExerciseList[index];
    }
    else if (typingType == TypingType.CustomizedTyping) {
      return getCustomizedTypingZi(index, lessonId);
    }
    else if (typingType == TypingType.FromLessons) {
      var zi = theLessonManager.getChar(lessonId, index);
      return ZiWithComponentsAndStrokes(
          zi.char,
          [""],
          "noimage",
          0/*"nohelpyet"*/
      );
    }
    else if (typingType == TypingType.WordsStudy) {
      return ZiWithComponentsAndStrokes(wordsStudy[index], [""], "", 0);
    }

    return null;
  }

  /*
  String getImageName(TypingType typingType, int index) {
    var zi;
    if (typingType == TypingType.ThreeOrMoreComponents) {
      zi = theZiWithThreeOrMoreComponentList[index];
    }
    else if (typingType == TypingType.TwoComponents) {
      zi = theZiWithTwoComponentList[index];
    }
    else if (typingType == TypingType.OneComponent) {
      zi = theZiWithOneComponentList[index];
    }

    return zi.comment;
  }
*/

  static int getSearchingZiId(int index, int lessonId) {
    return index * 38 + 51 + lessonId; // where 51 is the last non-char index in the searchingZilist
  }

  int getNextIndex(TypingType typingType, /*int currentIndex,*/ int lessonId) {
    currentIndex++;

    //if (typingType == TypingType.GiveItATry) {
    //  if (currentIndex >= theZiForIntroductionList.length) {
    //    currentIndex = -1;
    //  }
    //}
    if (typingType == TypingType.LeadComponents) {
      if (currentIndex >= theZiForLeadCompExerciseList.length) {
        currentIndex = -1;
      }
    }
    //else if (typingType == TypingType.ExpandedInitial) {
    //  if (currentIndex >= theZiForExpandedInitialExerciseList.length) {
    //    currentIndex = -1;
    //  }
    //}
    else if (typingType == TypingType.ExpandedReview) {
      if (currentIndex >= theZiForExpandedReviewExerciseList.length) {
        currentIndex = -1;
      }
    }
    else if (typingType == TypingType.ExpandedGeneral) {
      if (currentIndex >= theZiForExpandedGeneralExerciseList.length) {
        currentIndex = -1;
      }
    }
    else if (typingType == TypingType.AttachedComponents) {
      if (currentIndex >= theZiForAttachedCompExerciseList.length) {
        currentIndex = -1;
      }
    }
    else if (typingType == TypingType.TwinComponents) {
      if (currentIndex >= theZiForTwinCompExerciseList.length) {
        currentIndex = -1;
      }
    }
    else if (typingType == TypingType.SubComponents) {
      if (currentIndex >= theZiForSubCompExerciseList.length) {
        currentIndex = -1;
      }
    }
    else if (typingType == TypingType.SingleComponent) {
      if (currentIndex >= theZiForSingleCompExerciseList.length) {
        currentIndex = -1;
      }
    }
    else if (typingType == TypingType.GeneralExercise) {
      if (currentIndex >= theZiForGeneralExerciseList.length) {
        currentIndex = -1;
      }
    }
    else if (typingType == TypingType.CustomizedTyping) {
      // overall index = 0, 69, 77, 160
      var searchingZiId = getSearchingZiId(currentIndex, lessonId);
      // Note: there are 52 index which are not chars
      if (searchingZiId < 52 || DictionaryManager.isNonCharacter(searchingZiId) || DictionaryManager.isEmpty(searchingZiId)) {
        currentIndex++; // skip to next one
      }
      else if (searchingZiId >= theSearchingZiList.length) {
        currentIndex = -1;
      }
    }
    else if (typingType == TypingType.FromLessons) {
      //if (currentIndex >= theZiWithOneComponentList.length) {
      var lesson = theLessonManager.getLesson(lessonId);
      if (currentIndex >= lesson.convCharsIds.length + lesson.charsIds.length) {
        currentIndex = -1;
      }
    }
    else if (typingType == TypingType.WordsStudy) {
      //var lesson = theLessonManager.getLesson(lessonId);
      if (currentIndex >= wordsStudy.length) {
        currentIndex = -1;
      }
    }

    return currentIndex;
  }

  bool doesTypingResultContainTheZi(TypingType typingType, int currentIndex, String typingResult, int lessonId) {
    bool result = false;

    if (currentIndex < 0) {
      return false;
    }

    var zi;
    //if (typingType == TypingType.GiveItATry) {
    //  zi = theZiForIntroductionList[currentIndex];
    //  result = typingResult.contains(zi.zi);
    //}
    if (typingType == TypingType.LeadComponents) {
      zi = theZiForLeadCompExerciseList[currentIndex];
      result = typingResult.contains(zi.zi);
    }
    //else if (typingType == TypingType.ExpandedInitial) {
    //  zi = theZiForExpandedInitialExerciseList[currentIndex];
    //  result = typingResult.contains(zi.zi);
    //}
    else if (typingType == TypingType.ExpandedReview) {
      zi = theZiForExpandedReviewExerciseList[currentIndex];
      result = typingResult.contains(zi.zi);
    }
    else if (typingType == TypingType.ExpandedGeneral) {
      zi = theZiForExpandedGeneralExerciseList[currentIndex];
      result = typingResult.contains(zi.zi);
    }
    else if (typingType == TypingType.AttachedComponents) {
      zi = theZiForAttachedCompExerciseList[currentIndex];
      result = typingResult.contains(zi.zi);
    }
    else if (typingType == TypingType.TwinComponents) {
      zi = theZiForTwinCompExerciseList[currentIndex];
      result = typingResult.contains(zi.zi);
    }
    else if (typingType == TypingType.SubComponents) {
      zi = theZiForSubCompExerciseList[currentIndex];
      result = typingResult.contains(zi.zi);
    }
    else if (typingType == TypingType.SingleComponent) {
      zi = theZiForSingleCompExerciseList[currentIndex];
      result = typingResult.contains(zi.zi);
    }
    else if (typingType == TypingType.TwoComponents) {
      zi = theZiForTwoCompExerciseList[currentIndex];
      result = typingResult.contains(zi.zi);
    }
    else if (typingType == TypingType.GeneralExercise) {
      zi = theZiForGeneralExerciseList[currentIndex];
      result = typingResult.contains(zi.zi);
    }
    else if (typingType == TypingType.CustomizedTyping) {
      var searchingZiId = getSearchingZiId(currentIndex, lessonId);
      zi = theSearchingZiList[searchingZiId];
      result = typingResult.contains(zi.char);
    }
    else if (typingType == TypingType.FromLessons) {
      zi = theLessonManager.getChar(lessonId, currentIndex);
      result = typingResult.contains(zi.char);
    }
    else if (typingType == TypingType.WordsStudy) {
      var char = wordsStudy[currentIndex];
      result = typingResult.contains(char);
    }

    return result;
  }

  int getTotal(TypingType typingType, int lessonId) {
    //if (typingType == TypingType.GiveItATry) {
    //  return theZiForIntroductionList.length;
    //}
    if (typingType == TypingType.LeadComponents) {
      return theZiForLeadCompExerciseList.length;
    }
    //else if (typingType == TypingType.ExpandedInitial) {
    //  return theZiForExpandedInitialExerciseList.length;
    //}
    else if (typingType == TypingType.ExpandedReview) {
      return theZiForExpandedReviewExerciseList.length;
    }
    else if (typingType == TypingType.ExpandedGeneral) {
      return theZiForExpandedGeneralExerciseList.length;
    }
    else if (typingType == TypingType.AttachedComponents) {
      return theZiForAttachedCompExerciseList.length;
    }
    else if (typingType == TypingType.TwinComponents) {
      return theZiForTwinCompExerciseList.length;
    }
    else if (typingType == TypingType.SubComponents) {
      return theZiForSubCompExerciseList.length;
    }
    else if (typingType == TypingType.SingleComponent) {
      return theZiForSingleCompExerciseList.length;
    }
    else if (typingType == TypingType.TwoComponents) {
      return theZiForTwoCompExerciseList.length;
    }
    else if (typingType == TypingType.GeneralExercise) {
      return theZiForGeneralExerciseList.length;
    }
    else if (typingType == TypingType.CustomizedTyping) {
      int total = ((theSearchingZiList.length - 52) / 38).truncate();    // 37
      int remain = (theSearchingZiList.length - 52) % 38; // first 30
      if (lessonId <= remain) {
        total += 1;
      }
      return total;
    }
    else if (typingType == TypingType.FromLessons) {
      var lesson = theLessonManager.getLesson(lessonId);
      return lesson.convCharsIds.length + lesson.charsIds.length;
    }
    else if (typingType == TypingType.WordsStudy) {
      return wordsStudy.length;
    }

    return -1;
  }
}