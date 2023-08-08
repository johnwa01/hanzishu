import 'package:hanzishu/data/soundpaintlist.dart';

class SoundPaintManager {
  static final SoundPaintManager _soundPaintManager = SoundPaintManager._internal();
  factory SoundPaintManager() {
    return _soundPaintManager;
  }

  SoundPaintManager._internal();

  static int getXIndex(int group, int indexInGroup) {
    return (16 * (group - 1))+ indexInGroup;
  }

  static String getXChar(int group, int indexInGroup) {
    return theSoundPaintList[group -1][indexInGroup-1];
  }
}
