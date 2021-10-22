import 'package:hanzishu/data/firstzilist.dart';
import 'package:hanzishu/utility.dart';

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
  String char;
  int id;
  String pinyin;
  String meaning;
  int fullZiId;
  int strokeCount;

  SearchingZi(
      String char,
      int id,
      String pinyin,
      String meaning,
      int fullZiId,
      int strokeCount,
    ) {
      this.char = char;
      this.id = id;
      this.pinyin = pinyin;
      this.meaning = meaning;
      this.fullZiId = fullZiId;
      this.strokeCount = strokeCount;
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