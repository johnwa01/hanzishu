
enum TypingType {
  GiveItATry,
  LeadComponents,
  ExpandedComponents,
  CustomizedTyping,
  FromLessons,
  FreeTyping,
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

/*
class InputZiOverlayParameters {
    TypingType type;
    int index;
    bool isFullComponents;
    String fullComponentsLetter;
    bool justDismissed;

    InputZiOverlayParameters(
      TypingType type,
      int index,
      bool isFullComponents,
      String fullComponentsLetter,
        bool justDismissed
      ) {
      this.type = type;
      this.index = index;
      this.isFullComponents = isFullComponents;
      this.fullComponentsLetter = fullComponentsLetter;
      this.justDismissed = justDismissed;
    }

    assign(
        InputZiOverlayParameters paras
        ) {
      this.type = paras.type;
      this.index = paras.index;
      this.isFullComponents = paras.isFullComponents;
      this.fullComponentsLetter = paras.fullComponentsLetter;
      this.justDismissed = paras.justDismissed;
    }

    init() {
      type = TypingType.FreeTyping;
      index = 0;
      isFullComponents = false;
      fullComponentsLetter = '';
      justDismissed = false;
    }

    bool isEqual(InputZiOverlayParameters para) {
      return type == para.type &&
            index == para.index &&
            isFullComponents == para.isFullComponents &&
            fullComponentsLetter == para.fullComponentsLetter &&
            justDismissed == para.justDismissed;
    }
}
*/