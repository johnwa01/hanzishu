import 'package:hanzishu/utility.dart';

class Sentence {
  int id;
  String conv;
  String trans;
  int lessonId;
  MyString chars;
  List<int> comps; //TODO: this field is required?

  Sentence(
    int id,
    String conv,
    String trans,
    int lessonId,
    MyString chars,
    List<int> comps
  ) {
  this.id = id;
  this.conv = conv;
  this.trans = trans;
  this.lessonId = lessonId;
  this.chars = chars;
  this.comps = comps;
  }
}