import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/features/schedule/presentation/pages/schedule_item.dart';

class TimeCard extends StatelessWidget {
  final ScheduleItem item;

  const TimeCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: SizeConfig.screenWidth! / 20),
      child: GlassmorphicContainer(
        width: SizeConfig.defualtSize! * 4,
        height: SizeConfig.defualtSize! * 6,
        borderRadius: 25,
        blur: 20,
        alignment: Alignment.centerLeft,
        linearGradient: LinearGradient(
          colors: [
            // ignore: deprecated_member_use
            Colors.white.withOpacity(0.2),
            // ignore: deprecated_member_use
            primaryColor.withOpacity(0.1),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            // ignore: deprecated_member_use
            Colors.white.withOpacity(0.2),
            // ignore: deprecated_member_use
            primaryColor.withOpacity(0.1),
          ],
        ),
        border: 0.5,
        child: Text(
          item.time,
          style: TextStyle(
            fontSize: SizeConfig.screenWidth! / 30,
            fontWeight: FontWeight.bold,
          
          ),
        ),
      ).animate().fadeIn(delay: 200.ms),
    );
  }
}