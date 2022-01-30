import 'package:hanzishu/utility.dart';

enum TypingType {
  ForIntroduction,
  LeadComponents,
  ExpandedComponents,
  FromLessons,
  FreeTyping
}

class InputZi {
  String doubleByteCode;
  int usageFrequency;
  String zi;
 // String pinyin;


  InputZi(
      String doubleByteCode,
      int usageFrequency,
      String zi,
   //   String pinyin,
      ) {
    this.doubleByteCode = doubleByteCode;
    this.usageFrequency = usageFrequency;
    this.zi = zi;
   // this.pinyin = pinyin;
  }
}

class InputZiOverlayParameters {
    TypingType type;
    int index;
    bool isFullComponents;
    String fullComponentsLetter;

    InputZiOverlayParameters(
      TypingType type,
      int index,
      bool isFullComponents,
      String fullComponentsLetter
      ) {
      this.type = type;
      this.index = index;
      this.isFullComponents = isFullComponents;
      this.fullComponentsLetter = fullComponentsLetter;
    }

    assign(
        InputZiOverlayParameters paras
        ) {
      this.type = paras.type;
      this.index = paras.index;
      this.isFullComponents = paras.isFullComponents;
      this.fullComponentsLetter = paras.fullComponentsLetter;
    }

    init() {
      type = TypingType.FreeTyping;
      index = 0;
      isFullComponents = false;
      fullComponentsLetter = '';
    }

    bool isEqual(InputZiOverlayParameters para) {
      return type == para.type &&
            index == para.index &&
            isFullComponents == para.isFullComponents &&
            fullComponentsLetter == para.fullComponentsLetter;
    }
}