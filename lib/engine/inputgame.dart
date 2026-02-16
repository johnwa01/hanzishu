import 'package:hanzishu/engine/inputgamequestion.dart';

class InputGame {
  int id = -1;
  String EnglishName = "";
  String ChineseName = "";
  List<int> inputGameQuestionIdList = [];

  InputGame(
      int id,
      String EnglishName,
      String ChineseName,
      List<int> inputGameQuestionIdList,
      )
  {
    this.id = id;
    this.EnglishName = EnglishName;
    this.ChineseName = ChineseName;
    this.inputGameQuestionIdList = inputGameQuestionIdList;
  }
}