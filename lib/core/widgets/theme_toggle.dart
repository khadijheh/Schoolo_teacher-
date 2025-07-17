// lib/core/widgets/theme_toggle.dart
import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';

class ThemeToggle extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;
  
  const ThemeToggle({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggleTheme,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: blockColor.withOpacity(0.3),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return RotationTransition(
              turns: Tween(begin: 0.5, end: 1.0).animate(animation),
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: themeMode == ThemeMode.light
              ? Icon(
                  Icons.dark_mode,
                  key: const ValueKey('dark'),
                  color: whiteColor,
                  size: SizeConfig.screenWidth! / 19,
                )
              : Icon(
                  Icons.light_mode,
                  key: const ValueKey('light'),
                  color: whiteColor,
                  size: SizeConfig.screenWidth! / 19,
                ),
        ),
      ),
    );
  }
}