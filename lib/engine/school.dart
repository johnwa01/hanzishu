class School {
  int id = -1;
  String code = "";
  String EnglishName = "";
  String ChineseName = "";
  int countryId = -1;

  School(
      int id,
      String code,
      String EnglishName,
      String ChineseName,
      int countryId)
  {
    this.id = id;
    this.code = code;
    this.EnglishName = EnglishName;
    this.ChineseName = ChineseName;
    this.countryId = countryId;
  }
}