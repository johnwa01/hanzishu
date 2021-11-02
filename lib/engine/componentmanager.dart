import 'dart:math';
import 'package:hanzishu/engine/component.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/componentlist.dart';


class ComponentManager {
  var currentQuestionType = QuestionType
      .ComponentGroup; // starting with 1, 0 for no more
  int currentIndex = 1;
  AnswerPosition correctAnswerPosition;

  initValues() {
    currentQuestionType =
        QuestionType.ComponentGroup; // starting with 1, 0 for no more
  }

  int getTotalQuestions(QuestionType questionType) {
    int total;
    if (questionType == QuestionType.ComponentGroup) {
      total = theComponentGroupListInRealExercise.length;
    }
    else if (questionType == QuestionType.ComponentInGroup) {
      total = theComponentInGroupList.length;
    }
    else if (questionType == QuestionType.Component) {
      total = theRandomComponentList.length;
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
    this.currentIndex = 0; // skip the 0 which is a placeholder one
  }

  //List<String> getCurrentValues() {
  //  return currentValues;
  //}

  //TODO: a nicer way to compare a range
  bool isGroupOrIndividualAnswerType(AnswerPosition answerPosition) {
    if (answerPosition == AnswerPosition.none ||
        answerPosition == AnswerPosition.continueNext) {
      return false;
    }

    return true;
  }

  static GroupAndIndexPair getGroupAndIndexFromLetter(String letter) {
    var pair;

    switch (letter) {
      case "A":
        {
          pair = GroupAndIndexPair(3, 5);
        }
        break;
      case "B":
        {
          pair = GroupAndIndexPair(5, 1);;
        }
        break;
      case "C":
        {
          pair = GroupAndIndexPair(5, 3);
        }
        break;
      case "D":
        {
          pair = GroupAndIndexPair(3, 3);
        }
        break;
      case "E":
        {
          pair = GroupAndIndexPair(1, 3);
        }
        break;
      case "F":
        {
          pair = GroupAndIndexPair(3, 2);
        }
        break;
      case "G":
        {
          pair = GroupAndIndexPair(3, 1);
        }
        break;
      case "H":
        {
          pair = GroupAndIndexPair(4, 1);
        }
        break;
      case "I":
        {
          pair = GroupAndIndexPair(2, 3);
        }
        break;
      case "J":
        {
          pair = GroupAndIndexPair(4, 2);
        }
        break;
      case "K":
        {
          pair = GroupAndIndexPair(4, 3);
        }
        break;
      case "L":
        {
          pair = GroupAndIndexPair(4, 4);
        }
        break;
      case "M":
        {
          pair = GroupAndIndexPair(6, 2);
        }
        break;
      case "N":
        {
          pair = GroupAndIndexPair(6, 1);
        }
        break;
      case "O":
        {
          pair = GroupAndIndexPair(2, 4);
        }
        break;
      case "P":
        {
          pair = GroupAndIndexPair(2, 5);
        }
        break;
      case "Q":
        {
          pair = GroupAndIndexPair(1, 5);
        }
        break;
      case "R":
        {
          pair = GroupAndIndexPair(1, 2);
        }
        break;
      case "S":
        {
          pair = GroupAndIndexPair(3, 4);
        }
        break;
      case "T":
        {
          pair = GroupAndIndexPair(1, 1);
        }
        break;
      case "U":
        {
          pair = GroupAndIndexPair(2, 2);
        }
        break;
      case "V":
        {
          pair = GroupAndIndexPair(5, 2);
        }
        break;
      case "W":
        {
          pair = GroupAndIndexPair(1, 4);
        }
        break;
      case "X":
        {
          pair = GroupAndIndexPair(5, 4);
        }
        break;
      case "Y":
        {
          pair = GroupAndIndexPair(2, 1);
        }
        break;
      // not expect Z
    }

    return pair;
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
      case 1:
        {
          posi = AnswerPosition.groupPosition1;
        }
        break;
      case 2:
        {
          posi = AnswerPosition.groupPosition2;
        }
        break;
      case 3:
        {
          posi = AnswerPosition.groupPosition3;
        }
        break;
      case 4:
        {
          posi = AnswerPosition.groupPosition4;
        }
        break;
      case 5:
        {
          posi = AnswerPosition.groupPosition5;
        }
        break;
      case 6:
        {
          posi = AnswerPosition.groupPosition6;
        }
        break;
    }

    return posi;
  }

