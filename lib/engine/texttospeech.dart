import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  static speak(String lang, String str) async {
    FlutterTts flutterTts = FlutterTts();
    flutterTts.setLanguage(lang); //"zh-CN"
    flutterTts.speak(str/*'你好''Hello World'*/);
  }
}