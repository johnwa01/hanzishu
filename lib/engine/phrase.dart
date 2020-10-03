class Phrase {
  int id;
  String chars;
  String pinyin;
  String meaning;
  String hint;

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
}