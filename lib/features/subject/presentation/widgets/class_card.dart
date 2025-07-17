import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';
import 'package:schoolo_teacher/features/subject/data/models/class_model.dart';
import 'package:schoolo_teacher/features/subject/presentation/widgets/stat_item.dart';

class ClassCard extends StatelessWidget {
  final ClassModel classItem;
  final int index;
  final VoidCallback onTap;

  const ClassCard({
    super.key,
    required this.classItem,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = classGradients[index % classGradients.length];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: blockColor.withOpacity(0.7),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -SizeConfig.screenHeight! / 50,
              right: -SizeConfig.screenWidth! / 20,
              child: Container(
                width: SizeConfig.screenWidth! * 0.25,
                height: SizeConfig.screenWidth! * 0.25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // ignore: deprecated_member_use
                  color: whiteColor.withOpacity(0.19),
                ),
              ),
            ),
            Positioned(
              bottom: -SizeConfig.screenHeight! / 30,
              left: -SizeConfig.screenWidth! / 30,
              child: Container(
                width: SizeConfig.screenWidth! * 0.25,
                height: SizeConfig.screenWidth! * 0.25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // ignore: deprecated_member_use
                  color: whiteColor.withOpacity(0.05),
                ),
              ),
            ),
            _buildCardContent(context),
          ],
        ),
      ).animate().scale(),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.defualtSize! * 1.0,
        vertical: SizeConfig.defualtSize! * 1.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildHeaderRow(),
          const VerticalSpace(1.5),
          _buildDescription(),
          const Spacer(),
          _buildStatsRow(context),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(SizeConfig.defualtSize! * 0.9),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // ignore: deprecated_member_use
            color: whiteColor.withOpacity(0.2),
          ),
          child: Icon(
            Icons.school,
            color: blockColor,
            size: SizeConfig.screenWidth! / 10,
          ),
        ),
        const HorizontalSpace(2),
        Expanded(
          child: Text(
            classItem.name,
            style: TextStyle(
              fontSize: SizeConfig.screenWidth! / 20,
              fontWeight: FontWeight.bold,
              color: blockColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      classItem.description,
      style: TextStyle(
        // ignore: deprecated_member_use
        color: blockColor.withOpacity(0.8),
        fontSize: SizeConfig.screenWidth! / 25,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: StatItem(
                icon: Icons.people,
                value: '${classItem.studentCount} ${'class_levels.students'.tr()}',
                color: blockColor,
                fontSize: SizeConfig.screenWidth! / 28,
              ),
            ),
            SizedBox(width: constraints.maxWidth * 0.05),
            Flexible(
              child: StatItem(
                icon: Icons.class_,
                value: '${classItem.sections.length} ${'class_levels.sections'.tr()}',
                color: blockColor,
                fontSize: SizeConfig.screenWidth! / 28,
              ),
            ),
          ],
        );
      },
    );
  }
}