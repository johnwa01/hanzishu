import 'package:flutter/material.dart';

class ExerciseCompleteDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onPressed;
  final IconData mascotIcon;
  final Color mascotColor;

  const ExerciseCompleteDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onPressed,
    this.mascotIcon = Icons.emoji_emotions,
    this.mascotColor = Colors.lightBlue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Container(
        width: 380.0,
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 92.0,
              height: 92.0,
              decoration: BoxDecoration(
                color: mascotColor.withOpacity(0.10),
                shape: BoxShape.circle,
                border: Border.all(
                  color: mascotColor.withOpacity(0.45),
                  width: 2.0,
                ),
              ),
              child: Icon(
                mascotIcon,
                size: 54.0,
                color: mascotColor,
              ),
            ),
            const SizedBox(height: 18.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18.0,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28.0),
            SizedBox(
              width: 150.0,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
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
