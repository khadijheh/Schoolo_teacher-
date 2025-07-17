import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';

class EmptySchedule extends StatelessWidget {
  const EmptySchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
                Icons.calendar_today,
                size: SizeConfig.defualtSize! * 14,
                // ignore: deprecated_member_use
                color: primaryColor.withOpacity(0.3),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms)
              .scaleXY(begin: 0.9, end: 1.1, duration: 2000.ms),
          const VerticalSpace(1),
          Text(
            'no_classes_today'.tr(),
            style: TextStyle(
              fontSize: SizeConfig.screenWidth! / 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3436),
            ),
          ).animate().fadeIn(delay: 300.ms),
          const VerticalSpace(1),
          Text(
            'enjoy_free_time'.tr(), 

            style: TextStyle(
              fontSize: SizeConfig.screenWidth! / 22,
              color: const Color(0xFF636E72),
            ),
          ).animate().fadeIn(delay: 500.ms),
          const VerticalSpace(1),
        ],
      ),
    );
  }
}
