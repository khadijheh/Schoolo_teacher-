import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: SizeConfig.screenWidth!/20,
          fontWeight: FontWeight.w600,
          color: blockColor,
          ),
        ),
      ],
    );
  }
}