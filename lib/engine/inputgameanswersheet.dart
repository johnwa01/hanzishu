

class InputGameAnswerSheet {
  int id = -1;
  String url = "";
  String note = "";

  InputGameAnswerSheet(
      int id,
      String url,
      String note,
      )
  {
    this.id = id;
    this.url = url;
    this.note = note;
  }
}

class SchoolCodeToAnswerSheet {
  String schoolCode = "";
  int answerSheetId = -1;

  SchoolCodeToAnswerSheet(
      String schoolCode,
      int answerSheetId,
      )
  {
    this.schoolCode = schoolCode;
    this.answerSheetId = answerSheetId;
  }
}