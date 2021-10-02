import 'dart:math';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/componentlist.dart';


class ComponentManager {
  var currentQuestionType = QuestionType.ComponentGroup; // starting with 1, 0 for no more
   int currentIndex = 1;
  AnswerPosition correctAnswerPosition;

  initValues() {
    currentQuestionType = QuestionType.ComponentGroup; // starting with 1, 0 for no more
  }

  int getTotalQuestions(QuestionType questionType) {
    int total;
    if (questionType == QuestionType.ComponentGroup) {
      total = theComponentGroupList.length;
    }
    else if (questionType == QuestionType.ComponentInGroup) {
      total = theLeadComponentList.length;
    }
    else if (questionType == QuestionType.Component) {
      total = theLeadComponentList.length;
    }
    else if (questionType == QuestionType.ExpandedComponent) {
      total = theExpandedComponentList.length;
    }

    return total;
  }

  QuestionType getCurrentType() {
    return currentQuestionType;
  }

  setCurrentType(QuestionType currentType) {
    this.currentQuestionType = currentType;
  }

  initCurrentIndex() {
    this.currentIndex = 0;  // skip the 0 which is a placeholder one
  }

  //List<String> getCurrentValues() {
  //  return currentValues;
  //}

  //TODO: a nicer way to compare a range
  bool isGroupOrIndividualAnswerType(AnswerPosition answerPosition) {
    if (answerPosition == AnswerPosition.none || answerPosition == AnswerPosition.continueNext) {
          return false;
    }

    return true;
  }


  AnswerType getAnswerType(AnswerPosition answerPosition) {
    if (answerPosition == AnswerPosition.continueNext) {
      return AnswerType.ContinueNext;
    }
    else if (answerPosition == AnswerPosition.groupPosition1 ||
        answerPosition == AnswerPosition.groupPosition2 ||
        answerPosition == AnswerPosition.groupPosition3 ||
        answerPosition == AnswerPosition.groupPosition4 ||
        answerPosition == AnswerPosition.groupPosition5 ||
        answerPosition == AnswerPosition.groupPosition6) {
          return AnswerType.GroupNumber;
    }
    else {
          return AnswerType.IndividualNumber;
    }
  }

  AnswerPosition GetPositionByGroup(int index) {
    AnswerPosition posi = AnswerPosition.none;

    switch (index) {
        case 1: {
          posi = AnswerPosition.groupPosition1;
        }
        break;
        case 2: {
          posi = AnswerPosition.groupPosition2;
        }
        break;
        case 3: {
          posi = AnswerPosition.groupPosition3;
        }
        break;
        case 4: {
          posi = AnswerPosition.groupPosition4;
        }
        break;
        case 5: {
          posi = AnswerPosition.groupPosition5;
        }
        break;
        case 6: {
          posi = AnswerPosition.groupPosition6;
        }
        break;
    }

    return posi;
  }

  AnswerPosition getPositionByGroupAndIndex(int groupNumber, int indexNumber) {
    AnswerPosition posi = AnswerPosition.none;
    if (groupNumber == 1) {
      if (indexNumber == 1) { posi = AnswerPosition.individual11; }
      else if (indexNumber == 2) { posi = AnswerPosition.individual12; }
      else if (indexNumber == 3) { posi = AnswerPosition.individual13; }
      else if (indexNumber == 4) { posi = AnswerPosition.individual14; }
      else if (indexNumber == 5) { posi = AnswerPosition.individual15; }
    }
    else if (groupNumber == 2) {
      if (indexNumber == 1) { posi = AnswerPosition.individual21; }
      else if (indexNumber == 2) { posi = AnswerPosition.individual22; }
      else if (indexNumber == 3) { posi = AnswerPosition.individual23; }
      else if (indexNumber == 4) { posi = AnswerPosition.individual24; }
      else if (indexNumber == 5) { posi = AnswerPosition.individual25; }
    }
    else if (groupNumber == 3) {
      if (indexNumber == 1) { posi = AnswerPosition.individual31; }
      else if (indexNumber == 2) { posi = AnswerPosition.individual32; }
      else if (indexNumber == 3) { posi = AnswerPosition.individual33; }
      else if (indexNumber == 4) { posi = AnswerPosition.individual34; }
      else if (indexNumber == 5) { posi = AnswerPosition.individual35; }
    }
    else if (groupNumber == 4) {
      if (indexNumber == 1) { posi = AnswerPosition.individual41; }
      else if (indexNumber == 2) { posi = AnswerPosition.individual42; }
      else if (indexNumber == 3) { posi = AnswerPosition.individual43; }
      else if (indexNumber == 4) { posi = AnswerPosition.individual44; }
    }
    else if (groupNumber == 5) {
      if (indexNumber == 1) { posi = AnswerPosition.individual51; }
      else if (indexNumber == 2) { posi = AnswerPosition.individual52; }
      else if (indexNumber == 3) { posi = AnswerPosition.individual53; }
      else if (indexNumber == 4) { posi = AnswerPosition.individual54; }
    }
    else if (groupNumber == 6) {
      if (indexNumber == 1) { posi = AnswerPosition.individual61; }
      else if (indexNumber == 2) { posi = AnswerPosition.individual62; }
    }

    return posi;
  }

