enum QuestionType {
  none,
  //TODO: remove all but two
  //ComponentGroup,
  //ComponentInGroup,
  Component,
  ExpandedComponent,
  ShowAttachedComponent,
  //ReviewExpandedComponent
}

enum AnswerType {
  GroupNumber,
  IndividualNumber,
  ContinueNext
}

enum AnswerPosition {
  none,
  //soundIcon,
  center,
  groupPosition1,
  groupPosition2,
  groupPosition3,
  groupPosition4,
  groupPosition5,
  groupPosition6,
  individual11,
  individual12,
  individual13,
  individual14,
  individual15,
  individual21,
  individual22,
  individual23,
  individual24,
  individual25,
  individual31,
  individual32,
  individual33,
  individual34,
  individual35,
  individual41,
  individual42,
  individual43,
  individual44,
  individual51,
  individual52,
  individual53,
  individual54,
  individual55,
  individual61,
  individual62,
  continueNext
}

class ComponentGroup {
  int id;
  String imageName;

  ComponentGroup(
      int id,
      String imageName)
  {
    this.id = id;
    this.imageName = imageName;
  }
}

class ComponentInGroup {
  int id;
  int groupNumber;
  int indexInGroup;

  ComponentInGroup(
    int id,
    int groupNumber,
    int indexInGroup)
  {
    this.id = id;
    this.groupNumber = groupNumber;
    this.indexInGroup = indexInGroup;
  }
}

class ComponentCollection {
  int id;
  String imageName;
  int groupNumber;
  int indexInGroup;
  int hint; // String ID

  ComponentCollection(
      int id,
      String imageName,
      int groupNumber,
      int indexInGroup,
      int hint)
  {
    this.id = id;
    this.imageName = imageName;
    this.groupNumber = groupNumber;
    this.indexInGroup = indexInGroup;
    this.hint = hint;
  }
}

class GroupAndIndexPair {
  int groupNumber;
  int indexInGroup;

  GroupAndIndexPair(int groupNumber, int indexInGroup) {
    this.groupNumber = groupNumber;
    this.indexInGroup = indexInGroup;
  }
}

/*
class FullComponentCollection {
  int id;
  String letter;
  String imageName;

  FullComponentCollection(
    int id,
    String letter,
    String imageName)
  {
      this.id = id;
      this.letter = letter;
      this.imageName = imageName;
  }
}
*/

class LeadComponent {
  int id;
  String doubleByteCode;
  String charOrNameOfNonchar;
  bool isChar;
  bool isLeadComponent;
  int groupNumber;
  int indexInGroup;
  String image;
  String strokesString;
  int hint;
  List<double> strokes;


  LeadComponent(
      int id,
    String doubleByteCode,
    String charOrNameOfNonchar,
    bool isChar,
    bool isLeadComponent,
    int groupNumber,
    int indexInGroup,
        String image,
        String strokesString,
      int hint,
      List<double> strokes)
  {
      this.id = id;
      this.doubleByteCode = doubleByteCode;
      this.charOrNameOfNonchar = charOrNameOfNonchar;
      this.isChar = isChar;
      this.isLeadComponent = isLeadComponent;
      this.groupNumber = groupNumber;
      this.indexInGroup = indexInGroup;
      this.image = image;
      this.strokesString = strokesString;
      this.hint = hint;
      this.strokes = strokes;
  }
}

class Component {
  String doubleByteCode;
  String charOrNameOfNonchar;
  String pinyin;
  String typingCode;
  bool isChar;
  String xiangXinImage;
  String strokesString;
  String meaning;
  String subComponents;
  List<double> strokes;

  Component(
      String doubleByteCode,
      String charOrNameOfNonchar,
      String pinyin,
      String typingCode,
      bool isChar,
      String xiangXinImag,
      String strokesString,
      String meaning,
      String subComponents,
      List<double> strokes)
  {
    this.doubleByteCode= doubleByteCode;
    this.charOrNameOfNonchar = charOrNameOfNonchar;
    this.pinyin = pinyin;
    this.typingCode = typingCode;
    this.isChar = isChar;
    this.xiangXinImage = xiangXinImage;
    this.strokesString = strokesString;
    this.meaning = meaning;
    this.subComponents = subComponents;
    this.strokes = strokes;
  }

  // three lines, from top to bottom, middle to side, left first.
  static List<String> ComponentPositionLetters =['T', 'R', 'E', 'W', 'Q', 'Y', 'U', 'I', 'O', 'P', 'G', 'F', 'D', 'S', 'A', 'H', 'J', 'K', 'L', '', 'B', 'V', 'C', 'X', 'Z', 'N', 'M', '', '', ''];

  static String getComponentCategoryFromGroupAndIndex(int keyGroup, int keyIndex) {
    if (keyGroup < 1 || keyGroup > 6 || keyIndex < 1 || keyIndex > 5) {
      return null;
    }

    var posi = (keyGroup -1) * 5 + keyIndex - 1;

    return ComponentPositionLetters[posi];
  }
}

class ZiWithComponentsAndStrokes {
  String zi;
  List<String> componentCodes;
  String hintImage;
  int hintText;

  ZiWithComponentsAndStrokes(
      String zi,
      List<String> componentCodes,
      String hintImage,
      int hintText
      ) {
    this.zi = zi;
    this.componentCodes = componentCodes;
    this.hintImage = hintImage;
    this.hintText = hintText;
  }
}

class ZiIdToCompMap {
  int id;
  String compCode;

  ZiIdToCompMap (
      int id,
      String compCode)
  {
    this.id = id;
    this.compCode = compCode;
  }
}

class ComponentCategoryStringIdAndTypingChars {
  int stringId;
  String letter;
  String chars;

  ComponentCategoryStringIdAndTypingChars(
      int stringId,
      String letter,
      String chars)
  {
    this.stringId = stringId;
    this.letter = letter;
    this.chars = chars;
  }
}

