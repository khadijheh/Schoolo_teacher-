import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/drawer_header_widget.dart';
import 'package:schoolo_teacher/core/widgets/drawer_item.dart';
import 'package:schoolo_teacher/features/auth/presentation/pages/forget_password.dart';
import 'package:schoolo_teacher/features/profile/presentation/page/profile_page.dart';

class BuildDrawer extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;
  const BuildDrawer({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
    required String schoolName,
    required String teacherName,
  });

  @override
  State<BuildDrawer> createState() => _BuildDrawerState();
}

class _BuildDrawerState extends State<BuildDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _backgroundAnimation;
  late Animation<Color?> iconColorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animationController.value = widget.themeMode == ThemeMode.dark ? 1.0 : 0.0;

    _backgroundAnimation = ColorTween(begin: whiteColor, end: blockColor)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.fastEaseInToSlowEaseOut,
          ),
        );

    iconColorAnimation = ColorTween(begin: primaryColor, end: secondaryColor)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.fastEaseInToSlowEaseOut,
          ),
        );
  }

  @override
  void didUpdateWidget(covariant BuildDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.themeMode != widget.themeMode) {
      if (widget.themeMode == ThemeMode.dark) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Drawer(
          backgroundColor: _backgroundAnimation.value,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeaderWidget(
                animationValue: _animationController.value,
                onToggleTheme: widget.onToggleTheme,
                themeMode: widget.themeMode,
              ),
              DrawerItem(
                icon: Icons.key,
                title: 'account'.tr(), // ترجمة
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                animationValue: _animationController.value,
              ),
              DrawerItem(
                icon: Icons.lock_reset,
                title: 'reset_password'.tr(), // ترجمة
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgetPassword()),
                  );
                },
                animationValue: _animationController.value,
              ),
              // ignore: deprecated_member_use
              Divider(color: blockColor.withOpacity(0.3)),
              DrawerItem(
                icon: Icons.language,
                title: 'change_language'.tr(), // ترجمة
                onTap: () {
                  _showLanguageDialog(context);
                },
                animationValue: _animationController.value,
              ),
              DrawerItem(
                icon: Icons.logout,
                title: 'logout'.tr(), // ترجمة
                onTap: () {},
                animationValue: _animationController.value,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
           return AlertDialog(
              title: Text(
                'select_language'.tr(), // ترجمة
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth! / 20,
                  color: primaryColor,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.language,
                      color: Colors.blue,
                      size: SizeConfig.defualtSize! * 3,
                    ),
                    title: Text(
                      'english'.tr(), // ترجمة
                      style: TextStyle(fontSize: SizeConfig.screenWidth! / 20),
                    ),
                    onTap: () async {
                      await context.setLocale(Locale('en'));
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      setState(() {}); // إعادة بناء الواجهة
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      size: SizeConfig.defualtSize! * 3,
                      Icons.language,
                      color: Colors.green,
                    ),
                    title: Text(
                      'arabic'.tr(), // ترجمة
                      style: TextStyle(fontSize: SizeConfig.screenWidth! / 20),
                    ),
                    onTap: () async {
                      await context.setLocale(Locale('ar'));
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      setState(() {}); // إعادة بناء الواجهة
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
