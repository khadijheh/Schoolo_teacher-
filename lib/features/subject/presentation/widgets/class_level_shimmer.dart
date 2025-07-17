import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';

class ClassLevelShimmer extends StatelessWidget {
  const ClassLevelShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.08),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: SizeConfig.screenHeight! / 5,
        crossAxisCount: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}