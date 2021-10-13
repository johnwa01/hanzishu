import 'package:hanzishu/utility.dart';

enum TypingType {
  ThreeOrMoreComponents,
  TwoComponents,
  OneComponent,
  FreeTyping
}

class InputZi {
  String doubleByteCode;
  int usageFrequency;
  String zi;
  String pinyin;


  InputZi(
      String doubleByteCode,
      int usageFrequency,
      String zi,
      String pinyin,
      ) {
    this.doubleByteCode = doubleByteCode;
    this.usageFrequency = usageFrequency;
    this.zi = zi;
    this.pinyin = pinyin;
  }
}

class ZiWithComponentsAndStrokes {
  String zi;
  List<String> componentCodes;
  String comment;

  ZiWithComponentsAndStrokes(
      String zi,
      List<String> componentCodes,
      String comment
      ) {
    this.zi = zi;
    this.componentCodes = componentCodes;
    this.comment = comment;
  }
}