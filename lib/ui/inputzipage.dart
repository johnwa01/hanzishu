import 'package:flutter/material.dart';
import 'package:hanzishu/ui/shared/inputziwidget.dart';
import 'package:hanzishu/engine/inputzi.dart';

class InputZiPage extends StatelessWidget {
  final TypingType typingType;
  final int lessonId;
  final String wordsStudy;
  final bool isSoundPrompt;
  final InputMethod inputMethod;
  final HintType showHint;
  final bool includeSkipSection;
  final bool showSwitchMethod;

  const InputZiPage({
    required this.typingType,
    required this.lessonId,
    required this.wordsStudy,
    required this.isSoundPrompt,
    required this.inputMethod,
    required this.showHint,
    required this.includeSkipSection,
    required this.showSwitchMethod,
  });

  @override
  Widget build(BuildContext context) {
    return InputZiWidget(
      typingType: typingType,
      lessonId: lessonId,
      wordsStudy: wordsStudy,
      isSoundPrompt: isSoundPrompt,
      inputMethod: inputMethod,
      showHint: showHint,
      includeSkipSection: includeSkipSection,
      showSwitchMethod: showSwitchMethod,
    );
  }
}
