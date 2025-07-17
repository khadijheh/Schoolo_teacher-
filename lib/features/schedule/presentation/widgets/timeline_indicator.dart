import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/features/schedule/presentation/pages/schedule_item.dart';

class TimelineIndicator extends StatelessWidget {
  final ScheduleItem item;

  const TimelineIndicator({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          // ignore: deprecated_member_use
          colors: [item.color.withOpacity(0.8), item.color.withOpacity(0.4)],
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: item.color.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          item.icon,
          color: Colors.white,
          size: SizeConfig.defualtSize! * 3,
        ).animate().scale(delay: 200.ms),
      ),
    ).animate().rotate(delay: 100.ms);
  }
}