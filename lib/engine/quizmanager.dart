import 'dart:math';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/data/phraselist.dart';
import 'package:hanzishu/data/sentencelist.dart';
import 'package:hanzishu/variables.dart';

enum QuizTextbook {
  hanzishu,
  wordsStudy,
  //yuwen
}

enum QuizCategory {
  meaning,
  sound
}

enum QuizType {
  none,
  basicChars,
  chars,
  nonChars,
  phrases,
  conversations
}

/*
enum QuizState {
  none,
  soundIconPressed,
  answered
}
*/

enum AnswerPosition {
  none,
  soundIcon,
  center,
  positionA,
  positionB,
  positionC,
  continueNext
}

class LessonAndIndex {
  int lessonId;
  int indexDiff;

  LessonAndIndex(
      int lessonId,
      int indexDiff
      ) {
    this.lessonId = lessonId;
    this.indexDiff = indexDiff;
  }
}

class QuizManager {
  //static String theChoiceA = "choiceA";
  //static String theChoiceB = "choiceB";
  //static String theChoiceC = "choiceC";
  //static String thePinyinA = "pinyinA";
  //static String thePinyinB = "pinyinB";
  //static String thePinyinC = "pinyinC";

  var minUpperRange = 5; // 0 based, so 5+1=6
  var currentLesson = 0;
  var currentCategory = QuizCategory.meaning;
  var currentType = QuizType.chars; // starting with 1, 0 for no more
  var nextIndexForCurrentType = 0;
  var currentIndex = 0;
  List<String> currentValues = ["", "", "", ""];
  List<int> currentValuesNonCharIds = [0, 0, 0, 0];
  var correctPosition = 0;
  //TODO: remove following two variables since they are handled in UI?
  var soundIconPressed = false;
  var answered = false;
  //TODO: init to calculate the max number of zi up to a certain lessons
  //TODO: add an Answered variable so that no further action

  initValues() {
    currentLesson = 0;
    currentCategory = QuizCategory.meaning;
    currentType = QuizType.chars; // starting with 1, 0 for no more
    nextIndexForCurrentType = 0;
    currentIndex = 0;
    currentValues = ["", "", "", ""];
    currentValuesNonCharIds = [0, 0, 0, 0];
    correctPosition = 0;
    soundIconPressed = false;
    answered = false;
  }

  bool isSoundIconPressed() {
    return soundIconPressed;
  }

  setSoundIconPressed(bool state) {
    soundIconPressed = state;
  }

  bool isAnswered(){
    return answered;
  }

  setAnswered(bool state) {
    answered = state;
  }

  QuizCategory getCurrentCategory() {
    return currentCategory;
  }

  setCurrentCategory(QuizCategory category) {
    currentCategory = category;
  }

  int getFirstIndex(int lessonId) {
    currentLesson = lessonId;

    currentCategory = QuizCategory.meaning;

    var index = 0;

    var lesson = theLessonList[lessonId];

    if (lesson.convCharsIds.length > 0) {
      //id = lesson.convCharsIds[0]
      currentType = QuizType.chars;
    }
    else if (lesson.charsIds.length > 0) {
      //id = lesson.charsIds[0]
      currentType = QuizType.basicChars;
    }
    else if (lesson.comps.length > 0) {
      //id = lesson.comps[0]
      currentType = QuizType.nonChars;
    }
    else if (lesson.phraseIds.length > 0) {
      //id = lesson.phraseIds[0]
      currentType = QuizType.phrases;
    }
    else if (lesson.sentenceList.length > 0) {
      //id = lesson.sentenceList[0]
      currentType = QuizType.conversations;
    }

    return index;
  }

  int getTotalQuestions(int lessonId) {
    var lesson = theLessonList[lessonId];

    return lesson.convCharsIds.length + lesson.charsIds.length + lesson.comps.length + lesson.phraseIds.length + lesson.sentenceList.length;
  }

