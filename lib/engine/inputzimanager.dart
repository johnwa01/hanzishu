import 'package:flutter/material.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/data/inputzilist.dart';
import 'dart:math';

import 'package:hanzishu/variables.dart';


class InputZiManager {
  static List<InputZi> typingCandidates = [];
  static int maxTypingCandidates = 20;
  TypingType typingType;

  static int findFirst(String input) {
    for (var i = 0; i < theInputZiList.length; i++) {
      var oneInputZi = theInputZiList[i];
      if (oneInputZi.doubleByteCode.startsWith(input)) {
        return i;
      }
    }

    return -1;
  }

  setCurrentType(TypingType typingType) {
    this.typingType = typingType;
  }

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

  static updateCandidates(InputZi inputZi, List<InputZi> candidates ) {
    var activeCandidatesLength = min(maxTypingCandidates, candidates.length);

    if (activeCandidatesLength == 0) {
      candidates.insert(0, inputZi);
      return;
    }

    // never check the member after the maxTypingCandidates
    for (var i = 0; i < activeCandidatesLength; i++) {
        if (inputZi.usageFrequency > candidates[i].usageFrequency) {
          candidates.insert(i, inputZi);
          return;
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

  static List<String> convertZiListToStringList(List<InputZi> typingCandidates){
    List<String> candidates = new List<String>(typingCandidates.length);

    for (var i = 0; i < typingCandidates.length; i++) {
      candidates[i] = typingCandidates[i].zi;
    }

    return candidates;
  }

  static List<String> getZiCandidatesHelper(int start, int end) {
    typingCandidates.clear();
    for (var i = start; i <= end; i++) {
      var oneInputZi = theInputZiList[i];
      //if (typingCandidates.length == 0 || oneInputZi.usageFrequency > typingCandidates[typingCandidates.length-1].usageFrequency) {
        //loop through the candidates from smallest to the biggest
        updateCandidates(oneInputZi, typingCandidates);
      //}
    }

    return convertZiListToStringList(typingCandidates);
    //return convertInputZiListToStringList(typingCandidates);
  }

  // the only public method for this feature
  // current input as input, and a string as the output
  static List<String> getZiCandidates(String input) {
    var first = findFirst(input);
    if (first != -1) {
      var last = findLast(first, input);
      if (last != -1) {
        return getZiCandidatesHelper(first, last);
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

  ZiWithComponentsAndStrokes getZiWithComponentsAndStrokes(TypingType typingType, int index) {
    if (typingType == TypingType.ThreeOrMoreComponents) {
      return theZiWithThreeOrMoreComponentList[index];
    }
    else if (typingType == TypingType.TwoComponents) {
      return theZiWithTwoComponentList[index];
    }
    else if (typingType == TypingType.OneComponent) {
      return theZiWithOneComponentList[index];
    }

    return null;
  }

  bool doesTypingResultContainTheZi(TypingType typingType, int currentIndex, String typingResult) {
    bool result = false;
    var zi;
    if (typingType == TypingType.ThreeOrMoreComponents) {
      zi = theZiWithThreeOrMoreComponentList[currentIndex];
      result = typingResult.contains(zi.zi);
    }
    else if (typingType == TypingType.TwoComponents) {
      zi = theZiWithTwoComponentList[currentIndex];
      result = typingResult.contains(zi.zi);
    }
    else if (typingType == TypingType.OneComponent) {
      zi = theZiWithOneComponentList[currentIndex];
      result = typingResult.contains(zi.zi);
    }

    return result;
  }

  int getTotal(TypingType typingType) {
    if (typingType == TypingType.ThreeOrMoreComponents) {
      return theZiWithThreeOrMoreComponentList.length;
    }
    else if (typingType == TypingType.TwoComponents) {
      return theZiWithTwoComponentList.length;
    }
    else if (typingType == TypingType.OneComponent) {
      return theZiWithOneComponentList.length;
    }

    return -1;
  }
}