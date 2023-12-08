import 'dart:math';
import 'package:hanzishu/engine/drill.dart';
import 'package:hanzishu/engine/quizmanager.dart';


class StandardExamManager {
  DrillCategory currentDrillCategory;
  int currentDrillSubMenu = 0;
  QuizCategory currentQuizCategory;

  int currentId = 0;

  var currentType = QuizType.chars; // only supported type for HSK etc

  List<String> currentValues = ["", "", "", ""];
  var correctPosition = 0;
  var minUpperRange = 5; // 0 based, so 5+1=6

  List<String> fullSubList = ['灵', '覃', '阶', '敢', '因', '众', '醒', '已', '啥'];
  List<String> testSubList = ['覃', '阶', '敢', '众', '醒', '已', '啥'];

  initValues(DrillCategory drillCategory, int subItemId, QuizCategory quizCategory) {
    // set all ini values for this drillCategory
    currentDrillCategory = drillCategory;
    currentDrillSubMenu = subItemId;
    currentQuizCategory = quizCategory;

    currentId = 0;
    currentValues = ["", "", "", ""];
    correctPosition = 0;

    createFullSubList(subItemId);

    // create a random list of n values in a submenu
    createTestSubList(subItemId);
  }

  int getTotalQuestions() {
    return testSubList.length;
  }

  List<String> getCurrentValues() {
    return currentValues;
  }

  int getNext() {
    return getNextHelper(currentDrillSubMenu);
  }

  int getNextHelper(int drillSubMenu) {
    if (currentId < (testSubList.length - 1)) {
      currentId++;
      return currentId;
    }

    return -1;
  }

  createFullSubList(int drillSubMenu) {
    return fullSubList;
  }

  createTestSubList(int drillSubMenu) {
    return testSubList;
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

  List<String> getCurrentTypeList() {
    return getTypeList(currentType);
  }

  List<String> getTypeList(QuizType type) {
    return createTestSubList(currentDrillSubMenu);
  }

  String getOneValueById(int id) {
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

  List<String> getUpdatedValues(/*int index, bool isMeaning*/) {
    var upperRange;

      var list = getCurrentTypeList();
      upperRange = list.length - 1;
      if (upperRange < minUpperRange) {
        upperRange = minUpperRange;
      }

    currentValues[0] = getOneValueById(currentId);
    var nonCharId0 = 0;

    Random rand = Random();
    // 1 based.
    correctPosition = 1 + rand.nextInt(3 - 1);

    // 1 based position when creating randon number
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