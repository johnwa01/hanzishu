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
  int strokeCount;
  List<String> composit;
  String soundComponent;
  int soundLevel;
  String image;
  String hint;

  SearchingZi(
      String char,
      int id,
      String pinyin,
      String meaning,
      int strokeCount,
      List<String> composit,
      String soundComponent,
      int soundLevel,
      String image,
      String hint
    ) {
      this.char = char;
      this.id = id;
      this.pinyin = pinyin;
      this.meaning = meaning;
      this.strokeCount = strokeCount;
      this.composit = composit;
      this.soundComponent = soundComponent;
      this.soundLevel = soundLevel;
      this.image = image;
      this.hint = hint;

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