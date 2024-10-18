// Note: This is replaced by SearchingZi
class Zi {
  int id = -1;
  String char = '';
  String pinyin = '';
  String meaning = '';
  bool isSingleBody = false;
  List<double> strokes = <double>[];
  List<String> bodyComposites = <String>[];
  String displaySide = '';   // Character
  List<int> groupMembers = <int>[];
  int parentId = -1;
  int level = -1;
  //CGPoint transform,
  String origin = '';
  int lesson = -1;
  String type = '';
  int soundHintId = -1;
  bool hasFinishedQuiz = false;   //TODO: this is a valid field

  Zi(
    int id,
    String char,
    String pinyin,
    String meaning,
    bool isSingleBody,  // this field is no longer used. the data isn't accurate any more.
    List<double> strokes,
    List<String> bodyComposites,
    String displaySide,
    List<int> groupMembers,
    int parentId,
    int level,
    String origin,
    int lesson,
    String type,
    int soundHintId
    /*bool hasFinishedQuiz*/) {
      this.id = id;
      this.char = char;
      this.pinyin = pinyin;
      this.meaning = meaning;
      this.isSingleBody = isSingleBody;
      this.strokes = strokes;
      this.bodyComposites = bodyComposites;
      this.displaySide = displaySide;
      this.groupMembers = groupMembers;
      this.parentId = parentId;
      this.level = level;
      //this.transform = CGPoint(x: -1.0, y: -1.0);
      this.origin = origin;
      this.lesson = lesson;
      this.type = type;
      this.soundHintId = soundHintId;
      //this.hasFinishedQuiz = hasFinishedQuiz;
  }

  bool isNonChar() {
    return type.contains('b');
  }

  bool isStrokeOrNonChar() {
    return type.contains('b') || type.contains('s');
  }

  String getPinyinAndMeaning() {
    return formatPinyinAndMeaning(pinyin, meaning);
  }

  bool isBasicZi() {
    return type.contains('b') || type.contains('j');
  }

  static String formatPinyinAndMeaning(String? pinyin, String? meaning) {

      String str = '[';
      if (pinyin != null) {
        str += pinyin;
      }
      str += '] ';
      if (meaning != null) {
        str += meaning;
      }

    return str;
  }
}
//var x = Zi(99324,"x","y","z", false, [0.1], ["z"],"u", [3],0,0,"",0,"f", 0);
//  Zi(3,"三","sān","three", false, [], ["170","170","170"],"u", [131,259,459],2,0,"pictograph of three fingers",0,"j", 0),