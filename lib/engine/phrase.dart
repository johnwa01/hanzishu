import 'package:hanzishu/variables.dart';

class Phrase {
  int id = -1;
  String chars = '';
  String pinyin = '';
  String meaning = '';
  String hint = '';

  Phrase(int id,
    String chars,
    String pinyin,
    String meaning,
    String hint) {
      this.id = id;
      this.chars = chars;
      this.pinyin = pinyin;
      this.meaning = meaning;
      this.hint = hint;
  }

  String getPinyin() {
    if (pinyin.length != 0) {
      return pinyin;
    }
    else {
      String pinyin = "";
      chars.runes.forEach((int rune) {
        var char = new String.fromCharCode(rune);
        var zi = theZiManager.getZiByChar(char);
          pinyin += zi.pinyin;
      });
      return pinyin;
    }
  }

  String getPinyinAndMeaning() {
    String str = '[';
    str += getPinyin();
    str += '] ';
    str += meaning;

    return str;
  }
}