import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';
import 'package:schoolo_teacher/features/subject/data/models/section_model.dart';
import 'package:schoolo_teacher/features/subject/presentation/widgets/info_item.dart';
import 'package:schoolo_teacher/features/subject/presentation/widgets/status_indicator..dart';
import 'package:schoolo_teacher/features/subject/presentation/widgets/stream_type_chip.dart';

class SectionCard extends StatelessWidget {
  final SectionModel section;
  final VoidCallback onTap;
  final VoidCallback onContentTap;
  final VoidCallback onExamTap;

  const SectionCard({
    super.key,
    required this.section,
    required this.onTap,
    required this.onContentTap,
    required this.onExamTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.screenHeight! / 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          child: InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: SizeConfig.screenWidth! / 5,
                    height: SizeConfig.screenHeight! / 10,
                    decoration: BoxDecoration(
                      color: _getStreamTypeColor(section.streamType)
                          // ignore: deprecated_member_use
                          .withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.screenWidth! / 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          StatusIndicator(section: section),
                          const HorizontalSpace(2),
                          Expanded(
                            child: Text(
                              section.name,
                              style: TextStyle(
                                fontSize: SizeConfig.screenWidth! / 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey[800],
                              ),
                            ),
                          ),
                          StreamTypeChip(section: section),
                        ],
                      ),
                      const VerticalSpace(3),
                      Divider(color: Colors.grey[300], height: 1, thickness: 2),
                      const VerticalSpace(2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InfoItem(
                            icon: Icons.people,
                            text:
                                '${section.capacity} ${'section.students'.tr()}',
                            color: Colors.indigo,
                          ).animate().scale(delay: 300.ms),
                          InfoItem(
                            icon: Icons.library_books,
                            text: 'section.content'.tr(),
                            color: Colors.deepPurple,
                            onTap: onContentTap,
                          ).animate().scale(delay: 200.ms),
                          InfoItem(
                            icon: Icons.assignment,
                            text: 'section.exams'.tr(),
                            color: primaryColor,
                            onTap: onExamTap,
                          ).animate().scale(delay: 100.ms),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
}
