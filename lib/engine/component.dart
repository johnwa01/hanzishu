enum QuestionType {
  none,
  ComponentGroup,
  ComponentInGroup,
  Component,
  ExpandedComponent
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
  String hint;

  ComponentCollection(
      int id,
      String imageName,
      int groupNumber,
      int indexInGroup,
      String hint)
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
      this.strokes = strokes;
  }
}

class Component {
  String doubleByteCode;
  String charOrNameOfNonchar;
  String typingCode;
  bool isChar;
  String xiangXinImage;
  String strokesString;
  List<double> strokes;

  Component(
      String doubleByteCode,
      String charOrNameOfNonchar,
      String typingCode,
      bool isChar,
      String xiangXinImag,
      String strokesString,
      List<double> strokes)
  {
    this.doubleByteCode= doubleByteCode;
    this.charOrNameOfNonchar = charOrNameOfNonchar;
    this.typingCode = typingCode;
    this.isChar = isChar;
    this.xiangXinImage = xiangXinImage;
    this.strokesString = strokesString;
    this.strokes = strokes;
  }
}

class ZiWithComponentsAndStrokes {
  String zi;
  List<String> componentCodes;
  String hintImage;
  String hintText;

  ZiWithComponentsAndStrokes(
      String zi,
      List<String> componentCodes,
      String hintImage,
      String hintText
      ) {
    this.zi = zi;
    this.componentCodes = componentCodes;
    this.hintImage = hintImage;
    this.hintText = hintText;
  }
}

