import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';

class HorizontalSpace extends StatelessWidget {
  const HorizontalSpace(this.value, {super.key});
  final double? value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: SizeConfig.defualtSize! * value!);
  }
}

class VerticalSpace extends StatelessWidget {
  const VerticalSpace(this.value, {super.key});
  final double? value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: SizeConfig.defualtSize! * value!);
  }
}
