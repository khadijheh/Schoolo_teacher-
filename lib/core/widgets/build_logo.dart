import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';

class BuildLogo extends StatefulWidget {
  const BuildLogo({super.key});

  @override
  State<BuildLogo> createState() => _BuildLogoState();
}

class _BuildLogoState extends State<BuildLogo> {
  @override
  Widget build(BuildContext context) {
return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 30),
      child: Image.asset(
        "images/logo.jpg",
        height: SizeConfig.screenHeight! / 5,
        fit: BoxFit.contain,
      ),
    );  }
}