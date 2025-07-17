import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';

class EmptyClassState extends StatelessWidget {
  const EmptyClassState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: SizeConfig.screenWidth! * 0.2,
            color: Colors.grey,
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          Text(
            'Not found of class now',
            style: TextStyle(
              fontSize: SizeConfig.screenWidth! * 0.05,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}