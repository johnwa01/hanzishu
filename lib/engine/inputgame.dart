import 'package:hanzishu/engine/inputgamequestion.dart';

class InputGame {
  int id = -1;
  int gameType = -1;
  String EnglishName = "";
  String ChineseName = "";
  List<int> inputGameQuestionIdList = [];

  InputGame(
      int id,
      int gameType, // 1: pictographic
      String EnglishName,
      String ChineseName,
      List<int> inputGameQuestionIdList,
      )
  {
    this.id = id;
    this.gameType = gameType;
    this.EnglishName = EnglishName;
    this.ChineseName = ChineseName;
    this.inputGameQuestionIdList = inputGameQuestionIdList;
  }
}