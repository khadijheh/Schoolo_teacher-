import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';

class EmptySectionState extends StatelessWidget {
  const EmptySectionState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.class_,
              size: SizeConfig.defualtSize! * 10,
              color: primaryColor,
            ),
          ),
          const VerticalSpace(3),
          Text(
            'No valid section now ....',
            style: TextStyle(
              fontSize: SizeConfig.screenWidth! / 18,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const VerticalSpace(1),
        ],
      ),
    );
  }
}