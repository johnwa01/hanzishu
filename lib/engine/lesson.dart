import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/engine/generalmanager.dart';
import 'package:hanzishu/data/zilist.dart';
import 'package:hanzishu/data/phraselist.dart';
import 'package:hanzishu/ui/positionmanager.dart';

class Lesson {
  int id;
  String title;
  String titleTranslation;
  List<int> sentenceList;
  String convChars;
  List<int> convCharsIds;
  String chars;
  List<int> charsIds;
  List<int> comps;
  String topicTitle;
  List<int> topicParagraphList;
  List<int> phraseIds;
  bool newItemListCreated = false;
  List<int> newItemList = [];
  List<int> newItemTypeStartPosition = [0, 0, 0, 0];

  Map<int, bool> componentLearnedDictLesson = Map();
  Map<int, bool> fullCharLearnedDictLesson = Map();
  Map<int, bool> quizLearnedDictLesson = Map();
  Map<int, bool> componentLearnedDictReview = Map();
  Map<int, bool> fullCharLearnedDictReview = Map();
  Map<int, bool> quizLearnedDictReview = Map();
  List<bool> sectionsCompleted = [false, false, false,false,false, false, false];
  bool lessonCompleted = false;
  LessonSection latestSection = LessonSection.FullCharacterTree;
  int numberOfNewChars = 0;
  int numberOfNewAnalysisChars = 0;
  int numberOfQuizQuestions = 0;
  bool treeMapCreated = false;
  Map<int, List<int>> treeMap = Map();
  Map<int, PositionAndSize> sidePositions = Map();
  Map<int, List<int>> realGroupMembersMap  = Map();
  PositionAndSize centerPositionAndSize = null;

  Lesson(
      int id,
      String title,
      String titleTranslation,
      List<int> sentenceList,
      String convChars,
      List<int> convCharsIds,
      String chars,
      List<int> charsIds,
      List<int> comps,
      String topicTitle,
      List<int> topicParagraphList,
      List<int> phraseIds) {
    this.id = id;
    this.title = title;
    this.titleTranslation = titleTranslation;
    this.sentenceList = sentenceList;
    this.convChars = convChars;
    this.convCharsIds = convCharsIds;
    this.chars = chars;
    this.charsIds = charsIds;
    this.comps = comps;
    this.topicTitle = topicTitle;
    this.topicParagraphList = topicParagraphList;
    this.phraseIds = phraseIds;
  }

  // including non-chars and phrases
  int getNumberOfNewChars() {
    if (numberOfNewChars > 0) {
      return numberOfNewChars;
    }

    numberOfNewChars = comps.length + charsIds.length + convCharsIds.length + phraseIds.length;

    return numberOfNewChars;
  }

  int getNumberOfNewAnalysisChars() {
    if (numberOfNewAnalysisChars > 0) {
      return numberOfNewAnalysisChars;
    }

    if (convChars.length > 0) {
      for (var i = 0; i <= convCharsIds.length - 1; i++) {
        var ziId = convCharsIds[i];
        var zi = theZiManager.getZi(id: ziId);
        if (zi != null && zi.type == "h") {
          numberOfNewAnalysisChars += 1;
        }
      }
    }

    return numberOfNewAnalysisChars;
  }

  int getNumberOfQuizQuestions() {
    if (numberOfQuizQuestions > 0) {
      return numberOfQuizQuestions;
    }

    numberOfQuizQuestions = comps.length + charsIds.length + convCharsIds.length + phraseIds.length + sentenceList.length;
    numberOfQuizQuestions *= 2;

    if (comps.length > 0) {
      for (var i = 0; i <= (comps.length - 1); i++) {
        var zi = theZiManager.getZi(id: comps[i]);
        if (zi.meaning == "no meaning by itself" || zi.meaning == "no meaning") {
          numberOfQuizQuestions -= 1;
        }
      }
    }

    return numberOfQuizQuestions;
  }

  LessonSection getLatestSection() {
    return this.latestSection;
  }

  void setLatestSection(LessonSection latestSection) {
    this.latestSection = latestSection;
  }

