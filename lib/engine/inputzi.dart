
enum TypingType {
  none,
  //GiveItATry,
  LeadComponents,
  //ExpandedInitial,
  ExpandedReview,
  ExpandedGeneral,
  //ExpandedExercise,
  AttachedComponents,
  TwinComponents,
  SubComponents,
  SingleComponent,
  TwoComponents,
  GeneralExercise,
  CommonZiTyping,
  FromLessons,
  FreeTyping,
  Custom,
  ComponentTyping,
  DicSearchTyping,
  FirstTyping,
  ThirdParty,
}

enum InputMethod {
  Pinxin,
  Others,
  Both,
}

enum HintType {
  Hint0,
  Hint1,
  Hint2,
  Hint3,
  Game,
  None,
}

class InputZi {
  String zi = '';
  String doubleByteCode = '';
  int usageFrequency = -1;
 // String pinyin;


  InputZi(
      String zi,
      String doubleByteCode,
      int usageFrequency,
   //   String pinyin,
      ) {
    this.zi = zi;
    this.doubleByteCode = doubleByteCode;
    this.usageFrequency = usageFrequency;
   // this.pinyin = pinyin;
  }
}

class PinyinInputZi {
  String zi = '';
  String pinyin = '';
  int usageFrequency = -1;
  String typingCode = '';

  PinyinInputZi(
      String zi,
      String pinyin,
      int usageFrequency,
      String typingCode,
      ) {
    this.zi = zi;
    this.pinyin = pinyin;
    this.usageFrequency = usageFrequency;
    this.typingCode = typingCode;
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