  AnswerPosition getPositionByGroupAndIndex(int groupNumber, int indexNumber) {
    AnswerPosition posi = AnswerPosition.none;
    if (groupNumber == 1) {
      if (indexNumber == 1) {
        posi = AnswerPosition.individual11;
      }
      else if (indexNumber == 2) {
        posi = AnswerPosition.individual12;
      }
      else if (indexNumber == 3) {
        posi = AnswerPosition.individual13;
      }
      else if (indexNumber == 4) {
        posi = AnswerPosition.individual14;
      }
      else if (indexNumber == 5) {
        posi = AnswerPosition.individual15;
      }
    }
    else if (groupNumber == 2) {
      if (indexNumber == 1) {
        posi = AnswerPosition.individual21;
      }
      else if (indexNumber == 2) {
        posi = AnswerPosition.individual22;
      }
      else if (indexNumber == 3) {
        posi = AnswerPosition.individual23;
      }
      else if (indexNumber == 4) {
        posi = AnswerPosition.individual24;
      }
      else if (indexNumber == 5) {
        posi = AnswerPosition.individual25;
      }
    }
    else if (groupNumber == 3) {
      if (indexNumber == 1) {
        posi = AnswerPosition.individual31;
      }
      else if (indexNumber == 2) {
        posi = AnswerPosition.individual32;
      }
      else if (indexNumber == 3) {
        posi = AnswerPosition.individual33;
      }
      else if (indexNumber == 4) {
        posi = AnswerPosition.individual34;
      }
      else if (indexNumber == 5) {
        posi = AnswerPosition.individual35;
      }
    }
    else if (groupNumber == 4) {
      if (indexNumber == 1) {
        posi = AnswerPosition.individual41;
      }
      else if (indexNumber == 2) {
        posi = AnswerPosition.individual42;
      }
      else if (indexNumber == 3) {
        posi = AnswerPosition.individual43;
      }
      else if (indexNumber == 4) {
        posi = AnswerPosition.individual44;
      }
    }
    else if (groupNumber == 5) {
      if (indexNumber == 1) {
        posi = AnswerPosition.individual51;
      }
      else if (indexNumber == 2) {
        posi = AnswerPosition.individual52;
      }
      else if (indexNumber == 3) {
        posi = AnswerPosition.individual53;
      }
      else if (indexNumber == 4) {
        posi = AnswerPosition.individual54;
      }
    }
    else if (groupNumber == 6) {
      if (indexNumber == 1) {
        posi = AnswerPosition.individual61;
      }
      else if (indexNumber == 2) {
        posi = AnswerPosition.individual62;
      }
    }

    return posi;
  }

  void resetCorrectAnswerPosition() {
    correctAnswerPosition = AnswerPosition.none;
  }