  bool hasZiCompleted(int ziId, HittestState hittestState) {
    //lesson mode
    if (hittestState == HittestState.ziAndSidingShuLesson) {
      if (componentLearnedDictLesson[ziId] == true) {
        return true;
      }
    }
    else if (hittestState == HittestState.hanzishuLesson) {
      if (fullCharLearnedDictLesson[ziId] == true) {
        return true;
      }
    }
    else if (hittestState == HittestState.quizShuLesson) {
      if (quizLearnedDictLesson[ziId] == true) {
        return true;
      }
    }

    //review mode
    if (hittestState == HittestState.hanzishuZiAndSidingMode) {
      if (componentLearnedDictReview[ziId] == true) {
        return true;
      }
    }
    else if (hittestState == HittestState.hanzishuFullZiMode) {
      if (fullCharLearnedDictReview[ziId] == true) {
        return true;
      }
    }
    else if (hittestState == HittestState.hanzishuQuizMode) {
      if (quizLearnedDictReview[ziId] == true) {
        return true;
      }
    }

    return false;
  }

  void setZiCompleted(int ziId, HittestState hittestState) {
    // lesson mode
    if (hittestState == HittestState.ziAndSidingShuLesson) {
    componentLearnedDictLesson[ziId] = true;
    }
    else if (hittestState == HittestState.hanzishuLesson) {
      fullCharLearnedDictLesson[ziId] = true;
    }
    else if (hittestState == HittestState.quizShuLesson) {
      quizLearnedDictLesson[ziId] = true;
    }

    // review mode
    if (hittestState == HittestState.hanzishuZiAndSidingMode) {
      componentLearnedDictReview[ziId] = true;
    }
    else if (hittestState == HittestState.hanzishuFullZiMode) {
      fullCharLearnedDictReview[ziId] = true;
    }
    else if (hittestState == HittestState.hanzishuQuizMode) {
      quizLearnedDictReview[ziId] = true;
    }
  }

  // check whether a zi's children are all completed - for one lesson only
  bool checkAndSetHasAllChildrenCompleted(int ziId, HittestState hittestState) {
    if (GeneralManager.hasZiCompleted(ziId, hittestState, theCurrentLessonId)) {
      return true;
    }

    var zi = theZiManager.getZi(ziId);
    var groupMembers = zi.groupMembers;

    var showZi = true;
    for (var memberZiId in groupMembers) {
      showZi = true;
      // Note: the id here is the member variable id of lesson
      showZi = theZiManager.showZiForLessonId(memberZiId, id);

      if (showZi == true) {
        if (!GeneralManager.hasZiCompleted(memberZiId, hittestState, theCurrentLessonId)) {
          return false;
        }
      }
    }

    return true;
  }

  void SetSectionCompleted(LessonSection lessonSection) {
    if (sectionsCompleted[lessonSection.index] == false) {
      sectionsCompleted[lessonSection.index] = true;

      setLatestSectionToNext(lessonSection );
    }
  }

  void setLatestSectionToNext(LessonSection lessonSection) {
    var lessonId = theLessonManager.getLessonNumber(theLessonManager.theCurrentLesson);
    var lesson = theLessonList[lessonId];
    switch (lessonSection) {
      case LessonSection.FullCharacterTree:
        if (this.latestSection.index <= LessonSection.FullCharacterTree.index) {
          lesson.setLatestSection(LessonSection.Characters);
        }
        break;
      case LessonSection.Characters:
        if (this.latestSection.index <= LessonSection.Characters.index) {
          lesson.setLatestSection(LessonSection.Decomposing);
        }
        break;
      case LessonSection.Decomposing:
        if (this.latestSection.index <= LessonSection.Decomposing.index) {
          lesson.setLatestSection(LessonSection.Conversation);
        }
        break;
      case LessonSection.Assembling:
        if (this.latestSection.index <= LessonSection.Conversation.index) {
          lesson.setLatestSection(LessonSection.Conversation);
        }
        break;
      case LessonSection.Conversation:
        if (this.latestSection.index <= LessonSection.Conversation.index) {
          lesson.setLatestSection(LessonSection.Quiz);
        }
        break;
      case LessonSection.Quiz:
        if (this.latestSection.index <= LessonSection.Quiz.index) {
          lesson.setLatestSection(LessonSection.None);
        }
        break;
      case LessonSection.None:
        lesson.setLatestSection(LessonSection.FullCharacterTree);
        break;
    }
  }

  bool hasSectionCompleted(LessonSection lessonSection) {
    return sectionsCompleted[lessonSection.index];
  }

  bool hasAllSectionsCompleted() {
    for (var section in sectionsCompleted) {
      if (section == false) {
        return false;
      }
    }

    return true;
  }

