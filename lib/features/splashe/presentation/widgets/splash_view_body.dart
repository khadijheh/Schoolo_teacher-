import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
   void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        Navigator.pushReplacementNamed(context, "onboarding");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Stack(
      children: [
       Positioned(
          top: SizeConfig.screenHeight! * 0.15,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              width: SizeConfig.screenWidth! * 0.8, 
              child: Image.asset("images/splash.png", fit: BoxFit.contain),
            ),
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: SizeConfig.screenHeight! * 0.15),
            child:  CircularProgressIndicator(
              color: secondaryColor,
              strokeWidth: 3,
            ),
          ),
        ),
      ],
    );
  }
}
