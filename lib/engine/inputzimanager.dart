import 'package:flutter/material.dart';
import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/data/inputzilist.dart';
import 'dart:math';


class InputZiManager {
  static List<InputZi> typingCandidates = [];
  static int maxTypingCandidates = 20;

  static int findFirst(String input) {
    for (var i = 0; i < theInputZiList.length; i++) {
      var oneInputZi = theInputZiList[i];
      if (oneInputZi.doubleByteCode.startsWith(input)) {
        return i;
      }
    }

    return -1;
  }

  static int findLast(int firstIndex, String input) {
    for (var i = firstIndex; i < theInputZiList.length; i++) {
      var oneInputZi = theInputZiList[i];
      if (!oneInputZi.doubleByteCode.startsWith(input)) {
        return i - 1;
      }
    }

    return -1;
  }

  /*
  // should be a sorted queue
  static List<InputZi> sortZiRange(int start, int end) {
    // list index etc.
    // the manager will control the insert and delete of members from the list.
    // list.insert(int index, E element).
  }
  */

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

  /*
  static List<String> convertInputZiListToStringList(List<InputZi> typingCandidates) {
    List<String> candidates = [];

    for (var i = 0; i < typingCandidates.length; i++) {
      candidates.add(typingCandidates[i].zi);
    }

    return candidates;
  }
  */

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

  static InputZi getZiCandidateByIndex(int index) {
    if (typingCandidates.length > index) {
      return typingCandidates[index];
    }

    return null;
  }
}