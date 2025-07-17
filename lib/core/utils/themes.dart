import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
  
 
final ThemeData lightTheme = ThemeData(
  fontFamily: "SourGummy",
  brightness: Brightness.light,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: whiteColor,
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: whiteColor,
    iconTheme: const IconThemeData(color: whiteColor),
  ),
  drawerTheme: const DrawerThemeData(backgroundColor: whiteColor),
  colorScheme: const ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: whiteColor,
    onPrimary: whiteColor,
    onSecondary: blockColor,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: blockColor),
    bodyMedium: TextStyle(color: blockColor),
    titleLarge: TextStyle(color: blockColor),
  ),
  iconTheme: const IconThemeData(color: blockColor),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: whiteColor,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: primaryColor,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: whiteColor,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor, width: 2),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  fontFamily: "SourGummy",
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: blockColor,
  appBarTheme: AppBarTheme(
    backgroundColor: blockColor,
    foregroundColor: whiteColor,
    iconTheme: const IconThemeData(color: whiteColor),
  ),
  drawerTheme: const DrawerThemeData(backgroundColor: blockColor),
  colorScheme: const ColorScheme.dark(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: blockColor,
    onPrimary: blockColor,
    onSecondary: whiteColor,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: whiteColor),
    bodyMedium: TextStyle(color: Colors.white60),
    titleLarge: TextStyle(color: whiteColor),
  ),
  iconTheme: const IconThemeData(color: whiteColor),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: secondaryColor,
    foregroundColor: blockColor,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: secondaryColor,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: secondaryColor,
      foregroundColor: blockColor,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: secondaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: secondaryColor, width: 2),
    ),
  ),
);