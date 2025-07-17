import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:schoolo_teacher/app_state.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/build_drawer.dart';
import 'package:schoolo_teacher/features/Announcement/presentation/pages/Announcement.dart';
import 'package:schoolo_teacher/features/schedule/presentation/pages/schedule_page.dart';
import 'package:schoolo_teacher/features/subject/presentation/pages/subject_view.dart';
import 'package:schoolo_teacher/features/profile/presentation/page/profile_page.dart';

class HomePageBody extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;
  const HomePageBody({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 0,
  );
  String? selectedSubject;
  String? selectedClass;
  String? selectedSection;
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  int maxCount = 4;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get isProfilePage => _currentPage == 3;
  @override
  Widget build(BuildContext context) {
    final double topSectionHeight = SizeConfig.screenHeight! / 5;
    bool isProfilePage =
        _currentPage == 3; // تحديد إذا كانت الصفحة الحالية هي البروفايل

    final List<Widget> bottomBarPages =
        [
              Consumer<AppState>(
                builder: (context, appState, child) {
                  return SubjectView();
                },
              ),
              Consumer<AppState>(
                builder: (context, appState, child) {
                  return SchedulePage();
                },
              ),
              Consumer<AppState>(
                builder: (context, appState, child) {
                  return AnnouncementsScreen();
                },
              ),

              Consumer<AppState>(
                builder: (context, appState, child) {
                  return ProfilePage();
                },
              ),
            ]
            .map(
              (page) => isProfilePage
                  ? page
                  : Padding(
                      padding: EdgeInsets.only(top: topSectionHeight),
                      child: page,
                    ),
            )
            .toList();

    return Scaffold(
      key: key,
      drawer: BuildDrawer(
        onToggleTheme: widget.onToggleTheme,
        themeMode: widget.themeMode,
        schoolName: 'MR.khadijhe',
        teacherName: 'T_schoolo',
      ),

      extendBody: true,
      body: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: bottomBarPages,
            ),

            if (!isProfilePage) ...[
              Container(
                height: SizeConfig.screenHeight! / 5,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
              Positioned(
                left: SizeConfig.screenWidth! / 45,
                top: SizeConfig.screenHeight! / 30,
                child: IconButton(
                  onPressed: () {
                    key.currentState?.openDrawer();
                  },
                  icon: Image.asset(
                    'images/left_panel_open.png',
                    width: SizeConfig.screenWidth! / 10,
                    height: SizeConfig.screenWidth! / 10,
                  ),
                ),
              ),
              Positioned(
                left: SizeConfig.screenWidth! / 6,
                top: SizeConfig.screenHeight! / 14,
                child: IconButton(
                  onPressed: () {},
                  icon: CircleAvatar(
                    backgroundColor: whiteColor,
                    radius: 40,
                    child: Icon(
                      Icons.person,
                      size: SizeConfig.screenWidth! / 8,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: SizeConfig.screenWidth! / 2.4,
                top: SizeConfig.screenHeight! / 8,
                child: Text(
                  "MR.khadijhe",
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth! / 14,
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                left: SizeConfig.screenWidth! / 1.4,
                top: SizeConfig.screenHeight! / 18,
                child: Text(
                  "T_SCHOOLO",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.screenWidth! / 23,
                    color: secondaryColor,
                  ),
                ),
              ),
              Positioned(
                right: SizeConfig.screenWidth! / 40,
                top: SizeConfig.screenHeight! / 35,
                child: Text(
                  _getCurrentDate(context),
                  style: TextStyle(
                    color: blockColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),

      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
       
        showLabel: true,
        shadowElevation: 15,
        kBottomRadius: 32.0,
        notchColor: primaryColor,
        removeMargins: false,
        bottomBarWidth: MediaQuery.of(context).size.width * 0.9,
        durationInMilliSeconds: 600,
        itemLabelStyle: TextStyle(
          // fontSize: SizeConfig.defualtSize!*4,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 2,
              // ignore: deprecated_member_use
              color: blockColor.withOpacity(0.3),
              offset: Offset(1, 1),
            ),
          ],
        ),
        elevation: 1,
        bottomBarItems: [
          BottomBarItem(
            itemLabelWidget: Text(
              'home'.tr(),
              style: TextStyle(
                color: primaryColor,
                fontSize: SizeConfig.defualtSize!*1.5,
              ),
            ),
            inActiveItem: Icon(Icons.home, color: primaryColor),
            activeItem: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [secondaryColor, primaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: secondaryColor.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: EdgeInsets.all(8),
              child: Icon(Icons.home, color: whiteColor),
            ),
          ),
          BottomBarItem(
            itemLabelWidget: Text(
              'schedule'.tr(),
              style: TextStyle(
                color: primaryColor,
                fontSize:SizeConfig.defualtSize!*1.3,
              ),
            ),
            inActiveItem: Icon(Icons.calendar_today, color: primaryColor),
            activeItem: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [secondaryColor, primaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: secondaryColor.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: EdgeInsets.all(8),
              child: Icon(Icons.calendar_today, color: whiteColor),
            ),
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.notifications_active_outlined,
              color: primaryColor,
            ),
            activeItem: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [secondaryColor, primaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [whiteColor, secondaryColor],
                    stops: [0.0, 1.0],
                  ).createShader(bounds);
                },
                child: Icon(
                  Icons.notifications_active_outlined,
                  size: SizeConfig.screenWidth! / 15,
                  color: whiteColor,
                ),
              ),
            ),
            itemLabelWidget: Text(
              'notifications'.tr(),
              style: TextStyle(
                color: primaryColor,
                fontSize: SizeConfig.defualtSize!*1.3
              ),
            ),
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.person, color: primaryColor),
            activeItem: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [secondaryColor, primaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [whiteColor, whiteColor],
                    stops: [0.0, 1.0],
                  ).createShader(bounds);
                },
                child: Icon(
                  Icons.person,
                  size: SizeConfig.screenWidth! / 15,
                  color: whiteColor,
                ),
              ),
            ),
            itemLabelWidget: Text(
             "profilebotton".tr(),
              style: TextStyle(
                color: primaryColor,
                fontSize: SizeConfig.defualtSize!*1.1,
              ),
            ),
          ),
        ],
        onTap: (index) {
          setState(() => _currentPage = index);
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        kIconSize: SizeConfig.screenWidth! / 15,
      ),
    );
  }
}
String _getCurrentDate(BuildContext context) {
  final now = DateTime.now();
  final formatter = DateFormat('EEEE, d MMMM y', context.locale.toString());
  return formatter.format(now);
}