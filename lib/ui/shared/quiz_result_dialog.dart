import 'package:flutter/material.dart';

class QuizResultDialog extends StatelessWidget {
  final String title;
  final String scoreText;
  final String content;
  final String buttonText;
  final VoidCallback onPressed;

  const QuizResultDialog({
    Key? key, // super.key, for newer version
    required this.title,
    required this.scoreText,
    required this.content,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.green.shade300,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.sentiment_very_satisfied,
                size: 52,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              scoreText,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 140,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
