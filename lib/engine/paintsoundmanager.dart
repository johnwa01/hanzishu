import 'package:hanzishu/data/paintsoundlist.dart';

enum SoundCategory {
  hanzishuLessons,
  intro,
  erGe,
  tongYao,
  tongHua
}


class PaintSoundManager {
  static final PaintSoundManager _soundPaintManager = PaintSoundManager._internal();
  factory PaintSoundManager() {
    return _soundPaintManager;
  }

  PaintSoundManager._internal();

  static int getXIndex(int group, int indexInGroup) {
    return (16 * (group - 1))+ indexInGroup;
  }

  static String getXChar(int group, int indexInGroup) {
    return theSoundPaintList[group -1][indexInGroup-1];
  }

  static getTongHuaPageCount(int pageNumber) {
    return theTongHuaPageCount[pageNumber -1];
  }
}
