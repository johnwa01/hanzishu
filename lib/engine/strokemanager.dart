import 'package:hanzishu/data/strokelist.dart';
import 'package:hanzishu/engine/stroke.dart';

class StrokeManager {

  Stroke getStrokeByCode(String code) {
    for (var i = 0; i < theStrokeList.length; i++) {
      if (theStrokeList[i].code == code) {
        return theStrokeList[i];
      }
    }
    return null;
  }
}