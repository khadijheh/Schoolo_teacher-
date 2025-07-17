import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  final double fontSize;

  const StatItem({
    super.key,
    required this.icon,
    required this.value,
    required this.color,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: fontSize * 1.2, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}