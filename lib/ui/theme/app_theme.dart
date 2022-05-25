import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// enum ThemeType { light, dark }

class AppTheme {
  const AppTheme._();
  static Color primaryColor = const Color(0xFFB64DFA);
  static Color accentColor = const Color(0xFF528FFE);
  static Color aux1Color = const Color(0xFF82D6FE);
  static Color aux2Color = const Color(0xFFEDF0F3);
  static Color red = Colors.redAccent;
  static Color blue = Colors.blue;
  static Color black = Colors.black;
  static Color grey = Colors.grey;
  static Color white = Colors.white;

  static Color lightBackgroundColor = const Color(0xFFF2F2F2);
  // static Color lightBackgroundColor = const Color(0xFFF2F2F2);
  // static Color lightBackgroundColor = const Color(0xFFF2F2F2);
  static Color lightParicleColor = const Color(0x44948282);

  static Color darkBackgroundColor = const Color(0xFF1A2127);
  static Color darkParicleColor = const Color(0x441C2A30);

  static final ThemeData lightTheme = ThemeData(
    iconTheme: IconThemeData(color: black),
    canvasColor: white,
    brightness: Brightness.light,
    backgroundColor: lightBackgroundColor,
    fontFamily: 'Nunito',
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: TextTheme(
      headline2:
          TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold, color: white),
      headline4:
          TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold, color: black),
      // headline3: TextStyle(fontSize: 34.sp, fontWeight: FontWeight.bold),
      headline5: TextStyle(fontSize: 13.sp, color: grey),
      button: TextStyle(color: white),
      headline6: TextStyle(
          color: black, fontSize: 15.sp, fontWeight: FontWeight.normal),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: black,
      elevation: 0,
      actionsIconTheme: IconThemeData(color: black),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
  );

  ////////////////////////////////////////////////////////////////////////

  static final ThemeData darkTheme = ThemeData(
    iconTheme: IconThemeData(color: white),
    canvasColor: black,
    brightness: Brightness.dark,
    backgroundColor: darkBackgroundColor,
    fontFamily: 'Nunito',
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: TextTheme(
      headline2:
          TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold, color: white),
      // headline3:  TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold, color: white) ,
      headline4:
          TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold, color: white),
      headline3: TextStyle(fontSize: 34.sp, fontWeight: FontWeight.bold),
      headline5: TextStyle(fontSize: 13.sp, color: white),
      button: TextStyle(color: white),
      headline6: TextStyle(
          color: white, fontSize: 15.sp, fontWeight: FontWeight.normal),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: black,
      elevation: 0,
      actionsIconTheme: IconThemeData(color: white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
  );
}