  bool hasLessonCompleted() {
    return lessonCompleted;
  }

  void setLessonCompleted() {
    if (!lessonCompleted) {
      lessonCompleted = true;
      theLessonManager.theLatestEnabledLesson += 1;
    }
  }

  void populateOneGroupOfChars(List<int> charIds, String type) {
    for (int charId in charIds) {
      var zi = theZiManager.getZi(charId);
      if (theZiManager.containSameSubType(zi.type, type)) {
        newItemList.add(charId);
      }
    }
  }

  void populateNonchars(List<int> noncharIds) {
    for (int charId in noncharIds) {
        newItemList.add(charId);
    }
  }

  void populatePhrases(List<int> phraseIds) {
    for (int phraseId in phraseIds) {
      newItemList.add(phraseId);
    }
  }

  // basic chars, basic nonchars, chars and phrases
  void populateNewItemList() {
    if (!newItemListCreated) {
      newItemList.add(0); // seed the first to meet ListView.separated requirement
      newItemTypeStartPosition[0] = newItemList.length - 1;
      // basic chars
      populateOneGroupOfChars(charsIds, CharType.BasicChar);
      populateOneGroupOfChars(convCharsIds, CharType.BasicChar);
      newItemTypeStartPosition[1] = newItemList.length - 1;

      // basic non-chars
      populateNonchars(comps);
      newItemTypeStartPosition[2] = newItemList.length - 1;

      // chars
      populateOneGroupOfChars(charsIds, CharType.CompositChar);
      populateOneGroupOfChars(convCharsIds, CharType.CompositChar);
      newItemTypeStartPosition[3] = newItemList.length - 1;

      // phrases
      populatePhrases(phraseIds);

      newItemListCreated = true;
    }
  }

  String getItemChar(int index) {
    if (index <= newItemTypeStartPosition[3]) {
      return theZiList[newItemList[index]].char;
    }
    else {
      return thePhraseList[newItemList[index]].chars;
    }
  }

  String getItemPinyin(int index) {
    if (index <= newItemTypeStartPosition[3]) {
      return theZiList[newItemList[index]].pinyin;
    }
    else {
      return thePhraseList[newItemList[index]].pinyin;
    }
  }

  String getItemMeaning(int index) {
    if (index <= newItemTypeStartPosition[3]) {
      return theZiList[newItemList[index]].meaning;
    }
    else {
      return thePhraseList[newItemList[index]].meaning;
    }
  }

  String getItemString(int index) {
    String str = "";
    if (index == 0) {
      return " ";
    }
    else if (index <= newItemTypeStartPosition[3]) {
      var zi = theZiList[newItemList[index]];
      str += zi.char;
      str += "  [";
      str += zi.pinyin;
      str += "] ";
      str += zi.meaning;
    }
    else {
      var phrase = thePhraseList[newItemList[index]];
      str += phrase.chars;
      str += "  [";
      str += phrase.pinyin;
      str += "] ";
      str += phrase.meaning;
    }

    return str;
  }

  void initCache() {
    centerPositionAndSize = null;
    realGroupMembersMap.clear();
    sidePositions.clear();
  }

  PositionAndSize getCenterPosisionAndSize() {
    return centerPositionAndSize;
  }

  void setCenterPositionAndSize(positionAndSize) {
    centerPositionAndSize = positionAndSize;
  }

  PositionAndSize getPositionAndSize(int ziId) {
    return sidePositions[ziId];
  }

  void addToSidePositions(int ziId, PositionAndSize positionAndSize) {
    sidePositions[ziId] = positionAndSize;
  }

  List<int> getRealGroupMembers(int centerZiId) {
    return realGroupMembersMap[centerZiId];
  }

  void addToRealGroupMembersMap(int centerZiId, List<int> realGroupMembers) {
    realGroupMembersMap[centerZiId] = realGroupMembers;
  }

  void addToTreeMap(int ziId, List<int> lessonGroupMembers) {
    treeMap[ziId] = lessonGroupMembers;
  }

  void populateTreeMap(int ziId) {
    if (treeMapCreated) {
      return;
    }

    var lessonGroupMembers = theZiManager.getRealGroupMembers(ziId);

    if (lessonGroupMembers.length > 0) {
      for (int ziMember in lessonGroupMembers) {
        populateTreeMap(ziMember);
      }

      addToTreeMap(ziId, lessonGroupMembers);
    }

    treeMapCreated = true;
  }
}