// lib/core/widgets/drawer_item.dart
import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final double animationValue;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Color.lerp(
          primaryColor,
          secondaryColor, 
          animationValue,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Color.lerp(
            blockColor,
            whiteColor,
            animationValue,
          ),
          fontSize: SizeConfig.screenWidth != null 
              ? SizeConfig.screenWidth! / 25 
              : 16,
        ),
      ),
      onTap: onTap,
    );
  }
}