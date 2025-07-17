import 'package:flutter/material.dart';
import 'package:onboarding_intro_screen/onboarding_screen.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';

class OnBoardingBody extends StatelessWidget {
  //   final List<Introduction> list = [
  //   Introduction(
  //     title: 'School Notifications',
  //     subTitle: 'Receive real-time alerts about announcements, events, and important school updates',
  //     imageUrl: 'images/onboarding1.png',
  //   ),
  //   Introduction(
  //     title: 'Student Grading',
  //     subTitle: 'Record and manage academic performance with our easy-to-use grading system',
  //     imageUrl: 'assets/images/grading.png',
  //   ),
  //     Introduction(
  //     title: 'Daily Schedule',
  //     subTitle: 'View your daily class timetable with subjects, times, and classroom locations at a glance',
  //     imageUrl: 'assets/images/daily_schedule.png',
  //   ),
  //   Introduction(
  //     title: 'Educational Resources',
  //     subTitle: 'Share learning materials including videos, images, and documents with your class',
  //     imageUrl: 'assets/images/content_upload.png',
  //   ),
  //   Introduction(
  //     title: 'Behavior Evaluation',
  //     subTitle: 'Track and assess student behavior, participation, and classroom conduct',
  //     imageUrl: 'assets/images/behavior_tracking.png',
  //   ),
  // ];

  const OnBoardingBody({super.key});
  @override
  Widget build(BuildContext context) {
    return OnBoardingScreen(
      onSkip: () {
        Navigator.popAndPushNamed(context, "signIn");
      },
      showPrevNextButton: true,
      showIndicator: true,
      backgourndColor: Colors.white,
      activeDotColor: primaryColor,
      animationDuration: Duration(microseconds: 1000),
      deactiveDotColor: Colors.grey,
      iconColor: primaryColor,
      leftIcon: Icons.arrow_circle_left_rounded,
      rightIcon: Icons.arrow_circle_right_rounded,
      iconSize: SizeConfig.screenWidth! / 8,
      pages: [
        OnBoardingModel(
          titleColor: primaryColor,
          titleFontSize: SizeConfig.screenWidth! / 15,
          bodyFontSize: SizeConfig.screenWidth! / 22,
          image: Image.asset("images/l1.png"),

          title: "Educational Resources",
          body:
              "Share learning materials including videos, images, and documents with your class",
        ),
        OnBoardingModel(
          titleColor: primaryColor,
          titleFontSize: SizeConfig.screenWidth! / 15,
          bodyFontSize: SizeConfig.screenWidth! / 22,
          image: Image.asset("images/l2.png"),
          title: "Behavior Evaluation",
          body:
              "Track and assess student behavior, participation, and classroom conduct",
        ),

        OnBoardingModel(
          titleColor: primaryColor,
          titleFontSize: SizeConfig.screenWidth! / 15,
          bodyFontSize: SizeConfig.screenWidth! / 22,
          image: Image.asset("images/l3.jpg"),
          title: "Daily Schedule",
          body:
              "View your daily class timetable with subjects, times, and classroom locations at a glance",
        ),
        OnBoardingModel(
          titleColor: primaryColor,
          titleFontSize: SizeConfig.screenWidth! / 15,
          bodyFontSize: SizeConfig.screenWidth! / 22,
          image: Image.asset("images/l4.jpg"),
          title: "Student Grading",
          body:
              'Record and manage academic performance with our easy-to-use grading system',
        ),
        OnBoardingModel(
          titleColor: primaryColor,
          titleFontSize: SizeConfig.screenWidth! / 15,
          bodyFontSize: SizeConfig.screenWidth! / 22,
          image: Image.asset("images/l5.jpg"),
          title: "School Notifications",
          body:
              'Receive real-time alerts about announcements, events, and important school updates',
        ),
      ],
    );
  }
}
