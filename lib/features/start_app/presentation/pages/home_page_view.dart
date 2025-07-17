import 'package:flutter/material.dart';
import 'package:schoolo_teacher/features/start_app/presentation/widgets/home_page_body.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePageBody(onToggleTheme: _toggleTheme, themeMode: _themeMode),
    );
  }
}
