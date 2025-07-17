import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/features/subject/data/models/section_model.dart';

class StreamTypeChip extends StatelessWidget {
  final SectionModel section;

  const StreamTypeChip({super.key, required this.section});

  Color _getStreamTypeColor(String streamType) {
    switch (streamType.toLowerCase()) {
      case 'general':
        return const Color(0xFF6A11CB);
      case 'scientific':
        return const Color(0xFF00B09B);
      case 'literary':
        return const Color(0xFFF46B45);
      default:
        return primaryColor;
    }
  }

  String _getStreamTypeName(String streamType) {
    switch (streamType.toLowerCase()) {
      case 'general':
        return 'عام';
      case 'scientific':
        return 'علمي';
      case 'literary':
        return 'أدبي';
      default:
        return streamType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStreamTypeColor(section.streamType);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        // ignore: deprecated_member_use
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        _getStreamTypeName(section.streamType),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: SizeConfig.screenWidth! / 28,
        ),
      ),
    );
  }
}