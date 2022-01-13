
class Stroke {
  String code;
  String name;
  String typingCode;
  List<double> routes;

  Stroke(String code,
      String name,
      String typingCode,
      List<double> routes)
  {
    this.code = code;
    this.name = name;
    this.typingCode = typingCode;
    this.routes = routes;
  }
}
