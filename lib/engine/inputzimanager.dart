import 'package:hanzishu/engine/inputzi.dart';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/engine/dictionarymanager.dart';
import 'package:hanzishu/engine/thirdpartylesson.dart';
import 'package:hanzishu/data/inputzilist.dart';
import 'package:hanzishu/data/pinyininputzilist.dart';
import 'package:hanzishu/data/componenttypinglist.dart';
import 'package:hanzishu/data/searchingzilist.dart';
import 'dart:math';

import 'package:hanzishu/variables.dart';
import 'package:hanzishu/utility.dart';
import 'package:characters/characters.dart';
import 'package:video_player/video_player.dart';


class InputZiManager {
  TypingType currentTypingType = TypingType.none;
  int currentIndex = 0; // Note: to be insync with inputzipage
  static List<InputZi> typingCandidates = [];
  static List<String> previousFirstPositionList = [];
  static int maxTypingCandidates = 7; //20;
  //static int maxTypingCharacters = 12; // to be same as maxTypingCandidates for now
  String wordsStudy = '';
  List<int> pinyinLetterIndex = <int>[];
  List<int> inputCodeLetterIndex = <int>[];
//  TypingType typingType;

  TypingType getCurrentType() {
    return currentTypingType;
  }

  setCurrentType(TypingType currentType, String wordsStudy) {
    if (currentType == TypingType.Custom || currentType != currentTypingType) {
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
        //if (inputZi.usageFrequency > candidates[i].usageFrequency) {
        //  candidates.insert(i, inputZi);
        //  return;
        //}
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
    List<String> candidates = <String>[]; //new List<String>(typingCandidates.length);

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
  static List<String>? getZiCandidates(String input) {
    var originalFullZiCandidates;

    if (isPinyinInput(input)) {
      if (input.length == 1) {
        return []; //null;
      }
      theZiCandidatesFromPinyin = true;
      //return getZiCandidatesFromPinyinList(input.substring(1));
      originalFullZiCandidates = theTrieManager.findPinyin(input.substring(1));
    }
    else {
      theZiCandidatesFromPinyin = false;
      originalFullZiCandidates = theTrieManager.find(input);
    }
    return InputZiManager.ExtractFullCandidates(originalFullZiCandidates);
  }

  int getPinyinIndexByValue(String oneLetter) {

    return 0;
  }

  List<int> getPinyinListIndex() {
    if (pinyinLetterIndex.length == 0) {
      int letterStartingIndex = 1;
      // 23 + 1 = 24, 'i' 'u' 'v'don't exist in Pinyin as the first letter
      pinyinLetterIndex = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
      for (int i = 1; i < thePinyinInputZiList.length; i++) {
        if (thePinyinInputZiList[i].pinyin[0] != thePinyinInputZiList[i-1].pinyin[0]) {
          pinyinLetterIndex[letterStartingIndex++] = i;
        }
      }
      pinyinLetterIndex[23] = thePinyinInputZiList.length;
    }

    return pinyinLetterIndex;
  }

  List<int> getInputZiListIndex() {
    if (inputCodeLetterIndex.isEmpty) {
      int letterStartingIndex = 1;
      // 25 + 1 = 26
      inputCodeLetterIndex = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
      for (int i = 1; i < theInputZiList.length; i++) {
        if (theInputZiList[i].doubleByteCode[0] != theInputZiList[i-1].doubleByteCode[0]) {
          inputCodeLetterIndex[letterStartingIndex++] = i;
        }
      }
      inputCodeLetterIndex[25] = theInputZiList.length;
    }

    return inputCodeLetterIndex;
  }

  static int getLetterIndex(String letter) {
    return (letter[0].codeUnitAt(0) - 'a'.codeUnitAt(0));
  }

  static int getPinyinLetterIndex(String letter) {
    int adjustment = 0;

    int diff = letter[0].codeUnitAt(0) - 'a'.codeUnitAt(0);

    // need to skip 'i'  'u' 'v'which don't start in Pinyin
    if (diff >= 8 && diff <= 19) { //'i' to 't'
      diff--;
    }
    else if (diff == 20) { // 'u'
      diff -= 2;
    }
    else if (diff >= 21) { // 'v' and above
      diff -= 3;
    }

    return diff;
  }



  static List<String> getZiCandidatesFromPinyinList(String pinyin) {
    //typingCandidates.clear();
    List<String> pinyinCandidates =[];

    var listIndex = theInputZiManager.getPinyinListIndex();
    var id = getPinyinLetterIndex(pinyin.substring(0, 1));

    int start= listIndex[id];
    int end = listIndex[id+1];

    var pinyinLength = pinyin.length;

    for (var i = start; i < end; i++) {
      var oneInputZi = thePinyinInputZiList[i];
      if (oneInputZi.pinyin.length == pinyinLength) {
        if (oneInputZi.pinyin.startsWith(pinyin)) {
          pinyinCandidates.add(oneInputZi.zi);
        }
      }
    }

    for (var i = start; i < end; i++) {
      var oneInputZi = thePinyinInputZiList[i];
      if (oneInputZi.pinyin.length > pinyinLength) {
        if (oneInputZi.pinyin.startsWith(pinyin)) {
          pinyinCandidates.add(oneInputZi.zi);
        }
      }
    }

    return pinyinCandidates;
    //return convertZiListToStringList(typingCandidates);
  }

  static List<String> getZiCandidatesFromInputZiList(String input) {
    //typingCandidates.clear();
    List<String> inputCandidates = [];

    var listIndex = theInputZiManager.getInputZiListIndex();
    var id = getLetterIndex(input.substring(0, 1));

    int start = listIndex[id];
    int end = listIndex[id+1];

    var inputLength = input.length;

    for (var i = start; i < end; i++) {
      var oneInputZi = theInputZiList[i];
      if (oneInputZi.doubleByteCode.length == inputLength) {
        if (oneInputZi.doubleByteCode.startsWith(input)) {
          inputCandidates.add(oneInputZi.zi);
        }
      }
    }

    for (var i = start; i < end; i++) {
      var oneInputZi = theInputZiList[i];
      if (oneInputZi.doubleByteCode.length > inputLength) {
        if (oneInputZi.doubleByteCode.startsWith(input)) {
          inputCandidates.add(oneInputZi.zi);
        }
      }
    }

    return inputCandidates;
  }

  static bool isPinyinInput(String input) {
    if (input.length >= 1) {
      if(input[0] == 'z') {
        return true;
      }
    }

    return false;
  }

  static InputZi? getFirstZiCandidate() {
    if (typingCandidates.length > 0) {
      return typingCandidates[0];
    }

    return null;
  }

  static String? getCandidateZiString(int index) {
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

    if (candidateExistsInFirstPositionList(currentCandidatesToUpdate[0], previousFirstPositionList)) {
          pushANeverFirstToFirst(currentCandidatesToUpdate, previousFirstPositionList);
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
  ZiWithComponentsAndStrokes? getCommonZi(int index, int lessonId) {
    // every other 38 items.
    int searchingZiId = getSearchingZiId(index, lessonId); // skip the index 0 in theSearchingZiList
    if (searchingZiId < theSearchingZiList.length) {
      var oneSearchingItem = theSearchingZiList[searchingZiId];
      var components = <String>[]; //List<String>();
      DictionaryManager.getAllComponents(searchingZiId, components);
      return ZiWithComponentsAndStrokes(oneSearchingItem.char, components, "", 0);
    }

    return null;
  }

  ZiWithComponentsAndStrokes? getZiWithComponentsAndStrokes(TypingType typingType, int index, int lessonId) {
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
    //else if (typingType == TypingType.SingleComponent) {
    //  return theZiForSingleCompExerciseList[index];
    //}
    else if (typingType == TypingType.FirstTyping) {
      return theZiForFirstTypingExerciseList[index];
    }
    else if (typingType == TypingType.TwoComponents) {
      return theZiForTwoCompExerciseList[index];
    }
    else if (typingType == TypingType.GeneralExercise) {
      return theZiForGeneralExerciseList[index];
    }
    else if (typingType == TypingType.CommonZiTyping) {
      return getCommonZi(index, lessonId);
    }
    else if (typingType == TypingType.FromLessons) {
      var char = theLessonManager.getChar(lessonId, index);
      return ZiWithComponentsAndStrokes(
          char,
          [""],
          "noimage",
          0/*"nohelpyet"*/
      );
    }
    else if (typingType == TypingType.ThirdParty) {
      String char = ThirdPartyLesson.getChar(index);
      return ZiWithComponentsAndStrokes(
          char,
          [""],
          "noimage",
          0/*"nohelpyet"*/
      );
    }
    else if (typingType == TypingType.Custom) {
      String char = ThirdPartyLesson.getOneChar(wordsStudy, index);
      return ZiWithComponentsAndStrokes(char, [""], "", 0);
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
    //else if (typingType == TypingType.SingleComponent) {
    //  if (currentIndex >= theZiForSingleCompExerciseList.length) {
    //    currentIndex = -1;
    //  }
    //}
    else if (typingType == TypingType.FirstTyping) {
      if (currentIndex >= theZiForFirstTypingExerciseList.length) {
        currentIndex = -1;
      }
    }
    else if (typingType == TypingType.GeneralExercise) {
      if (currentIndex >= theZiForGeneralExerciseList.length) {
        currentIndex = -1;
      }
    }
    else if (typingType == TypingType.CommonZiTyping) {
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
      var typingChars = lesson.getAllTypingChars();
      if (currentIndex >= typingChars.length) { /*lesson.convCharsIds.length + lesson.charsIds.length*/
        currentIndex = -1;
      }
    }
    else if (typingType == TypingType.ThirdParty) {
      var currentTotal = ThirdPartyLesson.getCurrentRealWordsLength();
      if (currentIndex >= currentTotal) { /*lesson.convCharsIds.length + lesson.charsIds.length*/
        currentIndex = -1;
      }
    }
    else if (typingType == TypingType.Custom) {
      //var lesson = theLessonManager.getLesson(lessonId);
      var currentTotal = ThirdPartyLesson.getRealWordsLengthUtil(wordsStudy);
      if (currentIndex >= currentTotal) {
        currentIndex = -1;
      }
    }
    else if (typingType == TypingType.ComponentTyping) {
      if (currentIndex >= theComponentCategoryStringIdAndTypingCharsList[lessonId].chars.length) {
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
    //else if (typingType == TypingType.SingleComponent) {
    //  zi = theZiForSingleCompExerciseList[currentIndex];
    //  result = typingResult.contains(zi.zi);
    //}
    else if (typingType == TypingType.FirstTyping) {
      zi = theZiForFirstTypingExerciseList[currentIndex];
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
    else if (typingType == TypingType.CommonZiTyping) {
      var searchingZiId = getSearchingZiId(currentIndex, lessonId);
      zi = theSearchingZiList[searchingZiId];
      result = typingResult.contains(zi.char);
    }
    else if (typingType == TypingType.FromLessons) {
      var char = theLessonManager.getChar(lessonId, currentIndex);
      result = typingResult.contains(char);
    }
    else if (typingType == TypingType.ThirdParty) {
      var char = ThirdPartyLesson.getChar(currentIndex);
      result = typingResult.contains(char);
    }
    else if (typingType == TypingType.Custom) {
      var char = ThirdPartyLesson.getOneChar(wordsStudy, currentIndex);
      result = typingResult.contains(char);
    }
    else if (typingType == TypingType.ComponentTyping) {
      var char = theComponentCategoryStringIdAndTypingCharsList[lessonId].chars[currentIndex];
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
    //else if (typingType == TypingType.SingleComponent) {
    //  return theZiForSingleCompExerciseList.length;
    //}
    else if (typingType == TypingType.FirstTyping) {
      return theZiForFirstTypingExerciseList.length;
    }
    else if (typingType == TypingType.TwoComponents) {
      return theZiForTwoCompExerciseList.length;
    }
    else if (typingType == TypingType.GeneralExercise) {
      return theZiForGeneralExerciseList.length;
    }
    else if (typingType == TypingType.CommonZiTyping) {
      int total = ((theSearchingZiList.length - 52) / 38).truncate();    // 37
      int remain = (theSearchingZiList.length - 52) % 38; // first 30
      if (lessonId <= remain) {
        total += 1;
      }
      return total;
    }
    else if (typingType == TypingType.FromLessons) {
      var lesson = theLessonManager.getLesson(lessonId);
      //return lesson.convCharsIds.length + lesson.charsIds.length;
      return lesson.getAllTypingChars().length;
    }
    else if (typingType == TypingType.ThirdParty) {
      return ThirdPartyLesson.getCurrentRealWordsLength();
    }
    else if (typingType == TypingType.Custom) {
      return ThirdPartyLesson.getRealWordsLengthUtil(wordsStudy);
    }
    else if (typingType == TypingType.ComponentTyping) {
      return theComponentCategoryStringIdAndTypingCharsList[lessonId].chars.length;
    }

    return -1;
  }

  static List<String> ExtractFullCandidates(List<String> originalFullCandidates) {
    List<String> extractedFullCandidates = [];
    String oneOriginalCandidate;

    for (int i = 0; i < originalFullCandidates.length; i++) {
      oneOriginalCandidate = originalFullCandidates[i];
      if (oneOriginalCandidate.length == 1) {
        extractedFullCandidates.add(oneOriginalCandidate);
      }
      else if (oneOriginalCandidate.length > 1) {
        // extract null separated string
        List<String> oneExtractedCandidates = oneOriginalCandidate.split(',');
        extractedFullCandidates.addAll(oneExtractedCandidates);
      }
    }

    return extractedFullCandidates;
  }


  static bool isLetter(String char) { // char here includes those graphic kinds of stuff, like mark or unusual chinese char.
    // Define a regular expression to match letters (case-insensitive)
    final letterRegExp = RegExp(r'[a-zA-Z]');
    return letterRegExp.hasMatch(char);
  }

  static bool isMiddleSpace(String char) { // char here includes those graphic kinds of stuff, like mark or unusual chinese char.
    // Define a regular expression to match letters (case-insensitive)
    final letterRegExp = RegExp(r'[ ]');
    return letterRegExp.hasMatch(char);
  }

  // the oneCandidate might contain complex chinese char and mid space etc
  static double getOneCandidateLength(String oneCandidate) {
    double oneCandidateLength = 0.0;
    var chars = oneCandidate.characters;
    for (final char in chars) {
      if (isMiddleSpace(char)) {
        oneCandidateLength += InputZiManager.getCandidateMiddleSpaceLength();
      }
      else if (isLetter(char)) {
        oneCandidateLength += InputZiManager.getCandidateLetterLength();
      }
      else { // Hanzi
        oneCandidateLength += InputZiManager.getCandidateHanziLength();
      }

    }
    oneCandidateLength += InputZiManager.getCandidateIndexLength();

    return oneCandidateLength;
  }

  static List<String> getCurrentFromFullZiCandidates(List<String>fullCandidates, int fullCandidateStartingIndex) {
    List<String> currentCandidates = [];
    int candidatesCount = 0;
    double candidatesLength = 0.0;
    for (int i = fullCandidateStartingIndex; i < fullCandidates.length && candidatesCount < maxTypingCandidates; i++) {
      candidatesLength += getOneCandidateLength(fullCandidates[i]);
      if (candidatesLength <= InputZiManager.getMaxTotalCandidateLength()) {
        currentCandidates.add(fullCandidates[i]);
        candidatesCount++;
      }
      else {
        break;
      }
    }

    return currentCandidates;
  }

  static bool isLastGroupOfCandidates(List<String>fullCandidates, int fullCandidateStartingIndex) {
    bool isLastCandidate = true;
    double candidatesLength = 0.0;
    for (int i = fullCandidateStartingIndex; i < fullCandidates.length; i++) {
      candidatesLength += getOneCandidateLength(fullCandidates[i]);
      if (candidatesLength > InputZiManager.getMaxTotalCandidateLength()) {
        isLastCandidate = false;
        break;
      }
    }

    return isLastCandidate;
  }

  static int  getFullCandidateNextStartingIndex(List<String>fullCandidates, int fullCandidateStartingIndex, bool forwardArrow) { //backArrow = false
      int nextFullCandidateStartingIndex = 0;

      int candidatesCount = 0;
      int charCount = 0;
      int validIndex = 0;
      double candidatesLength = 0.0;

      if (forwardArrow) {
        // to next index with total number of characters <= maxTypingCharacters
        if (fullCandidateStartingIndex < fullCandidates.length - 1) {
          for (int i = fullCandidateStartingIndex; i < fullCandidates.length && candidatesCount < maxTypingCandidates; i++) {
            candidatesLength += getOneCandidateLength(fullCandidates[i]);
            if (candidatesLength <= InputZiManager.getMaxTotalCandidateLength()) {
              validIndex = i;
              candidatesCount++;
            }
            else {
              break;
            }
          }
          if (validIndex < fullCandidates.length - 1) {
            nextFullCandidateStartingIndex = validIndex + 1;
          }
        }
      }
      else { // backarrow
        if (fullCandidateStartingIndex > 0) {
          // to next backarrow index with total number of characters <= maxTypingCharacters
          for (int i = fullCandidateStartingIndex - 1; i >= 0 && candidatesCount < maxTypingCandidates; i--) {
            candidatesLength += getOneCandidateLength(fullCandidates[i]);
            if (candidatesLength <= InputZiManager.getMaxTotalCandidateLength()) {
              validIndex = i;
              candidatesCount++;
            }
            else {
              break;
            }
          }

          nextFullCandidateStartingIndex = validIndex;
        }
        //if ((fullCandidateStartingIndex - maxTypingCandidates) >= 0) {
          //nextFullCandidateStartingIndex = fullCandidateStartingIndex - maxTypingCandidates;
        //}
      }

      return nextFullCandidateStartingIndex;
  }

  static bool isLastLetterArrow(String str) {
    var textLen = str.length;
    if (textLen < 1) {
      return false;
    }

    return Utility.isArrow(str[str.length - 1]);
  }

  static String getLastComposingTextAfterDelete(String mixedString) {
    // find the first non-asc letter
    var oneValue;
    int nonLetterId = -1;
    for (int i = 0; i < mixedString.length; i++) {
      oneValue = mixedString.codeUnitAt(i);
      if (oneValue < "a".codeUnitAt(0) || oneValue > "z".codeUnitAt(0)) {
        nonLetterId = i;
      }
    }

    if (nonLetterId == -1) {
      return mixedString;
    }
    else if (nonLetterId == (mixedString.length - 1)) {
      return '';
    }
    else {
      return mixedString.substring(nonLetterId + 1);
    }
  }

  static String getInputCodeByCharFromInputList(String char) {
    int len = theInputZiList.length;
    for (int i = 0; i < len; i++) {
      if (char == theInputZiList[i].zi) {
        return theInputZiList[i].doubleByteCode;
      }
    }

    return "";
  }

  static String removePinyin(String newText) {
    return newText.replaceAll(RegExp(r'[a-zA-Z\s]'), '');
  }

  static double getMaxTotalCandidateLength() {
    return getCandidateLeftArrowXPosition() - 13.0;
  }

  static double getCandidateLeftArrowXPosition() {
    return (maxTypingCandidates * (20.0 + 14.0 + 12.0) + 22.0); //* getSizeRatio(); //12.0->22.0
  }

  static double getCandidateRightArrowXPosition() {
    return  getCandidateLeftArrowXPosition() + 20.0 + 4.0; //20.0+14.0 ->20.0+4.0
  }

  static double getCandidateHanziLength() {
    return 20.0;
  }

  static double getCandidateMiddleSpaceLength() {
    return 3.0;
  }

  static double getCandidateLetterLength() {
    return 9.0; // 12.0
  }

  static double getCandidateIndexLength() {
    return 12.0;
  }

  static double getCandidateSpaceLength() {
    return 12.0 ;
  }
}