  // zis, phrases or conversations
  int getIdByIndexInLesson(QuizType type, LessonAndIndex lessonIdAndIndex) {
    var id = 0;
    var lesson = theLessonList[lessonIdAndIndex.lessonId];

    switch (type) {
      case QuizType.basicChars:
        id = lesson.charsIds[lessonIdAndIndex.indexDiff];
        break;
      case QuizType.chars:
        id = lesson.convCharsIds[lessonIdAndIndex.indexDiff];
        break;
      case QuizType.nonChars:
        id = lesson.comps[lessonIdAndIndex.indexDiff];
        break;
      case QuizType.phrases:
        id = lesson.phraseIds[lessonIdAndIndex.indexDiff];
        break;
      case QuizType.conversations:
        id = lesson.sentenceList[lessonIdAndIndex.indexDiff];
        break;
      case QuizType.none:
        break;
    }

    return id;
  }

  QuizType getCurrentType() {
    return currentType;
  }

  resetCurrentTypeToNextNonEmptyTypeOrNone() {
    var isEmptyOrNone = true;
    while (isEmptyOrNone) {
      resetCurrentTypeToNext();
      if (currentType == QuizType.none || !isCurrentTypeEmpty()) {
        isEmptyOrNone = false;
      }
    }
  }

  bool isCurrentTypeEmpty() {
    var list = getCurrentTypeList();
    return list.length == 0;
  }

  resetCurrentTypeToNext() {
    var nextType = currentType;

    switch (currentType) {
      case QuizType.none:
        nextType = QuizType.chars;
        break;
      case QuizType.chars:
        nextType = QuizType.basicChars;
        break;
      case QuizType.basicChars:
        nextType = QuizType.nonChars;
        break;
      case QuizType.nonChars:
        nextType = QuizType.phrases;
        break;
      case QuizType.phrases:
        nextType = QuizType.conversations;
        break;
      case QuizType.conversations:
        if (currentCategory == QuizCategory.meaning) {
          currentCategory = QuizCategory.sound;
          nextType = QuizType.chars;
        }
        else {  // already in sound category
          nextType = QuizType.none;
        }
        break;
      //default:
      //    nextType = QuizType.chars
    }

    currentType = nextType;
  }

  int getCurrentIndex() {
    return currentIndex;
  }

  int getCurrentLesson() {
    return currentLesson;
  }

  int getTypeListCountForLesson(QuizType type, int lessonId) {
    return getTypeListForLesson(type, lessonId).length;
  }

  List<int> getTypeListForLesson(QuizType type, int lessonId) {
    var lesson = theLessonList[lessonId];
    switch (type) {
      case QuizType.nonChars:
        return lesson.comps;
      case QuizType.basicChars:
        return lesson.charsIds;
      case QuizType.chars:
        return lesson.convCharsIds;
      case QuizType.phrases:
        return lesson.phraseIds;
      case QuizType.conversations:
        return lesson.sentenceList;
      case QuizType.none:
        return lesson.comps; // temp, no need
      //default:
      //    break
    }
  }

  List<int> getCurrentTypeList() {
    return getTypeList(currentType);
  }

  List<int> getTypeList(QuizType type) {
    return getTypeListForLesson(type, currentLesson);
  }

