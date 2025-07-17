import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';

class SectionLoadingIndicator extends StatelessWidget {
  const SectionLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: SizeConfig.screenWidth! / 8,
            height: SizeConfig.screenHeight! / 15,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(
                // ignore: deprecated_member_use
                secondaryColor.withOpacity(0.7),
              ),
            ),
          ),
          const VerticalSpace(2),
          Text(
            'sections.loadSection'.tr(),
            style: TextStyle(
              fontSize: SizeConfig.screenWidth! / 20,
              // ignore: deprecated_member_use
              color: primaryColor.withOpacity(0.5),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}