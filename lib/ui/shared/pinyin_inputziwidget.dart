import 'package:flutter/material.dart';
import 'package:hanzishu/engine/inputzi.dart';

class PinyinInputZiWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final double ratio;
  final TypingType typingType;
  final InputMethod inputMethod;
  final bool withQueryButton;
  final bool useDictionarySearchStyle;
  final Color? teal;
  final VoidCallback? onQueryPressed;
  final ValueChanged<String>? onSubmitted;

  const PinyinInputZiWidget({
    required this.controller,
    required this.focusNode,
    required this.ratio,
    required this.typingType,
    required this.inputMethod,
    this.withQueryButton = false,
    this.useDictionarySearchStyle = false,
    this.teal,
    this.onQueryPressed,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    if (useDictionarySearchStyle) {
      return _buildDictionarySearchTextField();
    }

    return _buildRegularTextField();
  }

  Widget _buildDictionarySearchTextField() {
    final activeTeal = teal ?? const Color(0xFF00897B);

    return TextField(
      autocorrect: false,
      enableSuggestions: false,
      controller: controller,
      focusNode: focusNode,
      autofocus: false,
      cursorColor: activeTeal,
      decoration: InputDecoration(
        hintText: "Enter Pinyin or other input...",
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14 * ratio,
          vertical: 12 * ratio,
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.search_rounded, color: activeTeal),
          onPressed: onQueryPressed,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * ratio),
          borderSide: BorderSide(
            color: activeTeal.withOpacity(0.75),
            width: 1.2 * ratio,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12 * ratio),
          borderSide: BorderSide(
            color: activeTeal,
            width: 1.6 * ratio,
          ),
        ),
      ),
      style: TextStyle(
        fontSize: 18 * ratio,
        height: 1.15,
      ),
      maxLines: 1,
      keyboardType: TextInputType.text,
      onSubmitted: onSubmitted,
    );
  }

  Widget _buildRegularTextField() {
    double fieldWidth = 400.0;
    if (withQueryButton) {
      fieldWidth = 120.0;
    }

    int maxLines = 1;
    if (typingType == TypingType.InputGame &&
        inputMethod == InputMethod.Others) {
      maxLines = 8;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: fieldWidth * ratio,
          child: TextField(
            autocorrect: false,
            enableSuggestions: false,
            controller: controller,
            focusNode: focusNode,
            autofocus: false,
            style: TextStyle(
              fontSize: 20 * ratio,
            ),
            maxLines: maxLines,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.black12,
            ),
          ),
        ),
        _buildQueryButton(),
      ],
    );
  }

  Widget _buildQueryButton() {
    if (!withQueryButton) {
      return const SizedBox(width: 0.0, height: 0.0);
    }

    return Container(
      child: IconButton(
        icon: Icon(
          Icons.search,
          size: 50.0 * ratio,
        ),
        color: Colors.lightBlueAccent,
        onPressed: onQueryPressed,
      ),
    );
  }
}