  AnswerPosition getCorrectAnswerPosition() {
    if (correctAnswerPosition != null &&
        correctAnswerPosition != AnswerPosition.none) {
      return correctAnswerPosition;
    }

    if (currentQuestionType == QuestionType.ComponentGroup) {
      var index = theComponentGroupListInRealExercise[currentIndex];
      var group = theComponentGroupList[index];
      correctAnswerPosition = GetPositionByGroup(group.id);
    }
    else if (currentQuestionType == QuestionType.Component) {
      var comp = theRandomComponentList[currentIndex];
      correctAnswerPosition =
          getPositionByGroupAndIndex(comp.groupNumber, comp.indexInGroup);
    }
    else if (currentQuestionType == QuestionType.ComponentInGroup) {
      var compInGroup = theComponentInGroupList[currentIndex];
      correctAnswerPosition = getPositionByGroupAndIndex(
          compInGroup.groupNumber, compInGroup.indexInGroup);
    }
    else if (currentQuestionType == QuestionType.ExpandedComponent) {
      var expandedComp = theExpandedComponentList[currentIndex];
      correctAnswerPosition = getPositionByGroupAndIndex(
          expandedComp.groupNumber, expandedComp.indexInGroup);
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

  // of the current question type
  int getNextIndex() {
    currentIndex++;
    if (currentIndex >= getTotalQuestions(currentQuestionType)) {
      return -1;
    }

    return currentIndex;
  }

  String getCurrentComponentValue() {
    var comp;

    if (currentQuestionType == QuestionType.Component) {
      comp = getComponentFromRandomComponentList(currentIndex);
    }
    else { // ComponentInGroup
      comp = getComponentFromComponentInGroup(currentIndex);
    }

    if (comp != null) {
      return comp.charOrNameOfNonchar;
    }

    return '';
  }

  LeadComponent getComponent(int id) {
    return theLeadComponentList[id];
  }

  int getCurrentComponentId() {
    var comp;
    if (currentQuestionType == QuestionType.Component) {
      comp = getComponentFromRandomComponentList(currentIndex);
    }
    else { // ComponentInGroup
      comp = getComponentFromComponentInGroup(currentIndex);
    }

    if (comp != null) {
      return comp.id;
    }
    else {
      return -1;
    }
  }

  int getComponentIdByCode(String code) {
    var leng = theLeadComponentList.length;
    var comp;

    for (int i = 0; i < leng; i++) {
      comp = theLeadComponentList[i];
      if (comp.doubleByteName == code) {
        return i;
      }
    }

    return -1;
  }

  LeadComponent getComponentByGroupAndIndex(int groupNumber, int indexInGroup) {
    var leng = theLeadComponentList.length;
    var comp;

    for (int i = 0; i < leng; i++) {
      comp = theLeadComponentList[i];
      if (comp.groupNumber == groupNumber &&
          comp.indexInGroup == indexInGroup) {
        return comp;
      }
    }

    return null;
  }

  ComponentCollection getFullExpandedComponentByGroupAndIndex(int groupNumber, int indexInGroup) {
    var leng = theFullExpandedComponentList.length;
    var comp;

    for (int i = 0; i < leng; i++) {
      comp = theFullExpandedComponentList[i];
      if (comp.groupNumber == groupNumber &&
          comp.indexInGroup == indexInGroup) {
        return comp;
      }
    }

    return null;
  }

  LeadComponent getComponentFromComponentInGroup(int index) {
    var compInGroup = theComponentInGroupList[index];
    var groupNumber = compInGroup.groupNumber;
    var indexInGroup = compInGroup.indexInGroup;
    return getComponentByGroupAndIndex(groupNumber, indexInGroup);
  }

  LeadComponent getComponentFromRandomComponentList(int index) {
    var comp = theRandomComponentList[index];
    var groupNumber = comp.groupNumber;
    var indexInGroup = comp.indexInGroup;
    return getComponentByGroupAndIndex(groupNumber, indexInGroup);
  }

  bool isCurrentComponentChar() {
    bool isChar = false;
    var comp;
    if (currentQuestionType == QuestionType.Component) {
      comp = getComponentFromRandomComponentList(currentIndex);
    }
    else { // ComponentInGroup
      comp = getComponentFromComponentInGroup(currentIndex);
    }

    if (comp != null) {
      isChar = comp.isChar;
    }

    return isChar;
  }

  // the component index is 0, indicating to show the group image only
  bool isHeaderOfComponentInGroup() {
    if (currentQuestionType == QuestionType.ComponentInGroup) {
      if (theComponentInGroupList[currentIndex].indexInGroup == 0) {
        return true;
      }
    }

    return false;
  }

  // the group index is 0, indicating to show the image for whole groups
  bool isHeaderOfGroups() {
    if (currentQuestionType == QuestionType.ComponentGroup) {
      var index = theComponentGroupListInRealExercise[currentIndex];
      if (theComponentGroupList[index].id == 0) {
        return true;
      }
    }

    return false;
  }

  bool isHeaderOfRandomComponents() {
    if (currentQuestionType == QuestionType.Component) {
      if (theRandomComponentList[currentIndex].groupNumber == 0) {
        return true;
      }
    }

    return false;
  }

  bool isHeaderOfExpandedComponents() {
    if (currentQuestionType == QuestionType.ExpandedComponent) {
      if (theExpandedComponentList[currentIndex].groupNumber == 0) {
        return true;
      }
    }

    return false;
  }

  int getCurrentGroupNumberOfComponentInGroup(AnswerPosition position) {
    int groupNumber = -1;
    if (position == AnswerPosition.individual11 ||
        position == AnswerPosition.individual12 ||
        position == AnswerPosition.individual13 ||
        position == AnswerPosition.individual14 ||
        position == AnswerPosition.individual15) {
      groupNumber = 1;
    }
    else if (position == AnswerPosition.individual21 ||
        position == AnswerPosition.individual22 ||
        position == AnswerPosition.individual23 ||
        position == AnswerPosition.individual24 ||
        position == AnswerPosition.individual25) {
      groupNumber = 2;
    }
    else if (position == AnswerPosition.individual31 ||
        position == AnswerPosition.individual32 ||
        position == AnswerPosition.individual33 ||
        position == AnswerPosition.individual34 ||
        position == AnswerPosition.individual35) {
      groupNumber = 3;
    }
    else if (position == AnswerPosition.individual41 ||
        position == AnswerPosition.individual42 ||
        position == AnswerPosition.individual43 ||
        position == AnswerPosition.individual44) {
      groupNumber = 4;
    }
    else if (position == AnswerPosition.individual51 ||
        position == AnswerPosition.individual52 ||
        position == AnswerPosition.individual53 ||
        position == AnswerPosition.individual54) {
      groupNumber = 5;
    }
    else if (position == AnswerPosition.individual61 ||
        position == AnswerPosition.individual62) {
      groupNumber = 6;
    }

    return groupNumber;
  }

  bool isPositionAtRightGroup(AnswerPosition position) {
    if (currentQuestionType == QuestionType.ComponentInGroup) {
      var groupNumber = getCurrentGroupNumberOfComponentInGroup(position);

      if (theComponentInGroupList[currentIndex].groupNumber != groupNumber) {
        return false;
      }
    }

    return true;
  }

// TODO: Move to manager
  String getAnswerDisplayValue(AnswerPosition position) {
    if (position == AnswerPosition.none) {
      return "";
    }

    var value;
    //var currentValues = theComponentManager.getCurrentValues();

    switch (position) {
      case AnswerPosition.center:
        {
          value = getCurrentComponentValue(); //"好"; //currentValues[0];
        }
        break;
      case AnswerPosition.groupPosition1:
        {
          value = "Group 1";
        }
        break;
      case AnswerPosition.groupPosition2:
        {
          value = "Group 2";
        }
        break;
      case AnswerPosition.groupPosition3:
        {
          value = "Group 3";
        }
        break;
      case AnswerPosition.groupPosition4:
        {
          value = "Group 4";
        }
        break;
      case AnswerPosition.groupPosition5:
        {
          value = "Group 5";
        }
        break;
      case AnswerPosition.groupPosition6:
        {
          value = "Group 6";
        }
        break;
      case AnswerPosition.individual11:
        {
          value = "11";
        }
        break;
      case AnswerPosition.individual12:
        {
          value = "12";
        }
        break;
      case AnswerPosition.individual13:
        {
          value = "13";
        }
        break;
      case AnswerPosition.individual14:
        {
          value = "14";
        }
        break;
      case AnswerPosition.individual15:
        {
          value = "15";
        }
        break;
      case AnswerPosition.individual21:
        {
          value = "21";
        }
        break;
      case AnswerPosition.individual22:
        {
          value = "22";
        }
        break;
      case AnswerPosition.individual23:
        {
          value = "23";
        }
        break;
      case AnswerPosition.individual24:
        {
          value = "24";
        }
        break;
      case AnswerPosition.individual25:
        {
          value = "25";
        }
        break;
      case AnswerPosition.individual31:
        {
          value = "31";
        }
        break;
      case AnswerPosition.individual32:
        {
          value = "32";
        }
        break;
      case AnswerPosition.individual33:
        {
          value = "33";
        }
        break;
      case AnswerPosition.individual34:
        {
          value = "34";
        }
        break;
      case AnswerPosition.individual35:
        {
          value = "35";
        }
        break;
      case AnswerPosition.individual41:
        {
          value = "41";
        }
        break;
      case AnswerPosition.individual42:
        {
          value = "42";
        }
        break;
      case AnswerPosition.individual43:
        {
          value = "43";
        }
        break;
      case AnswerPosition.individual44:
        {
          value = "44";
        }
        break;
      case AnswerPosition.individual51:
        {
          value = "51";
        }
        break;
      case AnswerPosition.individual52:
        {
          value = "52";
        }
        break;
      case AnswerPosition.individual53:
        {
          value = "53";
        }
        break;
      case AnswerPosition.individual54:
        {
          value = "54";
        }
        break;
      case AnswerPosition.individual61:
        {
          value = "61";
        }
        break;
      case AnswerPosition.individual62:
        {
          value = "62";
        }
        break;
      default:
        value = '';
    }

    return value;
  }
}
