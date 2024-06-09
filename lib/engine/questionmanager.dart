import 'dart:math';
import 'package:hanzishu/engine/zimanager.dart';
import 'package:hanzishu/engine/standardexammanager.dart';
import 'package:hanzishu/data/searchingzilist.dart';

class QuestionManager {
  bool isQuestionOn;

  int currentZiId;
  int previousZiId;
  String previousZi;
  String previousZiMeaning;
  String sideZiOrComp;

  String currentZi;
  String currentZiMeaning;
  int currentZiPosi; // also correctPosi

  String wrongZiA;  // hidden
  String wrongZiAMeaning;
  int wrongZiAPosi;

  String wrongZiB;  // hidden
  String wrongZiBMeaning;
  int wrongZiBPosi;

  int selectedPosi = -1; // setState parameter

  QuestionManager() {}

  setValues(int currentZiId, int previousZiId, String sideZiOrComp) {
    this.currentZiId = currentZiId;
    this.currentZi = theSearchingZiList[currentZiId].char;
    this.previousZiId = previousZiId;
    this.sideZiOrComp = sideZiOrComp;
  }

  String getMeaning(int posi) { // 1 based
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
    currentZiPosi = StandardExamManager.getARandomNumber(3, -1, -1) + 1; // 0,1,2-> 1,2,3

    for (int i = 1; i <= 3; i++) {
      if (currentZiPosi != i && wrongZiAPosi < 1) {
        wrongZiAPosi = i;
      }
      else if (currentZiPosi != i && wrongZiAPosi != i) {
        wrongZiBPosi = i;
      }
    }

    // have to exclude the first 52 entries
    int searchingZiIndexA = StandardExamManager.getARandomNumber(3773, currentZiId - 52, -1); //3773 + 52 = 3825
    wrongZiAMeaning = theSearchingZiList[searchingZiIndexA + 52].meaning;
    int searchingZiIndexB = StandardExamManager.getARandomNumber(3773, currentZiId - 52, searchingZiIndexA);
    wrongZiBMeaning = theSearchingZiList[searchingZiIndexB + 52].meaning;

    previousZi = theSearchingZiList[previousZiId].char;
    previousZiMeaning = theSearchingZiList[previousZiId].meaning;
  }
}