  int getNextIndexForCurrentType() {
    var list = getCurrentTypeList();
    var max = list.length;

    nextIndexForCurrentType += 1;

    // prepare for next one
    if (nextIndexForCurrentType >= max) {
      nextIndexForCurrentType = 0;
      resetCurrentTypeToNextNonEmptyTypeOrNone();

      //list = getCurrentTypeList()
    }

    // the id
    return nextIndexForCurrentType;
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

  initCurrentValuesNonCharIds() {
    currentValuesNonCharIds[0] = 0;
    currentValuesNonCharIds[1] = 0;
    currentValuesNonCharIds[2] = 0;
    currentValuesNonCharIds[3] = 0;
  }

  setNonCharId(int id0) {
    currentValuesNonCharIds[0] = id0;
  }

  setNonCharIds(int id1, int id2, int id3) {
    currentValuesNonCharIds[1] = id1;
    currentValuesNonCharIds[2] = id2;
    currentValuesNonCharIds[3] = id3;
  }

  String getOneValueById(QuizCategory category, QuizType type, int id, bool usedForQuestion) {
    var value = "";

    if (category == QuizCategory.sound || usedForQuestion) {
      switch (type) {
        case QuizType.basicChars:
          var zi = theZiManager.getZi(id);
          value = zi.char;
          break;
        case QuizType.chars:
          var zi = theZiManager.getZi(id);
          value = zi.char;
          break;
        case QuizType.nonChars:
          var zi = theZiManager.getZi(id);
          value = zi.char;
          break;
        case QuizType.phrases:
          value = thePhraseList[id].chars;
          break;
        case QuizType.conversations:
          value = theSentenceList[id].conv;
          break;
        case QuizType.none:
          break;
      }
    }
    else if (category == QuizCategory.meaning) {
      switch (type) {
        case QuizType.basicChars:
          var zi = theZiManager.getZi(id);
          value = zi.meaning;
          break;
        case QuizType.chars:
          var zi = theZiManager.getZi(id);
          value = zi.meaning;
          break;
        case QuizType.nonChars:
          var zi = theZiManager.getZi(id);
          value = zi.meaning;
          break;
        case QuizType.phrases:
          value = thePhraseList[id].meaning;
          break;
        case QuizType.conversations:
          value = theSentenceList[id].trans;
          break;
        case QuizType.none:
          break;
      }
    }

    return value;
  }

  //TODO: on inout variable - make them a lesson index pair ?
  findNeighborLessonAndIndex(QuizType type, LessonAndIndex lessonIdAndIndex) {
    var originalLesson = lessonIdAndIndex.lessonId;

    // looking at previous lessons first
    var nextLesson = lessonIdAndIndex.lessonId;
    while (nextLesson > 1) {
      nextLesson -= 1;
      var nextCount = getTypeListCountForLesson(type, nextLesson);
      if (nextCount == 0 || lessonIdAndIndex.indexDiff >= nextCount) {
        lessonIdAndIndex.indexDiff -= nextCount;
      }
      else {
        lessonIdAndIndex.lessonId = nextLesson;
        return;
      }
    }

    // looking at the next lessons second
    nextLesson = originalLesson;
    while (nextLesson < theTotalBeginnerLessons) {
      nextLesson += 1;
      var nextCount = getTypeListCountForLesson(type, nextLesson);
      if (nextCount == 0 || lessonIdAndIndex.indexDiff >= nextCount) {
        lessonIdAndIndex.indexDiff -= nextCount;
      }
      else {
        lessonIdAndIndex.lessonId = nextLesson;
        return;
      }
    }
  }

  // cross lessons if not enough
  int getIdByIndexInLessons(QuizCategory category, QuizType type, int index) {
    //var lessonIdHere = currentLesson;
    //var indexDiff = index;
    var lessonIdAndIndex = LessonAndIndex(currentLesson, index);
    var count = getTypeList(type).length;
    if (count == 0 || lessonIdAndIndex.indexDiff >= count) {
      lessonIdAndIndex.indexDiff -= count;
      findNeighborLessonAndIndex(type, lessonIdAndIndex /*lessonId: &lessonIdHere, indexDiff: &indexDiff*/);
    }

    return getIdByIndexInLesson(type, lessonIdAndIndex);
  }

  // the index in lesson
  String getOneValueByIndexInLessons(QuizCategory category, QuizType type, int index, bool usedForQuestion) {
    var typeToUse = type;
    if (category == QuizCategory.meaning && type == QuizType.nonChars && !usedForQuestion) {
      // since most nonChars don't have meaning. We want to use the meanings from same or close lessons
      typeToUse = QuizType.basicChars;
    }

    var id = getIdByIndexInLessons(category, typeToUse, index);

    return getOneValueById(currentCategory, typeToUse, id, usedForQuestion);
  }

  String getOneValueByIndexInLesson(QuizCategory category, QuizType type, int index, bool usedForQuestion) {
    var lessonIdAndIndex = LessonAndIndex(currentLesson, index);
    var id = getIdByIndexInLesson(type, lessonIdAndIndex);

    return getOneValueById(category, type, id, usedForQuestion);
  }

  // TODO: add id type paraqmeter, meaning/translation para
  List<String> getUpdatedValues(int index, bool isMeaning) {
    initCurrentValuesNonCharIds();

    //currentIndex = index
    var list = getCurrentTypeList();
    var upperRange = list.length - 1;
    if (upperRange < minUpperRange) {
      upperRange = minUpperRange;
    }

    //let zi = theZiManager.getZi(id: index)

    currentValues[0] = getOneValueByIndexInLesson(currentCategory, currentType, index, true);   //zi!.char
    //if (isMeaning) {
    //setNonCharId(zi: zi!, index: 0)
    //}
    var nonCharId0 = 0;
    if (currentType == QuizType.nonChars) {
      nonCharId0 = getIdByIndexInLessons(QuizCategory.meaning, QuizType.nonChars, index);
    }

    if (currentType == QuizType.nonChars && currentCategory == QuizCategory.meaning) {
      setNonCharId(nonCharId0);
    }

    Random rand = Random();
    // 1 based.
    correctPosition = 1 + rand.nextInt(3 - 1);

    // 1 based position when creating randon number
    var wrongPositionI = QuizManager.getARandomNumber(upperRange, index, index);
    var wrongPositionJ = QuizManager.getARandomNumber(upperRange, index, wrongPositionI);

    // make then 0 based
    //wrongPositionI -= 1
    //wrongPositionJ -= 1

    //let ziI = theZiManager.getZi(id: wrongPositionI)
    var valueI = getOneValueByIndexInLessons(currentCategory, currentType, wrongPositionI, false);
    var valueJ = getOneValueByIndexInLessons(currentCategory, currentType, wrongPositionJ, false);
    //let ziJ = theZiManager.getZi(id: wrongPositionJ)

    var nonCharIdI = 0;
    var nonCharIdJ = 0;
    if (currentType == QuizType.nonChars && currentCategory == QuizCategory.sound) {
      nonCharIdI = getIdByIndexInLessons(QuizCategory.sound, QuizType.nonChars, wrongPositionI);
      nonCharIdJ = getIdByIndexInLessons(QuizCategory.sound, QuizType.nonChars, wrongPositionJ);
    }

    var correctText = currentValues[0];
    if (isMeaning) {
      correctText = getOneValueByIndexInLesson(currentCategory, currentType, index, false);
    }

    if (correctPosition == 1) {
      currentValues[1] = correctText;

      //if (isMeaning) {
      currentValues[2] = valueI;
      currentValues[3] = valueJ;

      if (currentType == QuizType.nonChars && currentCategory == QuizCategory.sound) {
        setNonCharIds(nonCharId0, nonCharIdI, nonCharIdJ);
      }
    }
    else if (correctPosition == 2) {
      currentValues[2] = correctText;

      //if (isMeaning) {
      currentValues[1] = valueI;
      currentValues[3] = valueJ;

      if (currentType == QuizType.nonChars && currentCategory == QuizCategory.sound) {
        setNonCharIds(nonCharIdI, nonCharId0, nonCharIdJ);
      }
    }
    else if (correctPosition == 3) {
      currentValues[3] = correctText;

      //if (isMeaning) {
      currentValues[1] = valueI;
      currentValues[2] = valueJ;

      if (currentType == QuizType.nonChars && currentCategory == QuizCategory.sound) {
        setNonCharIds(nonCharIdI, nonCharIdJ, nonCharId0);
      }
    }

    return currentValues;
  }

  List<String> getCurrentValues() {
  return currentValues;
  }

  List<int> getCurrentValuesNonCharIds() {
    return currentValuesNonCharIds;
  }

  /*
  static bool isAMeaningQuizAnswer(String selectionName) {
    return (selectionName == theChoiceA || selectionName == theChoiceB ||
      selectionName == theChoiceC);
  }

  static bool isAPinyinQuizAnswer(String selectionName) {
    return (selectionName == thePinyinA ||
      selectionName == thePinyinB || selectionName == thePinyinC);
  }
*/

  static int getARandomNumber(int upperRange, int chosenNumber1, int chosenNumber2) {
    var chosen = true;
    var number = 0;

    Random rand = Random();

    while (chosen) {
      number = rand.nextInt(upperRange);
      if ( number != chosenNumber1 && number != chosenNumber2 ) {
        chosen = false;
      }
    }

    return number;
  }

  /*
  static double getQuizBoxTransX(bool isMeaning) {
    if (isMeaning) {
      return (theChoiceEdgeToTheLeft + theChoiceBoxWidth + theChoiceEdgeToTheLeft + thePinyinTextLength) + theGapBetweenPinyinAndMeaning;
    }
    else {
      return theChoiceEdgeToTheLeft;
    }
  }
  */
}
