import 'package:hanzishu/variables.dart';

enum PinyinType {
  None,
  OnlyFirst,
  OnlyNewZi,
  Full,
}

class Sample {
  String pinyin;
  String zi;

  Sample(String pinyin, String zi) {
    this.pinyin = pinyin;
    this.zi = zi;
  }
}

class Pinyin {
  int id;
  String name;
  Sample sample;
  List<Sample> samples;
  int showZiOrNot; // 1-show, 0-not show

  Pinyin(int id,
      String name,
      Sample sample,
      List<Sample> samples,
      int showZiOrNot) {
    this.id = id;
    this.name = name;
    this.sample = sample;
    this.samples = samples;
    this.showZiOrNot = showZiOrNot;
  }
}