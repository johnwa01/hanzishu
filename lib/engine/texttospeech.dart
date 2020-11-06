import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  static speak() async {
    FlutterTts flutterTts = FlutterTts();
    flutterTts.speak('你好'/*'Hello World'*/);
  }
}