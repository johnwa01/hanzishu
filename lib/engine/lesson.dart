import 'package:hanzishu/utility.dart';
import 'package:hanzishu/variables.dart';
import 'package:hanzishu/data/lessonlist.dart';
import 'package:hanzishu/engine/generalmanager.dart';

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
    if (GeneralManager.hasZiCompleted(ziId, hittestState, theCurrentLesson)) {
      return true;
    }

    var zi = theZiManager.getZi(id: ziId);
    var groupMembers = zi.groupMembers;

    var showZi = true;
    for (var memberZiId in groupMembers) {
      showZi = true;
      // Note: the id here is the member variable id of lesson
      showZi = theZiManager.showZiForLesson(ziId: memberZiId, lessonId: id);

      if (showZi == true) {
        if (!GeneralManager.hasZiCompleted(memberZiId, hittestState, theCurrentLesson)) {
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
    var lessonId = theLessonManager.getLessonNumber(name: theLessonManager.theCurrentLesson);
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
}