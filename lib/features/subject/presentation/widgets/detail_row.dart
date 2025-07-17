import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.screenHeight! / 100,
        horizontal: SizeConfig.screenWidth! / 15,
      ),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color ?? primaryColor,
            size: SizeConfig.screenWidth! / 18,
          ),
          const HorizontalSpace(1),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: SizeConfig.screenWidth! / 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: SizeConfig.screenWidth! / 22,
              color: Colors.blueGrey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}