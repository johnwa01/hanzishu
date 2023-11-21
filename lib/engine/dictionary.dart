import 'package:hanzishu/data/firstzilist.dart';

enum DictionaryStage {
  firstzis,
  searchingzis,
  detailedzi,
  search,
  help,
  chineseHelp
}

enum DicCaller {
  Dictionary,
  Flashcard,
  WordsStudy
}

class FirstZi {
  String char;
  int searchingZiId;

  FirstZi(
      String char,
      int searchingZiId,
      ) {
    this.char = char;
    this.searchingZiId = searchingZiId;
  }
}

class SearchingZi {
  int id;
  String char;
  String pinyin;
  String meaning;
  int strokeCount;
  List<String> composit;
  String soundComponent;
  int soundLevel;
  String image;
  String hint;
  String displaySide;
  List<int> groupMembers;
  int parentId;
  int level;
  int levelHSK;
  String structure;

  SearchingZi(
      int id,
      String char,
      String pinyin,
      String meaning,
      int strokeCount,
      List<String> composit,
      String soundComponent,
      int soundLevel,
      String image,
      String hint,
      String displaySide,
      List<int> groupMembers,
      int parentId,
      int level,
      int levelHSK,
      String structure
    ) {
      this.id = id;
      this.char = char;
      this.pinyin = pinyin;
      this.meaning = meaning;
      this.strokeCount = strokeCount;
      this.composit = composit;
      this.soundComponent = soundComponent;
      this.soundLevel = soundLevel;
      this.image = image;
      this.hint = hint;
      this.displaySide = displaySide;
      this.groupMembers = groupMembers;
      this.parentId = parentId;
      this.level = level;
      this.levelHSK = levelHSK;
      this.structure = structure;
  }

  bool isSingleComponentZi() {
    if (composit.length == 1) {
      return true;
    }
    else {
      return false;
    }
  }
}

class Dictionary {
  // find the array index of a first zi in theFirstZiList
  static int getFirstZiIndexByPickingZiIndex(searchingZiIndex) {
    for (var i = theFirstZiList.length - 1; i >= 0; i--) {
      var oneFirstZi = theFirstZiList[i];
      if (oneFirstZi.searchingZiId < searchingZiIndex && oneFirstZi.char.length == 1) {
        return i;
      }
    }

    return -1;
  }
}

