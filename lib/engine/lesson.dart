import 'package:hanzishu/utility.dart';

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
  List<bool> sectionsCompleted = [false, false, false,false,false, false];
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
}