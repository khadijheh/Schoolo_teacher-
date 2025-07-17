import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/features/subject/data/models/section_model.dart';

class StatusIndicator extends StatelessWidget {
  final SectionModel section;

  const StatusIndicator({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: section.isActive
            // ignore: deprecated_member_use
            ? Colors.green.withOpacity(0.1)
            // ignore: deprecated_member_use
            : Colors.red.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        section.isActive ? Icons.check_circle : Icons.remove_circle,
        color: section.isActive ? Colors.green : Colors.red,
        size: SizeConfig.screenWidth! / 15,
      ),
    );
  }
}