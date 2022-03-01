import 'package:flutter/material.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/data/inputzilist.dart';
import 'package:hanzishu/data/componenttypinglist.dart';
import 'dart:math';

import 'package:hanzishu/variables.dart';


class InputZiManager {
  static List<InputZi> typingCandidates = [];
  static List<String> previousFirstPositionList = [];
  static int maxTypingCandidates = 7; //20;
//  TypingType typingType;

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

  static String getIntroduction(TypingType typingType, int currentIndex, int lessonId) {
    String instruction;
    if (typingType == TypingType.GiveItATry) {
      instruction = theZiForIntroductionList[currentIndex].hintText;
    }
    else if (typingType == TypingType.LeadComponents) {
      instruction = theZiForLeadCompExerciseList[currentIndex].hintText;
    }
    else if (typingType == TypingType.ExpandedComponents) {
      instruction = theZiForExpandedCompExerciseList[currentIndex].hintText;
    }
    else if (typingType == TypingType.FromLessons) {
      instruction = "Please type new characters as instructed.";
    }

    return instruction;
  }

  ZiWithComponentsAndStrokes getZiWithComponentsAndStrokes(TypingType typingType, int index, int lessonId) {
    if (typingType == TypingType.GiveItATry) {
      return theZiForIntroductionList[index];
    }
    else if (typingType == TypingType.LeadComponents) {
      return theZiForLeadCompExerciseList[index];
    }
    else if (typingType == TypingType.ExpandedComponents) {
      return theZiForExpandedCompExerciseList[index];
    }
    else if (typingType == TypingType.FromLessons) {
      var zi = theLessonManager.getChar(lessonId, index);
      return ZiWithComponentsAndStrokes(
          zi.char,
          [""],
          "noimage",
          "nohelpyet"
      );
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

  int getNextIndex(TypingType typingType, int currentIndex, int lessonId) {
    currentIndex++;

    if (typingType == TypingType.GiveItATry) {
      if (currentIndex >= theZiForIntroductionList.length) {
        currentIndex = -1;
      }
    }
    else if (typingType == TypingType.LeadComponents) {
      if (currentIndex >= theZiForLeadCompExerciseList.length) {
        currentIndex = -1;
      }
    }
    else if (typingType == TypingType.ExpandedComponents) {
      if (currentIndex >= theZiForExpandedCompExerciseList.length) {
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

    return currentIndex;
  }

  bool doesTypingResultContainTheZi(TypingType typingType, int currentIndex, String typingResult, int lessonId) {
    bool result = false;

    if (currentIndex < 0) {
      return false;
    }

    var zi;
    if (typingType == TypingType.GiveItATry) {
      zi = theZiForIntroductionList[currentIndex];
      result = typingResult.contains(zi.zi);
    }
    else if (typingType == TypingType.LeadComponents) {
      zi = theZiForLeadCompExerciseList[currentIndex];
      result = typingResult.contains(zi.zi);
    }
    else if (typingType == TypingType.ExpandedComponents) {
      zi = theZiForExpandedCompExerciseList[currentIndex];
      result = typingResult.contains(zi.zi);
    }
    else if (typingType == TypingType.FromLessons) {
      zi = theLessonManager.getChar(lessonId, currentIndex);
      result = typingResult.contains(zi.char);
    }

    return result;
  }

  int getTotal(TypingType typingType, int lessonId) {
    if (typingType == TypingType.GiveItATry) {
      return theZiForIntroductionList.length;
    }
    else if (typingType == TypingType.LeadComponents) {
      return theZiForLeadCompExerciseList.length;
    }
    else if (typingType == TypingType.ExpandedComponents) {
      return theZiForExpandedCompExerciseList.length;
    }
    else if (typingType == TypingType.FromLessons) {
      var lesson = theLessonManager.getLesson(lessonId);
      return lesson.convCharsIds.length + lesson.charsIds.length;
    }

    return -1;
  }
}