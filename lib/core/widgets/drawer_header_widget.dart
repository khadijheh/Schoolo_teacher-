// lib/core/widgets/drawer_header_widget.dart
import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';
import 'package:schoolo_teacher/core/widgets/theme_toggle.dart';

class DrawerHeaderWidget extends StatelessWidget {
  final double animationValue;
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const DrawerHeaderWidget({
    super.key,
    required this.animationValue,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // ignore: deprecated_member_use
            primaryColor.withOpacity(0.8),
            animationValue > 0.5
                // ignore: deprecated_member_use
                ? secondaryColor.withOpacity(0.6)
                // ignore: deprecated_member_use
                : primaryColor.withOpacity(0.9),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: whiteColor,
                radius: 40,
                child: Icon(Icons.person, size: SizeConfig.screenWidth!*0.12, color: primaryColor),
              ),
              ThemeToggle(
                onToggleTheme: onToggleTheme,
                themeMode: themeMode,
              ),
            ],
          ),
          const VerticalSpace(2),
          Text(
            'Mr. Teacher',
            style: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.screenWidth != null 
                  ? SizeConfig.screenWidth! / 18 
                  : 24,
              shadows: [
                Shadow(
                  blurRadius: 8,
                  // ignore: deprecated_member_use
                  color: blockColor.withOpacity(0.5),
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),
          // Text(
          //   'Math & Science',
          //   style: TextStyle(
          //     color: secondaryColor,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ],
      ),
    );
  }
}