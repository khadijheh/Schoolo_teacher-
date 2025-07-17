import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';
import 'package:schoolo_teacher/features/schedule/presentation/pages/schedule_item.dart';

class ScheduleItemCard extends StatelessWidget {
  final ScheduleItem item;
  final VoidCallback onTap;

  const ScheduleItemCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.screenWidth! / 20,
        top: SizeConfig.defualtSize! * 1.5,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: GlassmorphicContainer(
          width: SizeConfig.defualtSize! * 25,
          height: SizeConfig.defualtSize! * 15,
          borderRadius: 20,
          blur: 20,
          alignment: Alignment.center,
          linearGradient: LinearGradient(
            colors: [
              // ignore: deprecated_member_use
              primaryColor.withOpacity(0.7),
              // ignore: deprecated_member_use
              Colors.white.withOpacity(0.6),
            ],
          ),
          borderGradient: LinearGradient(
            colors: [
              // ignore: deprecated_member_use
              Colors.white.withOpacity(0.9),
              // ignore: deprecated_member_use
              Colors.white.withOpacity(0.7),
            ],
          ),
          border: 1,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    item.subject,
                    style: TextStyle(
                      fontSize: SizeConfig.screenWidth! / 25,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ).animate().fadeIn(delay: 300.ms),
                ),
                const VerticalSpace(3),
                Row(
                  children: [
                    Icon(
                      Icons.room,
                      size: SizeConfig.defualtSize! * 1.8,
                      color: primaryColor,
                    ),
                    const HorizontalSpace(0.5),
                    Expanded(
                      child: Text(
                        item.classroom,
                        style: TextStyle(
                          fontSize: SizeConfig.screenWidth! / 28,
                          color: primaryColor
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ].animate(interval: 100.ms).fadeIn().slideX(),
                ),
              ],
            ),
          ),
        ),
      ).animate().scale(delay: 200.ms),
    );
  }
}