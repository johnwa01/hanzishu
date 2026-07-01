import 'package:flutter/material.dart';

class TutorialStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double ratio;
  final Color primaryColor;

  const TutorialStepIndicator({
    Key? key,
    required this.currentStep,
    required this.ratio,
    this.totalSteps = 5,
    this.primaryColor = const Color(0xFF6F35E8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connectorWidth =
    MediaQuery.of(context).size.width < 700
        ? 24 * ratio
        : 50 * ratio;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isOdd) {
          final leftStep = index ~/ 2 + 1;

          return Container(
            width: connectorWidth,
            height: 3 * ratio,
            decoration: BoxDecoration(
              color: leftStep < currentStep
                  ? primaryColor
                  : const Color(0xFFD6D9E3),
              borderRadius: BorderRadius.circular(99),
            ),
          );
        }

        final step = index ~/ 2 + 1;

        final isCompleted = step < currentStep;
        final isCurrent = step == currentStep;

        return _buildStepCircle(
          step,
          isCompleted,
          isCurrent,
        );
      }),
    );
  }

  Widget _buildStepCircle(
      int step,
      bool isCompleted,
      bool isCurrent,
      ) {
    final size = 40 * ratio;

    if (isCompleted) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primaryColor,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.25),
              blurRadius: 8 * ratio,
              offset: Offset(0, 3 * ratio),
            ),
          ],
        ),
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 20 * ratio,
        ),
      );
    }

    if (isCurrent) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primaryColor,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.25),
              blurRadius: 8 * ratio,
              offset: Offset(0, 3 * ratio),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$step',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18 * ratio,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFC9CFDA),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '$step',
          style: TextStyle(
            color: const Color(0xFF8B93A5),
            fontSize: 20 * ratio,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}