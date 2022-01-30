

class Level {
  int id;
  int numberOfLessons;
  bool isCompleted;
  String description;

  Level(int id,
    int numberOfLessons,
    bool isCompleted,
      String description) {
    this.id = id;
    this.numberOfLessons = numberOfLessons;
    this.isCompleted = isCompleted;
    this.description = description;
  }
}