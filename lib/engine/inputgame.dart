import 'package:hanzishu/engine/inputgamequestion.dart';

enum InputGameState {
  login,
  gameType,
  inputGameHelper,
  answerSheet,
  game
}

class InputGame {
  int id = -1;
  int gameType = -1;
  String EnglishName = "";
  String ChineseName = "";
  List<int> inputGameQuestionIdList = [];
  String answerSheetUrl = "";

  InputGame(
      int id,
      int gameType, // 1: pictographic
      String EnglishName,
      String ChineseName,
      List<int> inputGameQuestionIdList,
      String answerSheetUrl,
      )
  {
    this.id = id;
    this.gameType = gameType;
    this.EnglishName = EnglishName;
    this.ChineseName = ChineseName;
    this.inputGameQuestionIdList = inputGameQuestionIdList;
    this.answerSheetUrl = answerSheetUrl;
  }
}