import 'package:hanzishu/variables.dart';

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

  Pinyin(int id,
      String name,
      Sample sample,
      List<Sample> samples) {
    this.id = id;
    this.name = name;
    this.sample = sample;
    this.samples = samples;
  }
}