import 'package:hanzishu/data/firstzilist.dart';
import 'package:hanzishu/utility.dart';

enum DictionaryStage {
  firstzis,
  searchingzis,
  detailedzi,
  search,
  help,
  chineseHelp
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
      String hint
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

class PositionAndMeaning {
  double x;
  double y;
  String meaning;

  PositionAndMeaning(
      double x,
      double y,
      String meaning) {
    this.x = x;
    this.y = y;
    this.meaning = meaning;
  }
}