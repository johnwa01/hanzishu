import 'package:hanzishu/utility.dart';

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