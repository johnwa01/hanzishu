import 'dart:math';
import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/engine/quizmanager.dart';


class StandardExamManager {
  DrillCategory currentDrillCategory;
  int currentSubItemId = 0;
  QuizCategory currentQuizCategory;

  static int maxExamNumber = 30;

  int currentCount = 0;
  int currentId;

  var currentType = QuizType.chars; // only supported type for HSK etc

  List<SearchingZi> currentValues = [null, null, null, null];
  var correctPosition = 0;
  var minUpperRange = 5; // 0 based, so 5+1=6

  List<int> usedIDs;

  List<String> fullSubList = ['灵', '覃', '阶', '敢', '因', '众', '醒', '已', '啥'];
  /*
  List<List<String>> testSubLists = [['覃', '阶', '敢', '众', '醒', '已', '啥'],
    ['阶', '敢', '众', '醒', '已', '啥'],
    ['敢', '众', '醒', '已', '啥'],
    ['众', '醒', '已', '啥'],
    ['醒', '已', '啥', '已', '啥'],
    ['敢', '众', '醒', '已', '啥']];*/

  List<List<SearchingZi>> testSubLists = [[], [], [], [], [], [], []];

  static List<int> hskZiCounts = [300, 300, 300, 300, 300, 300, 1200]; // 7 levels

  initValues(DrillCategory drillCategory, int subItemId, QuizCategory quizCategory) {
    // set all ini values for this drillCategory
    currentDrillCategory = drillCategory;
    currentSubItemId = subItemId;
    currentQuizCategory = quizCategory;

    currentCount = 0;
    currentValues = [null, null, null, null];
    correctPosition = 0;
    usedIDs = [];

    //createFullSubList(subItemId);

    // create submenu lists from the general menu
    createTestSubList(subItemId);

    currentId = getNext();
  }

  int getTotalQuestions() {
    return maxExamNumber; //testSubLists[currentSubItemId - 1].length;
  }

  List<SearchingZi> getCurrentValues() {
    return currentValues;
  }
/*
  int getInitId(int drillSubMenu) {
      var upperRange = getUpperRange();
      return getARandomNumber(
          upperRange, -1, -1);
  }
*/
  int getNext() {
    return getNextHelper(currentSubItemId);
  }

  int getNextHelper(int drillSubMenu) {
    if (currentCount < (testSubLists[currentSubItemId - 1].length - 1)) {
      if (currentCount >= maxExamNumber) {
        return -1;
      }

      currentCount++;
      var upperRange = getUpperRange();

      bool isAUsedId = true;
      while(isAUsedId) {
        currentId = getARandomNumber(
            upperRange, -1, -1);
        if (!usedIDs.contains(currentId)) {
          isAUsedId = false;
        }
      }

      return currentId;
    }

    return -1;
  }

  createFullSubList(int drillSubMenu) {
    //return fullSubList;
  }

  createTestSubList(int drillSubMenu) {
    var hskLevel;
    for (int i = 52; i < theSearchingZiList.length; i++) {
      hskLevel = theSearchingZiList[i].levelHSK;
      if (hskLevel >= 1 && hskLevel <= 7) {
        testSubLists[hskLevel - 1].add(theSearchingZiList[i]);
      }
    }
    //return testSubLists[0];
  }

  int getARandomNumber(int upperRange, int chosenNumber1, int chosenNumber2) {
    var chosen = true;
    var number = 0;

    Random rand = Random();

    while (chosen) {
      number = rand.nextInt(upperRange);

      if (number != chosenNumber1 && number != chosenNumber2) {
        chosen = false;
      }
    }

    return number;
  }

  List<SearchingZi> getCurrentTypeList() {
    return getTypeList(currentType);
  }

  List<SearchingZi> getTypeList(QuizType type) {
    return testSubLists[currentSubItemId - 1];;
  }

  SearchingZi getOneValueById(int id) {
    var currentList = getCurrentTypeList();
      return currentList[id];
  }

  int getCorrectPosition() {
    return correctPosition;
  }

  AnswerPosition getCorrectAnswerPosition() {
    AnswerPosition position;
    switch (correctPosition) {
      case 1:
        position = AnswerPosition.positionA;
        break;
      case 2:
        position = AnswerPosition.positionB;
        break;
      case 3:
        position = AnswerPosition.positionC;
        break;
      default:
        position = AnswerPosition.none;
        break;
    }

    return position;
  }

  int getUpperRange() {
    var upperRange;

    var list = getCurrentTypeList();
    upperRange = list.length - 1;
    if (upperRange < minUpperRange) {
      upperRange = minUpperRange;
    }

    return upperRange;
  }

  List<SearchingZi> getUpdatedValues(/*int index, bool isMeaning*/) {
    var upperRange = getUpperRange();

    currentValues[0] = getOneValueById(currentId);
    var nonCharId0 = 0;

    Random rand = Random();
    // 1 based.
    correctPosition = 1 + rand.nextInt(3 - 1);

    // 0 based position when creating randon number
    var wrongPositionI = getARandomNumber(
        upperRange, currentId, currentId);
    var wrongPositionJ = getARandomNumber(
        upperRange, currentId, wrongPositionI);

    var valueI = getOneValueById(wrongPositionI);
    var valueJ = getOneValueById(wrongPositionJ);

    var correctText = currentValues[0];
    if (true/*isMeaning*/) {
      correctText = getOneValueById(currentId);
    }

    if (correctPosition == 1) {
      currentValues[1] = correctText;

      //if (isMeaning) {
      currentValues[2] = valueI;
      currentValues[3] = valueJ;
    }
    else if (correctPosition == 2) {
      currentValues[2] = correctText;

      //if (isMeaning) {
      currentValues[1] = valueI;
      currentValues[3] = valueJ;
    }
    else if (correctPosition == 3) {
      currentValues[3] = correctText;

      //if (isMeaning) {
      currentValues[1] = valueI;
      currentValues[2] = valueJ;
    }

    return currentValues;
  }
}