  void resetCorrectAnswerPosition() {
    correctAnswerPosition = AnswerPosition.none;
  }

  AnswerPosition getCorrectAnswerPosition() {
    if (correctAnswerPosition != null && correctAnswerPosition != AnswerPosition.none) {
      return correctAnswerPosition;
    }

    if (currentQuestionType == QuestionType.ComponentGroup) {
      var group = theComponentGroupList[currentIndex];
      correctAnswerPosition = GetPositionByGroup(group.id);
    }
    else if (currentQuestionType == QuestionType.Component) {
      var comp = theLeadComponentList[currentIndex];
      correctAnswerPosition = getPositionByGroupAndIndex(comp.groupNumber, comp.indexInGroup);
    }
    else if (currentQuestionType == QuestionType.ComponentInGroup) {
      var compInGroup = theComponentInGroupList[currentIndex];
      correctAnswerPosition = getPositionByGroupAndIndex(compInGroup.groupNumber, compInGroup.indexInGroup);
    }
    else if (currentQuestionType == QuestionType.ExpandedComponent) {
      var expandedComp = theExpandedComponentList[currentIndex];
      correctAnswerPosition = getPositionByGroupAndIndex(expandedComp.groupNumber, expandedComp.indexInGroup);
    }

    return correctAnswerPosition;
  }

  int getCurrentNoncharId() {
    return 100; //TODO: temp
  }

  int getFirstIndex(QuestionType questionType) {
    //TODO
    return 0;
  }

  /*
  int getMaximumNumberForQuestionType(QuestionType questionType) {
    if (questionType == QuestionType.ComponentGroup) {
      return theComponentGroupList.length;
    }
    else if (questionType == QuestionType.LeadingComponent) {
      return theLeadComponentList.length;
    }
    else if (questionType == QuestionType.ExpandedComponent) {
      return theExpandedComponentList.length;
    }

    return -1;
  }
*/

  // of the current question type
  int getNextIndex() {
    currentIndex++;
    if (currentIndex >= getTotalQuestions(currentQuestionType)) {
      return -1;
    }

    return currentIndex;
  }

  String getCurrentComponentValue() {
    if (currentQuestionType == QuestionType.Component) {
      return theLeadComponentList[currentIndex].charOrNameOfNonchar;
    }
    else { // ComponentInGroup
      var comp = getComponentFromComponentInGroup(currentIndex);
      if (comp != null) {
        return comp.charOrNameOfNonchar;
      }
    }

    return '';
  }

  Component getComponent(int id) {
    return theLeadComponentList[id];
  }

  int getCurrentComponentId() {
    if (currentQuestionType == QuestionType.Component) {
      return theLeadComponentList[currentIndex].id;
    }
    else { // ComponentInGroup
      var  comp = getComponentFromComponentInGroup(currentIndex);
      if (comp != null) {
        return comp.id;
      }
      else {
        return -1;
      }
    }
  }

  Component getComponentByGroupAndIndex(int groupNumber, int indexInGroup) {
    var leng = theLeadComponentList.length;
    var comp;

    for (int i = 0; i < leng; i++) {
      comp = theLeadComponentList[i];
      if (comp.groupNumber == groupNumber && comp.indexInGroup == indexInGroup) {
        return comp;
      }
    }

    return null;
  }

  Component getComponentFromComponentInGroup(int index) {
    var compInGroup = theComponentInGroupList[index];
    var groupNumber = compInGroup.groupNumber;
    var indexInGroup = compInGroup.indexInGroup;
    return getComponentByGroupAndIndex(groupNumber, indexInGroup);
  }

  bool isCurrentComponentChar() {
    bool isChar = false;
    if (currentQuestionType == QuestionType.Component) {
      isChar = theLeadComponentList[currentIndex].isChar;
    }
    else {   // ComponentInGroup
      var comp = getComponentFromComponentInGroup(currentIndex);
      if (comp != null) {
        isChar = comp.isChar;
      }
    }

    return isChar;
  }
}
