class LessonUnit {
  int id;
  int numberOfLessons;
  bool isCompleted;
  String description;

  LessonUnit(int id,
      int numberOfLessons,
      bool isCompleted,
      String description) {
    this.id = id;
    this.numberOfLessons = numberOfLessons;
    this.isCompleted = isCompleted;
    this.description = description;
  }
}