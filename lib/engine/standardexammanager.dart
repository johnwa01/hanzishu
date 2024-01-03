import 'dart:math';
import 'package:hanzishu/data/searchingzilist.dart';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/engine/dictionary.dart';
import 'package:hanzishu/engine/quizmanager.dart';


class StandardExamManager {
  DrillCategory currentDrillCategory;
  int currentSubItemId;
  QuizCategory currentQuizCategory;

  // The two numbers have to be divisible by 3
  static List<int> maxExamNumber = [30, 45, 60];
  int currentMaxExamNumber;

  int currentCount = 0;
  int currentId;

  var currentType = QuizType.chars; // only supported type for HSK etc

  List<SearchingZi> currentValues = [null, null, null, null];
  var correctPosition = 0;
  var minUpperRange = 5; // 0 based, so 5+1=6

  List<int> usedIDs;

  List<int> currentCorrectRandoms;

  List<String> fullSubList = ['灵', '覃', '阶', '敢', '因', '众', '醒', '已', '啥'];
  /*
  List<List<String>> testSubLists = [['覃', '阶', '敢', '众', '醒', '已', '啥'],
    ['阶', '敢', '众', '醒', '已', '啥'],
    ['敢', '众', '醒', '已', '啥'],
    ['众', '醒', '已', '啥'],
    ['醒', '已', '啥', '已', '啥'],
    ['敢', '众', '醒', '已', '啥']];*/

  //List<List<SearchingZi>> testSubLists = [[], [], [], [], [], [], []];

  List<SearchingZi> currentTestSubList = [];

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


    if (currentDrillCategory == DrillCategory.all || (currentDrillCategory == DrillCategory.hsk && currentSubItemId == 0)) {
      currentMaxExamNumber = maxExamNumber[2];
    }
    else if (currentDrillCategory == DrillCategory.hsk && currentSubItemId == 7) {
      currentMaxExamNumber = maxExamNumber[1];
    }
    else {
      currentMaxExamNumber = maxExamNumber[0];
    }

    currentCorrectRandoms = [0, 0, 0];

    //createFullSubList(subItemId);

    // create submenu lists from the general menu
    //createTestSubList(subItemId);
    createCurrentTestSubList(currentDrillCategory, subItemId, 0 /*lessonId*/);

    currentId = getNext();
  }

  int getTotalQuestions() {
      return currentMaxExamNumber;
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
    return getNextHelper(/*currentSubItemId*/);
  }

  int getNextHelper(/*int drillSubMenu*/) {
    if (currentCount < (currentTestSubList.length - 1)) {
      if (currentCount >= currentMaxExamNumber) {
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

  /*
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
  */

  // level and lesson start at 1; level 0 = all levels of the category, lesson 0 = all lessons of the level
  createCurrentTestSubList(DrillCategory category, int level, int lesson) {
      currentTestSubList.clear();

      if (category == DrillCategory.all) {
        for (int i = 52; i < theSearchingZiList.length; i++) {
            currentTestSubList.add(theSearchingZiList[i]);
        }
      }
      else if (category == DrillCategory.hsk) {
        int hskLevel;
        for (int i = 52; i < theSearchingZiList.length; i++) {
          hskLevel = theSearchingZiList[i].levelHSK;
          if ((level == 0 && (hskLevel >= 1 && hskLevel <=7)) || (level != 0 && level == hskLevel)) {
            currentTestSubList.add(theSearchingZiList[i]);
          }
        }
     }
  }

  int getCurrentTestSubListTotal() {
    return currentTestSubList.length;
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
    return currentTestSubList; //[currentSubItemId - 1];;
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

  int getCorrectRandom() {
    int oneThirdNumberMinusOne = (currentMaxExamNumber / 3).toInt() - 1;

    Random rand = Random();

    int nextRand;
    do {
      if ((currentCorrectRandoms[0] > oneThirdNumberMinusOne) && (currentCorrectRandoms[1] > oneThirdNumberMinusOne) && (currentCorrectRandoms[2] > oneThirdNumberMinusOne)) {
        return -1;
      }

      nextRand = rand.nextInt(3);
    }
    while (currentCorrectRandoms[nextRand] > oneThirdNumberMinusOne);

    currentCorrectRandoms[nextRand] += 1;
    // 1 based.
    return (1 + nextRand); // 0, 1, 2 -> +1
  }

  List<SearchingZi> getUpdatedValues(/*int index, bool isMeaning*/) {
    var upperRange = getUpperRange();

    currentValues[0] = getOneValueById(currentId);
    var nonCharId0 = 0;

    // 1 based.
    correctPosition = getCorrectRandom();

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