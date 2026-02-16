class Country {
  int id = -1;
  String EnglishName = "";
  String ChineseName = "";
  int continentId = -1;

  Country(
      int id,
      String EnglishName,
      String ChineseName,
      int continentId)
  {
    this.id = id;
    this.EnglishName = EnglishName;
    this.ChineseName = ChineseName;
    this.continentId = continentId;
  }
}

class Continent {
  int id = -1;
  String EnglishName = "";
  String ChineseName = "";

  Continent(
      int id,
      String EnglishName,
      String ChineseName,
      )
  {
    this.id = id;
    this.EnglishName = EnglishName;
    this.ChineseName = ChineseName;
  }
}