import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback? onTap;

  const InfoItem({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.screenHeight! / 60,
          horizontal: SizeConfig.screenWidth! / 28,
        ),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: SizeConfig.screenWidth! / 18,
                color: color,
              ),
            ),
            const VerticalSpace(0.5),
            Text(
              text,
              style: TextStyle(
                fontSize: SizeConfig.screenWidth! / 25,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}