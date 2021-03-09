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