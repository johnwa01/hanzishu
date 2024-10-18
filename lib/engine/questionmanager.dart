import 'dart:math';
import 'package:hanzishu/data/componentlist.dart';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/standardexammanager.dart';
import 'package:hanzishu/data/searchingzilist.dart';

class QuestionManager {
  bool isQuestionOn = false;

  int currentZiId = -1;
  int previousZiId = -1;
  String previousZi = '';
  String previousZiMeaning = '';
  int sideZiId = -1;
  ZiListType sideZiListType = ZiListType.zi; // default
  String sideZiMeaning = '';

  String currentZi = '';
  String currentZiMeaning = '';
  int currentZiPosi = -1; // also correctPosi

  String wrongZiA = '';  // hidden
  String wrongZiAMeaning = '';
  int wrongZiAPosi = -1;

  String wrongZiB = '';  // hidden
  String wrongZiBMeaning = '';
  int wrongZiBPosi = -1;

  int selectedPosi = -1; // setState parameter

  QuestionManager() {}

  setValues(int centerZiId, int sideZiId, ZiListType sideZiListType, int searchingZiId) {
  //setValues(int previousZiId, String sideZiOrComp, int currentZiId,) {
    this.previousZiId = centerZiId;
    this.sideZiId = sideZiId;
    this.sideZiListType = sideZiListType;
    this.currentZiId = searchingZiId;
    this.currentZi = theSearchingZiList[searchingZiId].char;
  }

  String? getMeaning(int posi) { // 1 based
    if (currentZiPosi == posi) {
      return currentZiMeaning;
    }
    else if (wrongZiAPosi == posi) {
      return wrongZiAMeaning;
    }
    else if (wrongZiBPosi == posi) {
      return wrongZiBMeaning;
    }

    return null;
  }

  int getCorrectPosi() {
    return currentZiPosi;
  }

  int getSelectedPosi() {
    return selectedPosi;
  }

  int getCurrentZiId() {
    return currentZiId;
  }

  String getCurrentZi() {
    return currentZi;
  }

  String getPreviousZi() {
    return previousZi;
  }

  String getPreviousZiMeaning() {
    return previousZiMeaning;
  }

  int getSideZiId() {
    return sideZiId;
  }

  String getSideZiMeaning() {
    return sideZiMeaning;
  }

  ZiListType getSideZiListType() {
    return sideZiListType;
  }

  String getAnswer(int index) {
    var answer = null;
    if (index == currentZiPosi) {
      answer = currentZiMeaning;
    }
    else if (index == wrongZiAPosi) {
      answer = wrongZiAMeaning;
    }
    else if (index == wrongZiBPosi) {
      answer = wrongZiBMeaning;
    }

    return answer;
  }

  PopulateQuestionInfo() {
    currentZiPosi = -1;
    wrongZiAPosi = -1;
    wrongZiBPosi = -1;
    selectedPosi = -1;

    //var zi = ZiManager.getZiByChar(currentZi);
    currentZiMeaning = theSearchingZiList[currentZiId].meaning;
    currentZiPosi =
        StandardExamManager.getARandomNumber(3, -1, -1) + 1; // 0,1,2-> 1,2,3

    for (int i = 1; i <= 3; i++) {
      if (currentZiPosi != i && wrongZiAPosi < 1) {
        wrongZiAPosi = i;
      }
      else if (currentZiPosi != i && wrongZiAPosi != i) {
        wrongZiBPosi = i;
      }
    }

    // have to exclude the first 52 entries
    int searchingZiIndexA = StandardExamManager.getARandomNumber(
        3773, currentZiId - 52, -1); //3773 + 52 = 3825
    wrongZiAMeaning = theSearchingZiList[searchingZiIndexA + 52].meaning;
    int searchingZiIndexB = StandardExamManager.getARandomNumber(
        3773, currentZiId - 52, searchingZiIndexA);
    wrongZiBMeaning = theSearchingZiList[searchingZiIndexB + 52].meaning;

    previousZi = theSearchingZiList[previousZiId].char;
    previousZiMeaning = theSearchingZiList[previousZiId].meaning;

    if (sideZiListType == ZiListType.component) {
      sideZiMeaning = theComponentList[sideZiId].meaning;
    }
    else {
      sideZiMeaning = theSearchingZiList[sideZiId].meaning;
    }
  }
}