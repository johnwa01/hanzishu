import 'package:flutter/material.dart';

enum HzProgressThickness {
  thin,
  thick,
}

class HzProgressIndicator extends StatelessWidget {
  final double value;
  final int current;
  final int total;
  final HzProgressThickness thickness;
  final bool showCount;
  final Color? color;
  final Color? backgroundColor;

  const HzProgressIndicator({
    Key? key,
    required this.value,
    required this.current,
    required this.total,
    this.thickness = HzProgressThickness.thin,
    this.showCount = true,
    this.color,
    this.backgroundColor,
  }) : super(key: key);

  double get _height {
    switch (thickness) {
      case HzProgressThickness.thick:
        return 8.0;
      case HzProgressThickness.thin:
      default:
        return 3.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeTotal = total < 0 ? 0 : total;
    final safeCurrent = current < 0 ? 0 : current;
    final safeValue = value.isNaN ? 0.0 : value.clamp(0.0, 1.0).toDouble();

    return Row(
      children: <Widget>[
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_height),
            child: LinearProgressIndicator(
              value: safeValue,
              minHeight: _height,
              valueColor: color == null
                  ? null
                  : AlwaysStoppedAnimation<Color>(color!),
              backgroundColor: backgroundColor,
            ),
          ),
        ),
        if (showCount) ...[
          const SizedBox(width: 10.0),
          Text(
            '$safeCurrent / $safeTotal',
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ],
    );
  }
}
