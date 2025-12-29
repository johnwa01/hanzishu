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
  ComponentCombinationTyping,
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
  TingDa,
  None,
}

class InputZi {
  String doubleByteCode = '';
  String zi = '';

  //int usageFrequency = -1;
 // String pinyin;

  InputZi(
      String doubleByteCode,
      String zi,
   //   int usageFrequency,
   //   String pinyin,
      ) {

    this.doubleByteCode = doubleByteCode;
    this.zi = zi;

    //this.usageFrequency = usageFrequency;
   // this.pinyin = pinyin;
  }
}

class PinyinInputZi {
  String pinyin = '';
  String zi = '';

  //int usageFrequency = -1;
  //String typingCode = '';

  PinyinInputZi(
      String pinyin,
      String zi,

      //int usageFrequency,
      //String typingCode,
      ) {

    this.pinyin = pinyin;
    this.zi = zi;
    //this.usageFrequency = usageFrequency;
    //this.typingCode = typingCode;
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