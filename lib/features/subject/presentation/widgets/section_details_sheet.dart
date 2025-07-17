import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';
import 'package:schoolo_teacher/features/subject/data/models/section_model.dart';
import 'package:schoolo_teacher/features/subject/presentation/widgets/detail_row.dart';

class SectionDetailsSheet extends StatelessWidget {
  final SectionModel section;
  final VoidCallback onManageStudents;

  const SectionDetailsSheet({
    super.key,
    required this.section,
    required this.onManageStudents,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(70)),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: SizeConfig.defualtSize! * 3,
        left: SizeConfig.screenWidth! / 10,
        right: SizeConfig.screenWidth! / 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: SizeConfig.screenHeight! / 100,
            width: SizeConfig.screenWidth! / 6,
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: whiteColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Text(
            'section_details.title'.tr(),
            style: TextStyle(
              fontSize: SizeConfig.screenWidth! / 15,
              fontWeight: FontWeight.bold,
              color: whiteColor,
            ),
          ),
          const VerticalSpace(2),
          DetailRow(
            icon: Icons.class_,
            label: 'section_details.name'.tr(),
            value: section.name,
          ),
          DetailRow(
            icon: Icons.category,
            label: 'section_details.type'.tr(),
            value: _getStreamTypeName(section.streamType),
          ),
          DetailRow(
            icon: section.isActive ? Icons.check_circle : Icons.remove_circle,
            label: 'section_details.status'.tr(),
            value: section.isActive 
                ? 'section_details.active'.tr() 
                : 'section_details.inactive'.tr(),
            color: section.isActive ? Colors.green : Colors.red,
          ),
          DetailRow(
            icon: Icons.people,
            label: 'section_details.capacity'.tr(),
            value: '${section.capacity} ${'section_details.students'.tr()}',
          ),
          const VerticalSpace(3),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // ignore: deprecated_member_use
                    backgroundColor: primaryColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    elevation: 1,
                  ),
                  child: Text(
                    'section_details.manage_students'.tr(),
                    style: TextStyle(
                      fontSize: SizeConfig.screenWidth! / 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onManageStudents();
                  },
                ),
              ),
              const HorizontalSpace(2),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      width: 5,
                      // ignore: deprecated_member_use
                      color: whiteColor.withOpacity(0.1),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'common.cancel'.tr(),
                    style: TextStyle(
                      fontSize: SizeConfig.screenWidth! / 22,
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStreamTypeName(String streamType) {
    final type = streamType.toLowerCase();
    if (type == 'general') return 'section_types.general'.tr();
    if (type == 'scientific') return 'section_types.scientific'.tr();
    if (type == 'literary') return 'section_types.literary'.tr();
    return streamType;
  }
}